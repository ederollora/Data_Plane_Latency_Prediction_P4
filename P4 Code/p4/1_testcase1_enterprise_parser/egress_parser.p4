parser EgressParser(packet_in        packet,
    /* User */
    out my_egress_headers_t          hdr,
    out my_egress_metadata_t         meta,
    /* Intrinsic */
    out egress_intrinsic_metadata_t  eg_intr_md)
{
    /* This is a mandatory state, required by Tofino Architecture */
    state start {
        packet.extract(eg_intr_md);
        packet.extract(hdr.ts_ingress);
        packet.extract(hdr.ethernet);
        transition accept;
    }
}
