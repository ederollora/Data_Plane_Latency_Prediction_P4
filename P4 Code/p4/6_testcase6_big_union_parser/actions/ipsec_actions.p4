Register<bit<32>, bit<32>>(32w1000) log_spi;

action log_pkt() {
    log_spi.write(hdr.ipsec_esp.spi, (bit<32>)ig_prsr_md.global_tstamp);
}