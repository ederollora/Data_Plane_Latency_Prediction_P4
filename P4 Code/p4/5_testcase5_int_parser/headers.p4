
/*  Define all the headers the program will recognize             */
/*  The actual sets of headers processed by each egress can differ */


/*header ptp_metadata_t {
    bit<8>  udp_cksum_byte_offset;
    //1) Eth+IPv4+UDP = 42 bytes
    //2) Eth+MPLS+IPv4+UDP = 48 bytes
    //3) Eth+MPLS+IPv4+UDP+I_S+I_M = 64 bytes
    //4) Eth+MPLS+IPv4+UDP+I_S+I_M = 64 bytes
    bit<8>  cf_byte_offset;
    bit<48> updated_cf;
}*/

/* Standard ethernet header */
header ethernet_h {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}//14 bytes

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

/* INT shim header for TCP/UDP */
header int_shim_h {
    bit<4>  _type;
    bit<2>  npt;
    bit<1>  res1;
    bit<1>  res2;
    bit<8>  len;
    bit<16> npt_field; // npt=0 -> , npt=1 -> orignal UDP port, npt=2 ->IP proto
}//4 bytes

/* INT-MD Metadata header v2.1*/
header int_meta_h {
    bit<4> ver;
    bit<1> d;
    bit<1> e;
    bit<1> m;
    bit<12> rsvd1;
    bit<5> hop_metadata_len;
    bit<8> remaining_hop_cnt;
    bit<4> instruction_mask_0003; // check instructions from bit 0 to bit 3
    bit<4> instruction_mask_0407; // check instructions from bit 4 to bit 7
    bit<4> instruction_mask_0811; // check instructions from bit 8 to bit 11
    bit<4> instruction_mask_1215; // check instructions from bit 12 to bit 15
    bit<16> domain_sp_id;
    bit<16> ds_inst;
    bit<16> ds_flags;
}// 12 bytes

header int_metadata_stack_h {
    bit<64> data;
}


header int_switch_id_h {
    bit<32> switch_id;
}// 4 bytes

header int_timestamp_ig_h {
    bit<32> igs;
}// 4 bytes


#ifdef CHECK
    header check_h {
        bit<32> a;
        bit<32> b;
        bit<32> c;
        bit<32> d;
    }
#endif

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


/* TS6-related header */
/*
header ptp_metadata_t {
    bit<8>  udp_cksum_byte_offset;
    bit<8>  cf_byte_offset;
    bit<48> updated_cf;
}
*/

struct my_ingress_headers_t {
    ethernet_h            ethernet;
    timestamps_ingress_h  ts_ingress;
    vlan_h                outer_vlan;
    vlan_h                inner_vlan;
    ipv4_h                ipv4;
    ipv6_h                ipv6;
    tcp_h                 tcp;
    udp_h                 udp;
    int_shim_h            int_shim;
    int_meta_h            int_meta;
    int_switch_id_h       int_switch_id;
    int_timestamp_ig_h    int_timestamp_ig;
    int_metadata_stack_h  int_metadata_stack2;
    int_metadata_stack_h  int_metadata_stack1;
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
