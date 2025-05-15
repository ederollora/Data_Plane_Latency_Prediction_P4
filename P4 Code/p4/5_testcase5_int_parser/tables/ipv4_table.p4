
table forward {
    key = {
        hdr.ipv4.srcAddr: exact;
        hdr.ipv4.dstAddr: exact;
    }
    actions = {
        forward_ipv4;
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 50;
}