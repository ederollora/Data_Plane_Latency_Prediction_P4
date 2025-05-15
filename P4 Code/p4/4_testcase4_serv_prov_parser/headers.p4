
/* Standard ethernet header */
header ethernet_h {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header mpls_h {
    mpls_label_t label_id;
    bit<3>       exp;
    bit<1>       bos;
    bit<8>       ttl;
}// 4 bytes


header ipv4_h {
    bit<4>    version;
    bit<4>    ihl;
    bit<6>    dscp;
    bit<2>    ecn;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}//20 bytes

header ipv6_h {
    bit<4>    version;
    bit<8>    trafficClass;
    bit<20>   flowLabel;
    bit<16>   payloadLen;
    bit<8>    nextHdr;
    bit<8>    hopLimit;
    ip6Addr_t srcAddr;
    ip6Addr_t dstAddr;
} // 40 bytes

header udp_h {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<16> len;
    bit<16> checksum;
}//8 bytes

/* Timestamping headers */
header timestamps_ingress_h {
    bit<48> ts2;
    bit<48> ts1;
}

header timestamps_egress_h {
    bit<48> ts5;
    bit<24> ts4;
    bit<24> ts3;
}

#ifdef CHECK
    header check_h {
        bit<32> a;
        bit<32> b;
        bit<32> c;
        bit<32> d;
    }
#endif

/* TS6-related header */
/*
header ptp_metadata_t {
    bit<8>  udp_cksum_byte_offset;
    bit<8>  cf_byte_offset;
    bit<48> updated_cf;
}
*/

struct my_ingress_headers_t {
    ethernet_h              ethernet;
    timestamps_ingress_h    ts_ingress;
    mpls_h[MPLS_STACK_SIZE] mpls;
    ipv4_h                  ipv4;
    ipv6_h                  ipv6;
#ifdef CHECK
    check_h                 check;
#endif
}

struct my_egress_headers_t {
    ptp_metadata_t        ptp_metadata;
    ethernet_h            outer_ethernet;
    ipv4_h                outer_ipv4;
    udp_h                 outer_udp;
    timestamps_egress_h   ts_egress;
    timestamps_ingress_h  ts_ingress;
    ethernet_h            ethernet;
}
