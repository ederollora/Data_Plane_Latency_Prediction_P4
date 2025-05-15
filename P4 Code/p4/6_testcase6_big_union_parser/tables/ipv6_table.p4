
table ipv6_forward {
    key = {
        hdr.ipv6.dstAddr: lpm;
    }
    actions = {
        fwd_ipv6;
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 30000;
}