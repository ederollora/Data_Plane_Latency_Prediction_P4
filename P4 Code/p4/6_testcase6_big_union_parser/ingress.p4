control Ingress(
                /* User */
                inout my_ingress_headers_t                       hdr,
                inout my_ingress_metadata_t                      meta,
                /* Intrinsic */
                in    ingress_intrinsic_metadata_t               ig_intr_md,
                in    ingress_intrinsic_metadata_from_parser_t   ig_prsr_md,
                inout ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md,
                inout ingress_intrinsic_metadata_for_tm_t        ig_tm_md)
{
#ifdef WITH_ING_SAMPLER
    Random<bit<10>>() randomNum;
#endif

    action drop_pkt() {
        ig_dprsr_md.drop_ctl = 1;
    }

#ifdef WITH_TABLES_1
    #include"actions/eth_actions.p4"
    #include"tables/eth_table.p4"
    #include"tables/nvgre_table.p4"

#endif

#ifdef WITH_TABLES_2
    #include"actions/ipv6_actions.p4"
    #include"actions/ipsec_actions.p4"
    #include"tables/ipv6_table.p4"
    #include"tables/ipsec_table.p4"
#endif

   apply{

#ifdef WITH_TABLES_1
        if(hdr.ipv4.isValid()){
            l2_forward.apply();
            nvgre_check_flow_id.apply();
            
        }
#elif WITH_TABLES_2

        if(hdr.ipv6.isValid()){
            ipv6_forward.apply();
        }

        if(hdr.ipsec_esp.isValid()){
            ipsec_check.apply();
        }
#else
        ig_tm_md.ucast_egress_port = (bit<9>)2;
#endif

#ifdef WITH_ING_SAMPLER
        bit<10> num = randomNum.get();

    #ifdef PERCENT_10
        if (num > 102){ 
    #elif PERCENT_1
        if (num > 10){
    #endif
            drop_pkt();
        }
#endif

        hdr.ts_ingress.setValid();
        hdr.ts_ingress.ts1 = ig_intr_md.ingress_mac_tstamp;
        hdr.ts_ingress.ts2 = ig_prsr_md.global_tstamp;

    }

}
