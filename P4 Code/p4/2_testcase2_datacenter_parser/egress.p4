control Egress(
    /* User */
    inout my_egress_headers_t                          hdr,
    inout my_egress_metadata_t                         meta,
    /* Intrinsic */
    in    egress_intrinsic_metadata_t                  eg_intr_md,
    in    egress_intrinsic_metadata_from_parser_t      eg_prsr_md,
    inout egress_intrinsic_metadata_for_deparser_t     eg_dprsr_md,
    inout egress_intrinsic_metadata_for_output_port_t  eg_oport_md)
{
#ifdef WITH_EGR_SAMPLER
    Random<bit<10>>() randomNum;
#endif

    Random<bit<16>>() randomPort;

    action encap(){

        hdr.outer_ethernet.setValid();
        hdr.outer_ethernet.srcAddr = ENCAP_MAC_SRC; 
        hdr.outer_ethernet.dstAddr = ENCAP_MAC_DST;
        hdr.outer_ethernet.etherType = ETHERTYPE_IPV4;

        hdr.outer_ipv4.setValid();
        hdr.outer_ipv4.version = 4;
        hdr.outer_ipv4.ihl = 5;
        hdr.outer_ipv4.dscp = 0;
        hdr.outer_ipv4.ecn = 0;
        hdr.outer_ipv4.totalLen = eg_intr_md.pkt_length + 20 + 4 + 32;
        hdr.outer_ipv4.identification = 0xabcd;
        hdr.outer_ipv4.flags = 4;
        hdr.outer_ipv4.fragOffset = 0;
        hdr.outer_ipv4.ttl = 31;
        hdr.outer_ipv4.hdrChecksum = 0;
        hdr.outer_ipv4.protocol = IPPROTO_UDP;
        hdr.outer_ipv4.srcAddr = ENCAP_IP_SRC;
        hdr.outer_ipv4.dstAddr = ENCAP_IP_DST;

        hdr.outer_udp.setValid();
        hdr.outer_udp.srcPort = 0;
        hdr.outer_udp.dstPort = ENCAP_UDP_DST;
        hdr.outer_udp.len = eg_intr_md.pkt_length + 4 + 32;
        hdr.outer_udp.checksum = 0;        
    }

    action drop_pkt() {
        eg_dprsr_md.drop_ctl = 1;
    }    
   
    action add_egs_mac_ts(bit<8> offset){
        eg_oport_md.update_delay_on_tx = 1;

        hdr.ptp_metadata.setValid();
        hdr.ptp_metadata.udp_cksum_byte_offset = 0;
        hdr.ptp_metadata.cf_byte_offset = offset;
        hdr.ptp_metadata.updated_cf = 0;
    }

    table encapsulate_t {
        key = {
        }
        actions = {
            encap;
            NoAction;
        }
        default_action = encap;
        size           = 1;
    }  

    table timestamp_eg_t {
        key = {
        }
        actions = {
            add_egs_mac_ts;
            NoAction;
        }
        default_action = add_egs_mac_ts(42); //Eth+IP+UDP = 14+20+8 = 42
        //default_action = add_egs_mac_ts(14); //Eth = 14
        size           = 1;
    }
    

    apply{

#ifdef WITH_EGR_SAMPLER
        bit<10> num = randomNum.get();
    #ifdef PERCENT_10
        if (num > 102){ 
    #elif PERCENT_1
        if (num > 10){
    #endif
            drop_pkt();
        }
#endif

        //Filter packets        
        if(hdr.ethernet.srcAddr[23:0] != 0x62B999){
            drop_pkt();
        }

        // ENCAPSULATION
        encapsulate_t.apply();
        bit<16> port = randomPort.get();
        hdr.outer_udp.srcPort = port;

        // Add egress timestamp
        hdr.ts_egress.setValid();        
        hdr.ts_egress.ts3 = (bit<24>)eg_intr_md.enq_tstamp;
        hdr.ts_egress.ts4 = (bit<24>)eg_intr_md.deq_timedelta;
        hdr.ts_egress.ts5 = eg_prsr_md.global_tstamp;
        timestamp_eg_t.apply();           

    }
}
