

// 802.1ad defines this, S-Tag
const bit<16> ETHERTYPE_VLAN_STAG = 0x88A8;
// Deprecated but used 
// const bit<16> ETHERTYPE_VLAN_STAG2 = 0x9100;
// Deprecated, Cisco official doc mentions, maybe even 0x9300.
// const bit<16> ETHERTYPE_VLAN_STAG3 = 0x9200;
// C-Tag, 802.1q
const bit<16> ETHERTYPE_VLAN_CTAG = 0x8100;

const bit<16> ETHERTYPE_IPV4 = 0x0800;
const bit<16> ETHERTYPE_IPV6 = 0x86DD;

const bit<8>  IPPROTO_TCP       = 0x06;
const bit<8>  IPPROTO_UDP       = 0x11;
const bit<8>  IPPROTO_ICMP      = 0x01;
const bit<8>  IPPROTO_ICMPV6    = 0x58;

const bit<48> ENCAP_MAC_SRC = 0xac1f6b62b9fe;
const bit<48> ENCAP_MAC_DST = 0xac1f6b62b967;
const bit<32> ENCAP_IP_SRC = 0x0A620BFE; // 192.168.11.254
const bit<32> ENCAP_IP_DST = 0x0A620B04; // 192.168.11.4
const bit<16> ENCAP_UDP_DST = 0xD431; //54321

