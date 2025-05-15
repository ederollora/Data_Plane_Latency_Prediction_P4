action forward_ipv4 ( bit<9> port) {
    ig_tm_md.ucast_egress_port = port;
    //hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    //hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
    //hdr.ethernet.dstAddr = nextAddr;
}
