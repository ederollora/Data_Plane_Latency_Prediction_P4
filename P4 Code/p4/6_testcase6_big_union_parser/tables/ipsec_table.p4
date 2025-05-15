table ipsec_check {
    key = {
        hdr.ipsec_esp.spi: exact;
    }
    actions = {
        NoAction;
        log_pkt;
    }
    default_action = NoAction;
    size = 1500;
}