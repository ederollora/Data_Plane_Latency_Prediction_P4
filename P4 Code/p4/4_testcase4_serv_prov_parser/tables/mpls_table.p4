table mpls_tb {
    key = {
        hdr.mpls[4].label_id: exact;
    }
    actions = {
        mpls_swap;
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 1000;
}