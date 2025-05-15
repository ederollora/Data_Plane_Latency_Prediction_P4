#!/usr/bin/env python
import sys, os, socket, random, struct, time
import binascii, uuid, json
from datetime import datetime
import calendar
import argparse

from scapy.all import sniff, sendp, send, hexdump, get_if_list, get_if_hwaddr, bind_layers
from scapy.all import Packet, IPOption
from scapy.all import PacketListField, ShortField, IntField, LongField, BitField, FieldListField, FieldLenField, ByteField
from scapy.all import Ether, IP, UDP, TCP, Raw
from scapy.layers.inet6 import IPv6
from scapy.fields import *

from binascii import hexlify

SWITCH_ID = 0
TIMESTAMP = 1


parser = argparse.ArgumentParser(description='Process some parameters')

parser.add_argument('-i', '--interface', type=str, help='Name of the interface to send the packet to')
parser.add_argument('-p', '--packets', type=int, action='store', help='Number of packets to receive')
parser.add_argument('-r', '--resultpath', type=str, help='Path for result files')
parser.add_argument('-f', '--filename', type=str, help='Filename')
parser.add_argument('-x', '--filter', type=str, help='Filter criteria')


args = parser.parse_args()


class Tofino_TS_Ingress(Packet):
    name = "Ingress Timestamps"
    fields_desc = [
        BitField('ts2', 0, 48),
        BitField('ts1', 0, 48),

    ]

class Tofino_TS_Egress(Packet):
    name = "Egress Tiemstamps"
    fields_desc = [
        BitField('ts6', 0, 48),
        BitField('ts6_frac', 0, 16),
        BitField('ts5', 0, 48),
        BitField('ts4', 0, 24),
        BitField('ts3', 0, 24),
    ]

def get_if():
    ifs=get_if_list()
    iface=None
    for i in get_if_list():
        if args.interface in i:
            iface=i
            break;
    if not iface:
        print("Cannot find  interface")
        exit(1)
    return iface

def handle_pkt(packet, flows, counters):

    info = { }

    info["rec_time"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")

    pkt = bytes(packet)
    #print "## PACKET RECEIVED ##"

    eth_h = None

    igTimeStamp = None
    egTimeStamp = None
    packetPayload = None

    ETHERNET_HEADER_LENGTH = 14

    TOFINO_TS_INGRESS_LENGTH = 12
    TOFINO_TS_EGRESS_LENGTH = 20

    ETHERNET_OFFSET = 0 + ETHERNET_HEADER_LENGTH + 20 + 8
    eth_h = Ether(pkt[0:ETHERNET_OFFSET])
    #eth_h.show()


    TOFINO_TS_EGRESS_OFFSET = ETHERNET_OFFSET + TOFINO_TS_EGRESS_LENGTH
    ts_egress = Tofino_TS_Egress(pkt[ETHERNET_OFFSET:TOFINO_TS_EGRESS_OFFSET])
    #ts_egress.show()

    TOFINO_TS_INGRESS_OFFSET = TOFINO_TS_EGRESS_OFFSET + TOFINO_TS_INGRESS_LENGTH
    ts_ingress = Tofino_TS_Ingress(pkt[TOFINO_TS_EGRESS_OFFSET:TOFINO_TS_INGRESS_OFFSET])
    #ts_ingress.show()


    #print("TS2 bytes 18b: "+''.join('%02x'%int(ts_ingress.ts2)))
    #print("TS2 bytes 18b: "+''.join('%02x'%int(ts_ingress.ts2 & 0x3FFFF)))
    #print("TS3 bytes 18b: "+''.join('%02x'%int(ts_egress.ts3 & 0x3FFFF)))



    #ts3_calculated = (ts_ingress.ts2 & 0xFFFFFFFC0000) + (ts_egress.ts3 & 0x00000003FFFF)
    ts3_calculated = 0
    if (ts_egress.ts3 & 0x3FFFF) < (ts_ingress.ts2 & 0x3FFFF):
        ts3_calculated =  0x3FFFF - (ts_ingress.ts2 & 0x3FFFF) + (ts_egress.ts3 & 0x3FFFF) + 1
    else:
        ts3_calculated = (ts_egress.ts3 & 0x3FFFF) - (ts_ingress.ts2 & 0x3FFFF)

    ingress_mac = int(ts_ingress.ts2) - int(ts_ingress.ts1)
    ingress_block = int(ts3_calculated)
    queue_time = int(ts_egress.ts4)
    queue_to_egress = int(ts_egress.ts5) - (int(ts_ingress.ts2) + int(ts3_calculated) + int(ts_egress.ts4))
    egress_block = int(ts_egress.ts6) - int(ts_egress.ts5)
    total_pipe_lat = int(ts_egress.ts6) - int(ts_ingress.ts1)

    print("--------------------------------------------------------------------------------")
    #print("HEX TS2: "+hexlify(str(ts_ingress.ts2))+", HEX TS3 :"+hexlify(str(ts_egress.ts3)))
    print("Ingress MAC to Ingress Parser: "+str(ingress_mac))
    print("Ingress Block (P-MAU-D): "+str(ingress_block))
    print("Queue time:  "+str(queue_time))
    print("Queue to Egress:  "+str(queue_to_egress))
    print("Egress Block (P-MAU-D): "+str(egress_block))
    print("Total Pipeline latency: "+str(total_pipe_lat))

   
    pipelineLatency = str(ingress_mac)+","+str(ingress_block)+","+str(queue_time)+","+str(queue_to_egress)+","+str(egress_block)+","+str(total_pipe_lat)

    if(args.filename):
        outF = open(args.resultpath+"results_"+args.filename+".txt", "a")
        outF.write(str(pipelineLatency))
        outF.write("\n")
        outF.close()

    sys.stdout.flush()

    return


def main():
    flows = {}
    counters = {}

    print("sniffing on %s" % args.interface)
    sys.stdout.flush()
    sniff(
        count=args.packets,
        #lfilter = lambda d: d.src == 'aa:bb:cc:dd:ee:ff',
        lfilter = lambda d: d.dst == 'ac:1f:6b:62:b9:67',
        iface = args.interface,
        prn = lambda x: handle_pkt(x, flows, counters))

if __name__ == '__main__':
    main()