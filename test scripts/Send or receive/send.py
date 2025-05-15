#!/usr/bin/env python
import sys, os , socket, random, struct, time
import argparse

from scapy.all import sendp, send, get_if_list, get_if_hwaddr, bind_layers
from scapy.all import Packet
from scapy.all import Ether, IP, UDP, TCP, Raw, IPv6, Dot1Q
from scapy.fields import *

"""
sudo python3.7 send.py \
 --interface <intf> \
 --packets 1000 \
 --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
 --mpls 1,1000 \
 --ip 192.168.1.1,192.168.2.2,0x17 \
 --udp 1000 \
 --intshim \
 --intmeta \
 --imstack 1,123456 \
 --bytes 1000

sudo python3.8 send.py \
 --interface eno3 \
 --packets 1 \
 --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
 --mpls 1,1000 \
 --ip 192.168.1.1,192.168.2.2,0x17 \
 --udp 1000 \
 --bytes 1000
"""

#Eth, IPv4, IPv6
SRC = 0
DST = 1

#Eth
ETHTYPE = 2

#IPv4
DSCP = 2
VER = 3

#IPv6
VER_IP6 = 2

#VLAN
VLANTYPE = 0
VLAN1 = 1
VLAN2 = 2
VLAN3 = 3
VLAN4 = 4

#MPLS
LABEL1 = 0
LABEL2 = 1
LABEL3 = 2
LABEL4 = 3
LABEL5 = 4

SWITCH_ID = 0
TIMESTAMP = 1

TYPE_RND = 0x1234

parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('-e', '--ethernet', type=str, help='Ethernet src/dst addresses')
parser.add_argument('-w', '--rnd', type=str, action='store', help='Random n size using k headers')
parser.add_argument('-v', '--vlan', type=str, help='VLAN headers and IDs')
parser.add_argument('-m', '--mpls', type=str, help='Enable MPLS header and add parameters')
parser.add_argument('-i', '--ip', type=str, help='Add IPv4 parameters')
parser.add_argument('-6', '--ip6', type=str, help='Add IPv6 parameters')
parser.add_argument('-t', '--tcp', type=int, action='store', help='Enable TCP header and add parameters')
parser.add_argument('-u', '--udp', type=int, action='store', help='Enable UDP header and add parameters')
parser.add_argument('-l', '--intshim', const=True, action='store_const', help='Enable INT Shim header')
parser.add_argument('-n', '--intmeta', const=True, action='store_const', help='Enable INT Metadata header')
parser.add_argument('-s', '--imstack', type=str, help='Enable INT metadata stack using Switch ID and Timestamp')
parser.add_argument('-p', '--packets', type=int, action='store', help='Number of packets to send')
parser.add_argument('-b', '--bytes', type=int, action='store', help='Bytes for the payload')
parser.add_argument('-r', '--randbytes', const=True, action='store_const',  help='Add random bytes to the payload')
parser.add_argument('-f', '--filename', type=str, help='Path for the filename')
parser.add_argument('-c', '--interface', type=str, help='Name of the interface to send the packet to')
parser.add_argument('-z', '--custom', type=str, action='store', help='Adds a test that is custom')

args = parser.parse_args()

CUSTOM_TESTS = {
    "test1" : [1,2,4,8,16,32,50,64,100,128],
    "test2" : [128,100,64,50,32,16,8,4,2,1]
}


class Rnd_1b(Packet):
    name = "Rnd_1b"
    fields_desc = [
        BitField("f4", 0, 8)
    ]

class Rnd_2b(Packet):
    name = "Rnd_2b"
    fields_desc = [
        BitField("f1", 0, 1),
        BitField("f2", 0, 3),
        BitField("f3", 0, 4),
        BitField("f4", 0, 8)
    ]

class Rnd_4b(Packet):
    name = "Rnd_4b"
    fields_desc = [
        BitField("f1", 0, 8),
        BitField("f2", 0, 8),
        BitField("f3", 0, 8),
        BitField("f4", 0, 8)
    ]

class Rnd_5b(Packet):
    name = "Rnd_5b"
    fields_desc = [
        BitField("f1", 0, 4),
        BitField("f2", 0, 3),
        BitField("f3", 0, 1),
        BitField("f4", 0, 8),
        BitField("f5", 0, 8),
        BitField("f6", 0, 8),
        BitField("f7", 0, 2),
        BitField("f8", 0, 6)
    ]

class Rnd_8b(Packet):
    name = "Rnd_8b"
    fields_desc = [
        BitField("f1", 0, 16),
        BitField("f2", 0, 16),
        BitField("f3", 0, 16),
        BitField("f4", 0, 8),
        BitField("f5", 0, 8)
    ]

