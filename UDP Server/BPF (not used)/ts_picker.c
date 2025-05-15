
// NOT BEING USED, SOME PARTS MAYBE WORKING AND SOME OTHER PARTS MAYBE NOT. IN SUMMARY, WE HAVE NOT TIME TO MAKE IT WORK.


#define KBUILD_MODNAME "ts_picker"

#ifdef asm_inline
    #undef asm_inline
    #define asm_inline asm
#endif

#include <linux/in.h>
#include <linux/if_packet.h>

#include <linux/if_ether.h>
#include <linux/if_vlan.h>

#include <linux/ip.h>
#include <linux/udp.h>


#define ETHERTYPE_IP 0x0800
#define PROTOCOL_UDP 0x11

#define PICKER_PORT 54321

#define CURSOR_ADVANCE(_target, _cursor, _len,_data_end) \
    ({  _target = _cursor; _cursor += _len; \
        if(unlikely(_cursor > _data_end)) return XDP_DROP; })

#define CURSOR_ADVANCE_NO_PARSE(_cursor, _len, _data_end) \
    ({  _cursor += _len; \
        if(unlikely(_cursor > _data_end)) return XDP_DROP; })


//Ethernet
struct ports_t {
    u16 source;
    u16 dest;
} __attribute__((packed));


//Ethernet
struct eth_h {
    u64 dst:48;
    u64 src:48;
    u16 type;
} __attribute__((packed));

struct timestamps_h {
    u64 ts6;
    u64 ts5:48;
    u32 ts4:24;
    u32 ts3:24;
    u64 ts2:48;
    u64 ts1:48;
} __attribute__((packed));



BPF_HISTOGRAM(ingress_lat_cnt, u16);
BPF_HISTOGRAM(egress_lat_cnt, u16);
BPF_HISTOGRAM(e2e_lat_cnt, u16);



int timestamp_picker(struct xdp_md *ctx) {

    void* data_end = (void*)(long)ctx->data_end;
    void* cursor = (void*)(long)ctx->data;

    //Ethernet
    struct eth_h *eth;
    CURSOR_ADVANCE(eth, cursor, sizeof(*eth), data_end);

    // IPv4
    if (unlikely(ntohs(eth->type) != ETHERTYPE_IP))
        return XDP_PASS;
    struct iphdr *ip;
    CURSOR_ADVANCE(ip, cursor, sizeof(*ip), data_end);

    //UDP
    if (unlikely(ip->protocol != PROTOCOL_UDP))
        return XDP_PASS;
    struct udphdr *udp;
    CURSOR_ADVANCE(udp, cursor, sizeof(*udp), data_end);

    //Make sure port is the expected one
    if (unlikely(ntohs(udp->dest) != PICKER_PORT))
        return XDP_PASS; //if not then let it be handled further    
    
    //bpf_trace_printk("recv pkt! \n");

    //return XDP_DROP;
    
    // Out timestmaps come here
    struct timestamps_h *tts;
    CURSOR_ADVANCE(tts, cursor, sizeof(*tts), data_end);

    u32 ts1Filtered = ntohl(tts->ts1 >> 16);
    u32 ts2Filtered = ntohl(tts->ts2 >> 16);
    u32 ts3Filtered = ntohl(tts->ts3) >> 8;
    u32 ts5Filtered = ntohl(tts->ts5 >> 16);
    u32 ts6Filtered = ntohl(tts->ts6 >> 16);

    u16 ingress_latency = 0;
    u16 egress_latency = 0;
    u16 e2e_latency = 0;

    if (ts3Filtered > ts2Filtered){
        ingress_latency = (ts3Filtered - (ts2Filtered & 0x3ffff)) & 0xffff;
    }else{
        ingress_latency =  (0x3ffff - (ts2Filtered & 0x3ffff) + ts3Filtered + 1) & 0xffff;
    }

    egress_latency = ts6Filtered - ts5Filtered;
    e2e_latency = ts6Filtered - ts1Filtered;

    //bpf_trace_printk("Ingress latency = %u\n", (ingress_latency));

    ingress_lat_cnt.increment(ingress_latency);
    egress_lat_cnt.increment(egress_latency);
    e2e_lat_cnt.increment(e2e_latency);

    return XDP_PASS;

}



