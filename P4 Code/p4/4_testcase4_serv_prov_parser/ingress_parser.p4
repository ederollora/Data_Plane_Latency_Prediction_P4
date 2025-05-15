parser IngressParser(packet_in        packet,
    /* User */
    out my_ingress_headers_t          hdr,
    out my_ingress_metadata_t         meta,
    /* Intrinsic */
    out ingress_intrinsic_metadata_t  ig_intr_md)
{
    /* This is a mandatory state, required by Tofino Architecture */

state start {
        packet.extract(ig_intr_md);
        packet.advance(PORT_METADATA_SIZE);
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
    #ifdef END_ETH
            ETHERTYPE_MPLS : accept;
            ETHERTYPE_IPV4 : accept;
            ETHERTYPE_IPV6 : accept;
            default        : parse_mpls;
    #else
            ETHERTYPE_MPLS : parse_mpls;
            ETHERTYPE_IPV4 : parse_ipv4;
            ETHERTYPE_IPV6 : parse_ipv6;
            default        : accept;
    #endif
        }
    }

    state parse_mpls {
        packet.extract(hdr.mpls.next);
        transition select(hdr.mpls.last.bos) {
            MPLS_END : parse_mpls_end;
            default  : parse_mpls;
        }
    }

    state parse_mpls_end {
        transition select((packet.lookahead<bit<4>>())[3:0]) {
            NEXT_HEADER_IPV4   : parse_ipv4;
            NEXT_HEADER_IPV6   : parse_ipv6;
            default            : accept;
        }
    }


    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
    }

    state parse_ipv6 {
        packet.extract(hdr.ipv6);
        transition accept;
    }


}