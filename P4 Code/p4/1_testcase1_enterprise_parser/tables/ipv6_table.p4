
table ipv6_forward {
    key = {
        hdr.ipv6.srcAddr: exact; // 128 bits
        hdr.ipv6.dstAddr: exact;
        //hdr.ipv6.dstAddr: lpm;
    }
    actions = {
        forward;
        drop_pkt;
        NoAction;
        //someAction;
    }
    default_action = NoAction;
    size = 10000;
}