
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
    #include"actions/ipv6_actions.p4"
    // python3.7 ../../test_scripts/rule_creator.py vlan_check NoAction srcAddr:vlanId exact:exact 
    // 48:12 0:0 _:_ 0/0 1000 ../../test_scripts/rules rules1.txt
    #include"tables/vlan_table.p4"
    // python3.7 ../../test_scripts/rule_creator.py ipv6_forward forward srcAddr:dstAddr exact:exact 
    // 128:128 0:0 nextAddr:port 11/2 10000 ../../test_scripts/rules rules1.txt
    #include"tables/ipv6_table.p4"
    // python3.7 ../../test_scripts/rule_creator.py l4_acl NoAction dstAddr:dstPort exact:exact 
    // 128:16 128:0 _:_ 0/0 1000 ../../test_scripts/rules rules1.txt
    #include"tables/udp_table.p4"
#endif

    apply{

#ifdef WITH_TABLES
        if(hdr.inner_vlan.isValid()){
            vlan_check.apply();
        }

        if(hdr.ipv6.isValid()){
            ipv6_forward.apply();
        }

        if(hdr.tcp.isValid() || hdr.udp.isValid()){
            l4_acl.apply();
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
        
    #ifdef CHECK
        if(hdr.outer_vlan.isValid() && hdr.inner_vlan.isValid() && hdr.ipv6.isValid() && hdr.udp.isValid()){
            hdr.check.setValid();
            hdr.check.a = 0x12121212;
            hdr.check.b = 0x34343434;
            hdr.check.c = 0x56565656;
            hdr.check.d = 0x78787878;
        }
    #endif    
    }
}
