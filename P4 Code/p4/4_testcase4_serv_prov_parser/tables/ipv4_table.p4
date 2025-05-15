
table ipv4_fwd {
    key = {
        hdr.ipv4.dstAddr: lpm;
    }
    actions = {
        forward_ipv4;
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 1000;
}