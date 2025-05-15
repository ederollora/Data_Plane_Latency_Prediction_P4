
action forward(macAddr_t nextAddr, bit<9> port){
    ig_tm_md.ucast_egress_port = (bit<9>)port;
    //hdr.ethernet.srcAddr = hdr.ethernet.dstAddr; // Seems like something fails with this statement. Reporting...
    //hdr.ethernet.dstAddr = nextAddr;
    hdr.ipv6.hopLimit = hdr.ipv6.hopLimit - 1;
}