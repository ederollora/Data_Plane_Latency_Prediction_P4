table vlan_check {
    key = {
        hdr.ethernet.srcAddr: exact;  // 48 bits
        hdr.inner_vlan.vlanId: exact; // 12 bits
    }
    actions = {
        drop_pkt;
        NoAction;
    }
    default_action = drop_pkt;
    size = 64;
}