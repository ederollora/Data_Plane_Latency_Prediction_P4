
//action forward_ipv4 (macAddr_t dstAddr, bit<9> port) {
action forward_ipv4 (bit<9> port) {
    //hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
    //hdr.ethernet.dstAddr = dstAddr;
    //hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    ig_tm_md.ucast_egress_port = port;
}
