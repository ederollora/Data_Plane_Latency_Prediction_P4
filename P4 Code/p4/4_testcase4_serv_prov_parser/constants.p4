const bit<16> ETHERTYPE_MPLS = 0x8847;
const bit<16> ETHERTYPE_IPV4 = 0x0800;
const bit<16> ETHERTYPE_IPV6 = 0x86DD;

const bit<1>  MPLS_END = 0x1;

const bit<4>  NEXT_HEADER_IPV4 = 0x4;
const bit<4>  NEXT_HEADER_IPV6 = 0x6;

const bit<8> IPPROTO_UDP = 0x11;

const bit<48> ENCAP_MAC_SRC = 0xac1f6b62b9fe;
const bit<48> ENCAP_MAC_DST = 0xac1f6b62b967;
const bit<32> ENCAP_IP_SRC = 0x0A620BFE; // 192.168.11.254
const bit<32> ENCAP_IP_DST = 0x0A620B04; // 192.168.11.4
const bit<16> ENCAP_UDP_DST = 0xD431; //54321