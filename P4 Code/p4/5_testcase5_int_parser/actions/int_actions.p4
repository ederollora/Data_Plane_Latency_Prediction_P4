//We decided not to generate new headers as it would go out of the scope of the tests
// Future tests could require it

/*action int_set_header_0() { // 32 bits
    hdr.int_switch_id.setValid();
    hdr.int_switch_id.switch_id = (bit<32>)1;
}

action int_set_header_1() { // 32 bits
    hdr.int_timestamp_ig.setValid();
    hdr.int_timestamp_ig.igs = (bit<32>)ig_prsr_md.global_tstamp;
}*/

//although field modification was not tested and trained for we accommodate this to asses the difference.
action int_set_header_0003_i3() {
    //int_set_header_0();
    //int_set_header_1();
    // 4 bytes for switch_id and 8 bytes for ingress ts

    hdr.int_shim.len = hdr.int_shim.len + METADATA_8_BYTE_AS_WORDS;

    hdr.ipv4.totalLen = hdr.ipv4.totalLen + METADATA_8_BYTES; //we add ing tstamp size later

    hdr.udp.len = hdr.udp.len + METADATA_8_BYTES;
    
}