class Rnd_10b(Packet):
    name = "Rnd_10b"
    fields_desc = [
        BitField("f1", 0, 4),
        BitField("f2", 0, 3),
        BitField("f3", 0, 1),
        BitField("f4", 0, 8),
        BitField("f5", 0, 4),
        BitField("f6", 0, 16),
        BitField("f7", 0, 16),
        BitField("f8", 0, 4),
        BitField("f9", 0, 8),
        BitField("f10", 0, 16)
    ]

class Rnd_15b(Packet):
    name = "Rnd_15b"
    fields_desc = [
        BitField("f1", 0, 4),
        BitField("f2", 0, 3),
        BitField("f3", 0, 1),
        BitField("f4", 0, 8),
        BitField("f5", 0, 4),
        BitField("f6", 0, 4),
        BitField("f7", 0, 32),
        BitField("f8", 0, 32),
        BitField("f9", 0, 8),
        BitField("f10", 0, 8),
        BitField("f11", 0, 16)
    ]

class Rnd_16b(Packet):
    name = "Rnd_16b"
    fields_desc = [
        BitField("f1", 0, 4),
        BitField("f2", 0, 3),
        BitField("f3", 0, 1),
        BitField("f4", 0, 8),
        BitField("f5", 0, 4),
        BitField("f6", 0, 4),
        BitField("f7", 0, 32),
        BitField("f8", 0, 32),
        BitField("f9", 0, 8),
        BitField("f10", 0, 16),
        BitField("f11", 0, 16)
    ]

class Rnd_20b(Packet):
    name = "Rnd_20b"
    fields_desc = [
        BitField("f1", 0, 16),
        BitField("f2", 0, 16),
        BitField("f3", 0, 8),
        BitField("f4", 0, 8),
        BitField("f5", 0, 1),
        BitField("f6", 0, 3),
        BitField("f7", 0, 4),
        BitField("f8", 0, 16),
        BitField("f9", 0, 16),
        BitField("f10", 0, 32),
        BitField("f11", 0, 8),
        BitField("f12", 0, 32)
    ]

class Rnd_32b(Packet):
    name = "Rnd_32b"
    fields_desc = [
        BitField("f1", 0, 32),
        BitField("f2", 0, 32),
        BitField("f3", 0, 64),
        BitField("f4", 0, 8),
        BitField("f5", 0, 16),
        BitField("f6", 0, 8),
        BitField("f7", 0, 8),
        BitField("f8", 0, 8),
        BitField("f9", 0, 8),
        BitField("f10", 0, 8),
        BitField("f11", 0, 64)
    ]

class Rnd_40b(Packet):
    name = "Rnd_40b"
    fields_desc = [
        BitField("f1", 0, 32),
        BitField("f2", 0, 32),
        BitField("f3", 0, 32),
        BitField("f4", 0, 8),
        BitField("f5", 0, 64),
        BitField("f6", 0, 64),
        BitField("f7", 0, 16),
        BitField("f8", 0, 8),
        BitField("f9", 0, 8),
        BitField("f10", 0, 32),
        BitField("f11", 0, 8),
        BitField("f12", 0, 8),
        BitField("f13", 0, 8)
    ]

class Rnd_50b(Packet):
    name = "Rnd_50b"
    fields_desc = [
        BitField("f1", 0, 32),
        BitField("f2", 0, 32),
        BitField("f3", 0, 32),
        BitField("f4", 0, 8),        
        BitField("f5", 0, 64),
        BitField("f6", 0, 64),
        BitField("f7", 0, 16),
        BitField("f8", 0, 8),
        BitField("f9", 0, 8),
        BitField("f10", 0, 32),
        BitField("f11", 0, 8),
        BitField("f12", 0, 8),
        BitField("f13", 0, 8),
        BitField("f14", 0, 32),
        BitField("f15", 0, 8),
        BitField("f16", 0, 8),
        BitField("f17", 0, 32)
    ]

class Rnd_64b(Packet):
    name = "Rnd_64b"
    fields_desc = [
        BitField("f1", 0, 32),
        BitField("f2", 0, 32),
        BitField("f3", 0, 32),
        BitField("f4", 0, 8),        
        BitField("f5", 0, 64),
        BitField("f6", 0, 64),
        BitField("f7", 0, 16),
        BitField("f8", 0, 8),
        BitField("f9", 0, 8),
        BitField("f10", 0, 32),
        BitField("f11", 0, 8),
        BitField("f12", 0, 8),
        BitField("f13", 0, 8),
        BitField("f14", 0, 32),
        BitField("f15", 0, 32),
        BitField("f16", 0, 16),
        BitField("f17", 0, 64),
        BitField("f18", 0, 8),
        BitField("f19", 0, 8),
        BitField("f20", 0, 32)
    ]

