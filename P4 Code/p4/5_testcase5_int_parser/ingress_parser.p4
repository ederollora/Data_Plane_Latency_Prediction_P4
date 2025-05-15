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
            ETHERTYPE_VLAN_CTAG : accept; // Normally C-Tag            ETHERTYPE_IPV4 : accept;
            ETHERTYPE_IPV6      : accept;
            default             : parse_outer_vlan;
    #else
            ETHERTYPE_VLAN_STAG : parse_outer_vlan; // Normally S-Tag
            ETHERTYPE_VLAN_CTAG : parse_inner_vlan; // Normally C-Tag
            ETHERTYPE_IPV4      : parse_ipv4;
            ETHERTYPE_IPV6      : parse_ipv6;
            default             : accept;
    #endif
        }
    }

    state parse_outer_vlan {
        packet.extract(hdr.outer_vlan);
        transition select(hdr.outer_vlan.etherType) {
            ETHERTYPE_VLAN_CTAG: parse_inner_vlan;
            ETHERTYPE_IPV4:      parse_ipv4;
            ETHERTYPE_IPV6      : parse_ipv6;
            default:             accept;
        }
    }

    state parse_inner_vlan {
        packet.extract(hdr.inner_vlan);
        transition select(hdr.inner_vlan.etherType) {
            ETHERTYPE_IPV4:      parse_ipv4;
            ETHERTYPE_IPV6      : parse_ipv6;
            default:             accept;
        }
    }    

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            IPPROTO_UDP  : parse_udp;
            IPPROTO_TCP  : parse_tcp;
            default      : accept;
        }
    }

    state parse_ipv6 {
        packet.extract(hdr.ipv6);
        transition select(hdr.ipv6.nextHdr) {
            IPPROTO_UDP       : parse_udp;
            IPPROTO_TCP       : parse_tcp;
            default           : accept;
        }
    }


    state parse_tcp {
        packet.extract(hdr.tcp);
        transition select(hdr.ipv4.dscp) {
            DSCP_INT     : parse_int_shim;
            default      : accept;
        }
    }

    state parse_udp {
        packet.extract(hdr.udp);
        transition select(hdr.ipv4.dscp) {
            DSCP_INT     : parse_int_shim;
            default      : accept;
        }
    }

    state parse_int_shim {
       packet.extract(hdr.int_shim);
       transition parse_int_meta;
    }

    state parse_int_meta {
        packet.extract(hdr.int_meta);
        transition select(hdr.int_shim.len) {
            TWO_SIZE_METADATA_STACK : parse_int_metadata_stack2;
            ONE_SIZE_METADATA_STACK : parse_int_metadata_stack1;
            default                 : accept;
        }
    }

    state parse_int_metadata_stack2 {
        packet.extract(hdr.int_metadata_stack2);
        transition parse_int_metadata_stack1;
    }

    state parse_int_metadata_stack1 {
        packet.extract(hdr.int_metadata_stack1);
        transition accept;
    }

}