
table nvgre_check_flow_id {
    key = {
        hdr.ipv4.dstAddr: exact;
        hdr.nvgre.vsid: exact;
    }
    actions = {
        drop_pkt;
        NoAction;
    }
    default_action = drop_pkt;
    size = 1000;
}