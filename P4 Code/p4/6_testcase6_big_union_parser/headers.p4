
/*  Define all the headers the program will recognize             */
/*  The actual sets of headers processed by each gress can differ */


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

header arp_h {
    bit<16> hardwareType; // Hardware Type
    bit<16> protocolType; // Protocol Type
    bit<8> hardwareAddrLen; // Hardware Address Length
    bit<8> protocolAddrLen; // Protocol Address Length
    bit<16> op;  // Opcode
    macAddr_t senderHwAddr; // Sender Hardware Address
    ip4Addr_t senderProtoAddr; // Sender Protocol Address
    macAddr_t targetHwAddr; // Target Hardware Address
    ip4Addr_t targetProtoAddr; // Target Protocol Address
}

header vlan_h {
    bit<3>    pri;
    bit<1>    cfi;
    vlan_id_t vlanId;
    bit<16>   etherType;
}// 4 bytes

header mpls_h {
    mpls_label_t label_id;
    bit<3>       exp;
    bit<1>       bos;
    bit<8>       ttl;
}// 4 bytes

header eompls_h {
    bit<4> _none;
    bit<3> flags;
    bit<1> frg;
    bit<8> len;
    bit<16> seqNum;
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

header icmp_h{
    bit<8> type;
    bit<8> code;
    bit<16> checksum;
    bit<16> id;
    bit<16> seqNum;
}

header icmpv6_h{
    bit<8> type;
    bit<8> code;
    bit<16> checksum;
    bit<32> message;
}

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

header sctp_h {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> vTag;
    bit<32> checksum;
}//12 bytes

header gre_h { //RFC 2784 and mentioned in RFC 2890
    bit<1> c;
    bit<12> res0;
    bit<3> version;
    bit<16> protoType;
    bit<16> checksum;
    bit<16> res1;
}//12 bytes

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

header nvgre_h { //Optional at RFC 7637
    bit<24> vsid;
    bit<8> flowId;
}//4 bytes

header vxlan_h { // RFC 7348
    bit<8>  flags;
    bit<24> res1;
    bit<24> vni;
    bit<8>  res2;
}// 8 bytes

header ipsec_ah_h {
    bit<8> nextHdr;
    bit<8> ahLen;
    bit<16> res;
    bit<32> spi;
    bit<32> seqNum;
}//12 bytes

header ipsec_esp_tr_h { // IPSec: ESP - Transport mode
    bit<32> spi;
    bit<32> seqNum;
}//8 bytes

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
    ethernet_h              ethernet;
    timestamps_ingress_h    ts_ingress;
    vlan_h                  outer_vlan;
    vlan_h                  inner_vlan;
    arp_h                   arp;
    mpls_h[MPLS_STACK_SIZE] mpls;
    eompls_h                eompls;
    ipv4_h                  ipv4;
    ipv6_h                  ipv6;
    icmp_h                  icmp;
    icmpv6_h                icmpv6;
    tcp_h                   tcp;
    udp_h                   udp;
    sctp_h                  sctp;
    ipsec_ah_h              ipsec_ah;
    ipsec_esp_tr_h          ipsec_esp;
    gre_ext_h               gre;
    nvgre_h                 nvgre;
    vxlan_h                 vxlan;
    ethernet_h              inner_ethernet;
    ipv4_h                  inner_ipv4;
    ipv6_h                  inner_ipv6;
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
