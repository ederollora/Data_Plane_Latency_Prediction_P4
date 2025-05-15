
table mpls_tb {
    key = {
        hdr.mpls[2].label_id: exact;
    }
    actions = {
        mpls_swap;
        drop_pkt;
        NoAction;
    }
    default_action = NoAction;
    size = 20000;
}