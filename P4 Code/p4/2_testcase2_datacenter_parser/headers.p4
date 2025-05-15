
/* Standard ethernet header */
header ethernet_h {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header vlan_h {
    bit<3>    pri;
    bit<1>    cfi;
    vlan_id_t vlanId;
    bit<16>   etherType;
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

header tcp_h {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<4>  res;
    bit<8>  flags;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}//20 bytes

header udp_h {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<16> len;
    bit<16> checksum;
}//8 bytes

header gre_ext_h { //Extended at RFC 2890
    bit<1> c;
    bit<1> _none;
    bit<1> k;
    bit<1> s;
    bit<9> res0;
    bit<3> version;
    bit<16> protoType;
}//4 bytes

header gre_ext_chk_h { //Optional at RFC 2890
    bit<16> checksum;
    bit<16> reserved1;
}//4 bytes

header nvgre_h { // At RFC 7637
    bit<24> vsid;
    bit<8> flowId;
}//4 bytes

header vxlan_h { // RFC 7348
    bit<8>  flags;
    bit<24> res1;
    bit<24> vni;
    bit<8>  res2;
}// 8 bytes

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
    vlan_h                  outer_vlan;
    vlan_h                  inner_vlan;
    ipv4_h                  ipv4;
    tcp_h                   tcp;
    udp_h                   udp;
    gre_ext_h               gre;
    nvgre_h                 nvgre;
    vxlan_h                 vxlan;
    ethernet_h              inner_ethernet;
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
