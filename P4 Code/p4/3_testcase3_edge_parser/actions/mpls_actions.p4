// ~/tools/p4_build.sh switch.p4 P4PPFLAGS="-DWITH_TABLES -DWITH_MOD_FIELDS_1A2 -DWITH_ING_SAMPLER -DPERCENT_10"

#ifdef WITH_MOD_FIELDS_2
    action mpls_swap(bit<20> newLabel, bit<9> port){
        ig_tm_md.ucast_egress_port = port;
        hdr.mpls[2].label_id = newLabel;
        hdr.mpls[2].ttl = hdr.mpls[2].ttl - 1;
    }
#elif WITH_MOD_FIELDS_1A
    action mpls_swap(bit<20> newLabel, bit<9> port){
        ig_tm_md.ucast_egress_port = port;
        hdr.mpls[2].ttl = hdr.mpls[2].ttl - 1;
    }
#elif WITH_MOD_FIELDS_1A2
    action mpls_swap(bit<9> port){
        ig_tm_md.ucast_egress_port = port;
        hdr.mpls[2].ttl = hdr.mpls[2].ttl - 1;
    }
#elif WITH_MOD_FIELDS_1B
    action mpls_swap(bit<20> newLabel, bit<9> port){
        ig_tm_md.ucast_egress_port = port;
        hdr.mpls[2].label_id = newLabel;
    }
#else
    action mpls_swap(bit<9> port){
        ig_tm_md.ucast_egress_port = port;
    }
#endif