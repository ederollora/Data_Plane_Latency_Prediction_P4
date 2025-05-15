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
            ETHERTYPE_VLAN_STAG : accept; // Normally S-Tag
            ETHERTYPE_VLAN_CTAG : accept; // Normally C-Tag
            ETHERTYPE_ARP       : accept;
            ETHERTYPE_MPLS      : accept;
            ETHERTYPE_IPV4      : accept;
            ETHERTYPE_IPV6      : accept;
            default             : parse_outer_vlan;
    #else
            ETHERTYPE_VLAN_STAG : parse_outer_vlan; // Normally S-Tag
            ETHERTYPE_VLAN_CTAG : parse_inner_vlan; // Normally C-Tag
            ETHERTYPE_ARP       : parse_arp;
            ETHERTYPE_MPLS      : parse_mpls;
            ETHERTYPE_IPV4      : parse_ipv4;
            ETHERTYPE_IPV6      : parse_ipv6;
            default             : accept;
    #endif

        }
    }

    state parse_outer_vlan {
        packet.extract(hdr.outer_vlan);
        transition select(hdr.outer_vlan.etherType) {
            ETHERTYPE_VLAN_CTAG : parse_inner_vlan;
            ETHERTYPE_ARP       : parse_arp;
            ETHERTYPE_MPLS      : parse_mpls;
            ETHERTYPE_IPV4      : parse_ipv4;
            ETHERTYPE_IPV6      : parse_ipv6;
            default             : accept;
        }
    }

    state parse_inner_vlan {
        packet.extract(hdr.inner_vlan);
        transition select(hdr.inner_vlan.etherType) {
            ETHERTYPE_ARP  : parse_arp;
            ETHERTYPE_MPLS : parse_mpls;
            ETHERTYPE_IPV4 : parse_ipv4;
            ETHERTYPE_IPV6 : parse_ipv6;
            default        : accept;
        }
    }
    
    state parse_arp {
        packet.extract(hdr.arp);
        transition accept;
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
            NEXT_HEADER_EOMPLS : parse_eompls;
            default            : accept;
        }
    }

    state parse_eompls {
        packet.extract(hdr.eompls);
        transition parse_inner_ethernet;
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            IPPROTO_ICMP      : parse_icmp;
            IPPROTO_UDP       : parse_udp;
            IPPROTO_TCP       : parse_tcp;
            IPPROTO_SCTP      : parse_sctp;
            IPPROTO_GRE       : parse_gre;
            IPPROTO_IPSEC_AH  : parse_ipsec_ah;
            IPPROTO_IPSEC_ESP : parse_ipsec_esp;
            default           : accept;
        }
    }

    state parse_ipv6 {
        packet.extract(hdr.ipv6);
        transition select(hdr.ipv6.nextHdr) {
            IPPROTO_ICMPV6    : parse_icmpv6;
            IPPROTO_UDP       : parse_udp;
            IPPROTO_TCP       : parse_tcp;
            IPPROTO_SCTP      : parse_sctp;
            IPPROTO_GRE       : parse_gre;
            IPPROTO_IPSEC_AH  : parse_ipsec_ah;
            IPPROTO_IPSEC_ESP : parse_ipsec_esp;
            default           : accept;
        }
    }

    state parse_icmp {
        packet.extract(hdr.icmp);
        transition accept;
    }

     state parse_icmpv6 {
        packet.extract(hdr.icmpv6);
        transition accept;
    }

    state parse_ipsec_esp { //Assumed ESP in transport but no further TPC/UDP parse
        packet.extract(hdr.ipsec_esp);
        transition accept;
    }

    state parse_ipsec_ah { //Assumed AH in transport but no Auth Data and further TPC/UDP parse
        packet.extract(hdr.ipsec_ah);
        transition accept;
    }

    state parse_tcp {
        packet.extract(hdr.tcp);
        transition accept;
    }

    state parse_udp {
        packet.extract(hdr.udp);
        transition select(hdr.udp.dstPort) {
            UDP_PORT_VXLAN  : parse_vxlan;
            default         : accept;
        }
    }

    state parse_sctp {
        packet.extract(hdr.sctp);
        transition accept;
    }

    state parse_gre {
        packet.extract(hdr.gre);
        transition select(hdr.gre.protoType) {
            GRE_PROTO_IPV4  : parse_inner_ipv4;
            GRE_PROTO_IPV6  : parse_inner_ipv6;
            GRE_PROTO_NVGRE : parse_nvgre;
            default         : accept;
        }
    }

    state parse_nvgre {
        packet.extract(hdr.nvgre);
        transition parse_inner_ethernet;
    }

    state parse_vxlan{
        packet.extract(hdr.vxlan);
        transition parse_inner_ethernet;
    }

    state parse_inner_ethernet {
        packet.extract(hdr.inner_ethernet);
        transition accept;
    }

    state parse_inner_ipv4 {
        packet.extract(hdr.inner_ipv4);
        transition accept;
    }

    state parse_inner_ipv6 {
        packet.extract(hdr.inner_ipv6);
        transition accept;
    }         

}