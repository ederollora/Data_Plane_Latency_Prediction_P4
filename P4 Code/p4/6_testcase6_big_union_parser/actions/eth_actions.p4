
action forward_eth (bit<9> port) {
    ig_tm_md.ucast_egress_port = (bit<9>)port;
}
