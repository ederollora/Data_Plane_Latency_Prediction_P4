
table forward {
    key = {
        hdr.ipv4.srcAddr: exact;
        hdr.ipv4.dstAddr: exact;
        meta.srcPort: exact;
        meta.dstPort: exact;
    }
    actions = {
        forward_ipv4;
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 5000;
}