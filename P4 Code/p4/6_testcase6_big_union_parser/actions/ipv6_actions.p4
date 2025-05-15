

action fwd_ipv6(bit<9> port){
    ig_tm_md.ucast_egress_port = port;
}