class Rnd_100b(Packet):
    name = "Rnd_100b"
    fields_desc = [
        BitField("f1", 0, 100),
        BitField("f2", 0, 16),
        BitField("f3", 0, 10),
        BitField("f4", 0, 8),        
        BitField("f5", 0, 100),
        BitField("f6", 0, 16),
        BitField("f7", 0, 6),
        BitField("f8", 0, 128),
        BitField("f9", 0, 128),
        BitField("f10", 0, 64),
        BitField("f11", 0, 32),
        BitField("f12", 0, 16),
        BitField("f13", 0, 64),
        BitField("f14", 0, 32),
        BitField("f15", 0, 16),
        BitField("f16", 0, 32),
        BitField("f17", 0, 32)
    ]

class Rnd_128b(Packet):
    name = "Rnd_128b"
    fields_desc = [
        BitField("f1", 0, 100),
        BitField("f2", 0, 100),
        BitField("f3", 0, 50),
        BitField("f4", 0, 8),        
        BitField("f5", 0, 100),
        BitField("f6", 0, 100),
        BitField("f7", 0, 100),
        BitField("f8", 0, 100),
        BitField("f9", 0, 100),
        BitField("f10", 0, 100),
        BitField("f11", 0, 100),
        BitField("f12", 0, 50),
        BitField("f13", 0, 16)
    ]


class MPLS(Packet):
    name = "MPLS"
    fields_desc = [
        BitField("label", 1000, 20),
        BitField("exp", 0, 3),
        BitField("bos", 1, 1),
        ByteField("ttl", 0)
    ]

class INT_shim(Packet):
    oName = "INT Shim Header"

    fields_desc = [
        BitField('type', 1, 4),
        BitField('npt', 0, 2),
        BitField('res1', 0, 1),
        BitField('res2', 0, 1),
        ByteField('len', 0),
        ShortField('npt_field', 0)
    ]

class INT_meta(Packet):
    name = "INT Meta Header"

    fields_desc = [
        BitField('ver', 2, 4),
        BitField('d', 0, 1),
        BitField('e', 0, 1),
        BitField('m', 0, 1),
        BitField('rsvd1', 0, 12),
        BitField('hop_metadata_len', 2, 5),
        ByteField('remaining_hop_cnt', 0),
        BitField('instruction_mask_0003', 3, 4),
        BitField('instruction_mask_0407', 0, 4),
        BitField('instruction_mask_0811', 0, 4),
        BitField('instruction_mask_1215', 0, 4),
        ShortField('domain_sp_id', 0),
        ShortField('ds_inst', 0),
        ShortField('ds_flags', 0)
    ]

class INT_rep_grp(Packet):
    oName = "INT Report Group Header"

    fields_desc = [
        BitField('ver', 0, 4),
        BitField('f', 0, 6),
        BitField('i', 0, 22),
        BitField('rsvd', 0, 4)
    ]

class INT_rep_ind(Packet):
    oName = "INT Report Individual Header"

    fields_desc = [
        BitField('rep_type', 0, 4),
        BitField('in_type', 0, 4),
        ByteField('rep_len', 0),
        ByteField('md_len', 0),
        BitField('d', 0, 1),
        BitField('q', 0, 1),
        BitField('f', 0, 1),
        BitField('i', 0, 1),
        BitField('rsvd', 0, 4)
    ]

class INT_switch_id(Packet):
    name = "Switch ID"

    fields_desc = [
        IntField('switch_id', 0),
    ]

class INT_ingress_tstamp(Packet):
    name = "Ingress Timestamp"

    fields_desc = [
        IntField('ingress_global_timestamp', 0),
    ]

bind_layers(Ether, MPLS, type=0x8847)
bind_layers(MPLS, MPLS, bos=0)
bind_layers(MPLS, IP, bos=1)
bind_layers(INT_shim, INT_meta)

#bind_layers(UDP,INT_shim)
#bind_layers(TCP,INT_shim)


