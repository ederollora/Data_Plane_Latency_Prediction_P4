

// 802.1ad defines this, S-Tag
const bit<16> ETHERTYPE_VLAN_STAG = 0x88A8;
// Deprecated but used 
// const bit<16> ETHERTYPE_VLAN_STAG2 = 0x9100;
// Deprecated, Cisco official doc mentions, maybe even 0x9300.
// const bit<16> ETHERTYPE_VLAN_STAG3 = 0x9200;
// C-Tag, 802.1q
const bit<16> ETHERTYPE_VLAN_CTAG = 0x8100;

const bit<16> ETHERTYPE_ARP = 0x0806;
const bit<16> ETHERTYPE_RARP = 0x8035;

const bit<16> ETHERTYPE_MPLS = 0x8847; // MPLS Unicast
const bit<16> ETHERTYPE_IPV4 = 0x0800; 
const bit<16> ETHERTYPE_IPV6 = 0x86DD;

const bit<8>  IPPROTO_ICMP      = 0x01;
const bit<8>  IPPROTO_ICMPV6    = 0x58;
const bit<8>  IPPROTO_TCP       = 0x06;
const bit<8>  IPPROTO_UDP       = 0x11;
const bit<8>  IPPROTO_SCTP      = 0x84;
const bit<8>  IPPROTO_IPSEC_ESP = 0x32;
const bit<8>  IPPROTO_IPSEC_AH  = 0x33;

//Tester does not generate GRE. GRE headers will be all 0s but we can define a custom IP_PROTO for GRE.
const bit<8>  IPPROTO_GRE    = 0x2F;

const bit<4> NEXT_HEADER_IPV4 = 0x4;
const bit<4> NEXT_HEADER_IPV6 = 0x6;

const bit<1> MPLS_END = 0x1;

const bit<4> NEXT_HEADER_EOMPLS = 0x0;
const bit<16> ETH_CTRL_WORD = 0x0;


//Tester cannot generate nGRE header so proto has to be 0x0. In reality it should be 0x6558.
const bit<16> GRE_PROTO_NVGRE = 0x0;
const bit<16> GRE_PROTO_IPV4 = 0x0800;
const bit<16> GRE_PROTO_IPV6 = 0x86DD; 

//Similar case for VXLAN, we can define port but VXLAN header will be all 0s. 
const bit<16> UDP_PORT_VXLAN = 0x12B5; // or 4789


const bit<48> ENCAP_MAC_SRC = 0xac1f6b62b9fe;
const bit<48> ENCAP_MAC_DST = 0xac1f6b62b967;
const bit<32> ENCAP_IP_SRC = 0x0A620BFE; // 192.168.11.254
const bit<32> ENCAP_IP_DST = 0x0A620B04; // 192.168.11.4
const bit<16> ENCAP_UDP_DST = 0xD431; //54321