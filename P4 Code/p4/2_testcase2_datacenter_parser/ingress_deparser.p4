control IngressDeparser(packet_out packet,
    /* User */
    inout my_ingress_headers_t                       hdr,
    in    my_ingress_metadata_t                      meta,
    /* Intrinsic */
    in    ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md)
{
    apply {
        packet.emit(hdr.ts_ingress);
        packet.emit(hdr.ethernet);
        packet.emit(hdr.outer_vlan);
        packet.emit(hdr.inner_vlan);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.tcp);
        packet.emit(hdr.udp);
        packet.emit(hdr.gre);
        packet.emit(hdr.nvgre);
        packet.emit(hdr.vxlan);
        packet.emit(hdr.inner_ethernet);
   #ifdef CHECK
        packet.emit(hdr.check);
    #endif
    }
}