def main():

    if args.ethernet:
        ethernetParams = [p for p in args.ethernet.split(',')]

    if args.rnd:
        rndParams = [p for p in args.rnd.split(',')]

    if args.vlan:
        vlanParams = [p for p in args.vlan.split(',')]

    if args.mpls:
        mplsParams = [int(p) for p in args.mpls.split(',')]

    if args.ip:
        ipParams = [p for p in args.ip.split(',')]
    
    if args.ip6:
        ip6Params = [p for p in args.ip6.split(',')]

    if args.imstack:
        imstackParams = [p for p in args.imstack.split(',')]

    payloadBytes = args.bytes

    print ("Sending packets on interface %s" % (args.interface))

    pkt = None
    if len(ethernetParams) > 2:
        pkt = Ether(type=int(ethernetParams[ETHTYPE], 0), src=ethernetParams[SRC], dst=ethernetParams[DST])
    else:
        pkt = Ether(src=ethernetParams[SRC], dst=ethernetParams[DST])
    
    if args.rnd:            
        numHeaders = int(rndParams[1])           
        for i in range(1, numHeaders+1):
            typeHeader = rndParams[0] if not args.custom else str(CUSTOM_TESTS[args.custom][i-1])+"B"
            typeHeaderNum = int(typeHeader[:-1]) if not args.custom else CUSTOM_TESTS[args.custom][i-1]
            payloadBytes-=typeHeaderNum
            #print("Adding header byte: {}, num: {} and bytesToRemove".format(typeHeader, str(typeHeaderNum), str(payloadBytes)))

            rndtype = 0xAB
            if i == numHeaders:
                rndtype = 0x08

            if typeHeader == "1B":
                pkt = pkt / Rnd_1b(f4=rndtype)
            elif typeHeader == "2B":
                pkt = pkt / Rnd_2b(f1=i,  f4=rndtype)
            elif typeHeader == "4B":
                pkt = pkt / Rnd_4b(f1=i,  f4=rndtype)
            elif typeHeader == "5B":
                pkt = pkt / Rnd_5b(f1=i,  f4=rndtype)
            elif typeHeader == "8B":
                pkt = pkt / Rnd_8b(f1=i,  f4=rndtype)
            elif typeHeader == "10B":
                pkt = pkt / Rnd_10b(f1=i, f4=rndtype)
            elif typeHeader == "15B":
                pkt = pkt / Rnd_15b(f1=i, f4=rndtype)
            elif typeHeader == "16B":
                pkt = pkt / Rnd_16b(f1=i, f4=rndtype)
            elif typeHeader == "20B":
                pkt = pkt / Rnd_20b(f1=i, f4=rndtype)
            elif typeHeader == "32B":
                pkt = pkt / Rnd_32b(f1=i, f4=rndtype)
            elif typeHeader == "40B":
                pkt = pkt / Rnd_40b(f1=i, f4=rndtype)
            elif typeHeader == "50B":
                pkt = pkt / Rnd_50b(f1=i, f4=rndtype)
            elif typeHeader == "64B":
                pkt = pkt / Rnd_64b(f1=i, f4=rndtype)
            elif typeHeader == "100B":
                pkt = pkt / Rnd_100b(f1=i, f4=rndtype)
            elif typeHeader == "128B":
                pkt = pkt / Rnd_128b(f1=i, f4=rndtype)
    
    if args.vlan:
        payloadBytes-=len(vlanParams)*4
        for i, vlaninfo in enumerate(vlanParams):
            items = vlaninfo.split("/")
            vlanid = int(items[0])
            
            vlanh = None
            if len(items) > 1:
                vType = items[1]
                vlanh = Dot1Q(vlan=vlanid, type=int(vType,0))
            else:
                vlanh = Dot1Q(vlan=vlanid)
               
            pkt = pkt / vlanh

    if args.mpls:
        payloadBytes-=len(mplsParams)*4
        for i, mplslabel in enumerate(mplsParams):
            b = 0
            if i == len(mplsParams) - 1:
                b = 1
            pkt = pkt / MPLS(label=mplslabel, bos=b)

    if args.ip:
        payloadBytes-=20
        pkt = pkt / IP(version=int(ipParams[VER]), src=ipParams[SRC], dst=ipParams[DST], tos=int(ipParams[DSCP], 0) << 2)

    elif args.ip6:
        payloadBytes-=40
        pkt = pkt / IPv6(version=int(ip6Params[VER_IP6]),src=ip6Params[SRC], dst=ip6Params[DST])

    if args.udp:
        payloadBytes-=8
        pkt = pkt / UDP(sport=5555, dport=args.udp)
    
    if args.tcp:
        payloadBytes-=20
        pkt = pkt / TCP(sport=0, dport=args.tcp)
    
    if args.intshim:
        pkt = pkt / INT_shim(len=5)
        if args.intmeta:
            pkt = pkt / INT_meta()
            if args.imstack:
                pkt = pkt / \
                        INT_switch_id(switch_id=int(imstackParams[SWITCH_ID])) / \
                        INT_ingress_tstamp(ingress_global_timestamp=int(imstackParams[TIMESTAMP]))

    if args.bytes:
        if args.randbytes:
            pkt = pkt / Raw(load=bytearray(os.urandom(payloadBytes)))
        else:
            pkt = pkt / Raw(load=bytearray([0] * payloadBytes) )

    for i in range(args.packets):    
        #pkt.show()
        #t = time.time_ns()
        if args.udp:
            pkt[UDP].sport = 5555
            #pkt[UDP].sport = i+1
            
        if args.tcp:
            pkt[TCP].sport = i+1
        
        sendp(pkt, iface=args.interface, verbose=False)
        print("Sent packet: "+str(i+1))
        time.sleep(0.3)


if __name__ == '__main__':
    main()
