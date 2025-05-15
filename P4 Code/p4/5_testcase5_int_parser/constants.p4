

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

const bit<8>  IPPROTO_TCP   = 0x06;
const bit<8>  IPPROTO_UDP   = 0x11;

const bit<6>  DSCP_INT = 0x0; //DSCP could be 0x17, or use any other recommendaiton from standard

const bit<8> TWO_SIZE_METADATA_STACK = 0x0; // In a real case it should be 8w7 - 0x07    
const bit<8> ONE_SIZE_METADATA_STACK = 0x05; //


const bit<16> METADATA_4_BYTES         = 4;
const bit<16> METADATA_8_BYTES         = 8;
const bit<16> WORD_TO_BYTES            = 4;


// 32 bit words
const bit<8> IPV4_HEADER_LEN_WORDS     = 5; // 20 bytes
const bit<8> UDP_HEADER_LEN_WORDS      = 2; // 8 bytes
const bit<8> TCP_HEADER_LEN_WORDS      = 5; // 20 bytes
const bit<8> INT_SHIM_HEADER_LEN_WORDS = 1; // 4 bytes
const bit<8> INT_META_HEADER_LEN_WORDS = 3; // 12 bytes
const bit<8> METADATA_4_BYTE_AS_WORDS  = 1;
const bit<8> METADATA_8_BYTE_AS_WORDS  = 2;


const bit<48> ENCAP_MAC_SRC = 0xac1f6b62b9fe;
const bit<48> ENCAP_MAC_DST = 0xac1f6b62b967;
const bit<32> ENCAP_IP_SRC = 0x0A620BFE; // 192.168.11.254
const bit<32> ENCAP_IP_DST = 0x0A620B04; // 192.168.11.4
const bit<16> ENCAP_UDP_DST = 0xD431; //54321