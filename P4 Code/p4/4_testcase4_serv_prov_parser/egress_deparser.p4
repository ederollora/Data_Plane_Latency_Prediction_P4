control EgressDeparser(packet_out                   packet,
    /* User */
    inout my_egress_headers_t                       hdr,
    in    my_egress_metadata_t                      meta,
    /* Intrinsic */
    in    egress_intrinsic_metadata_for_deparser_t  eg_dprsr_md)
{
    Checksum() ipv4_checksum;

    apply {

        hdr.outer_ipv4.hdrChecksum = ipv4_checksum.update({
            hdr.outer_ipv4.version,
            hdr.outer_ipv4.ihl,
            hdr.outer_ipv4.dscp,
            hdr.outer_ipv4.ecn,
            hdr.outer_ipv4.totalLen,
            hdr.outer_ipv4.identification,
            hdr.outer_ipv4.flags,
            hdr.outer_ipv4.fragOffset,
            hdr.outer_ipv4.ttl,
            hdr.outer_ipv4.protocol,
            hdr.outer_ipv4.srcAddr,
            hdr.outer_ipv4.dstAddr
        });

        packet.emit(hdr.ptp_metadata);
        packet.emit(hdr.outer_ethernet);
        packet.emit(hdr.outer_ipv4);
        packet.emit(hdr.outer_udp);
        packet.emit(hdr.ts_egress);
        packet.emit(hdr.ts_ingress);
        packet.emit(hdr.ethernet);
    }
}