

table l2_forward {
    key = {
        hdr.ethernet.srcAddr: exact;
        hdr.ethernet.dstAddr: exact;
    }
    actions = {
        forward_eth;
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 5000;
}