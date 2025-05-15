
#ifdef WITH_MOD_FIELDS
    action mpls_swap(bit<20> newLabel, bit<9> port){
        ig_tm_md.ucast_egress_port = port;
        hdr.mpls[2].label_id = newLabel;
        hdr.mpls[2].ttl = hdr.mpls[2].ttl - 1;
    }
#else
    action mpls_swap(bit<9> port){
        ig_tm_md.ucast_egress_port = port;
    }
#endif