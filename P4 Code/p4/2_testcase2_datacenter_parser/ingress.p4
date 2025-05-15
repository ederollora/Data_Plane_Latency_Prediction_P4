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

#ifdef WITH_TABLES
    #include"actions/ipv4_actions.p4"

    #include"tables/ipv4_table.p4"
#endif

    apply{


#ifdef WITH_TABLES
        if(hdr.ipv4.isValid() && (hdr.tcp.isValid() || hdr.udp.isValid())){
            forward.apply();
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

    #ifdef CHECK
        if(hdr.ipv4.isValid() && hdr.udp.isValid() && hdr.vxlan.isValid() && hdr.inner_ethernet.isValid()){
            hdr.check.setValid();
            hdr.check.a = 0x12121212;
            hdr.check.b = 0x34343434;
            hdr.check.c = 0x56565656;
            hdr.check.d = 0x78787878;
        }
    #endif

        hdr.ts_ingress.setValid();
        hdr.ts_ingress.ts1 = ig_intr_md.ingress_mac_tstamp;
        hdr.ts_ingress.ts2 = ig_prsr_md.global_tstamp;
    }

}
