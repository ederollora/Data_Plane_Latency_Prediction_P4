
table l4_acl {
    key = {
        hdr.ipv6.dstAddr: lpm; // 128 bits
        meta.dstPort: exact;     // 16 bits
    }
    actions = {
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 1000;
}