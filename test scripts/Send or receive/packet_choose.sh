#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--headers)
    HEADERS="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--packets)
    PACKETS="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--packetBytes)
    PBYTES="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--intf)
    INTF="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--custom)
    CUSTOM="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "HEADERS      = ${HEADERS}"
echo "PACKETS      = ${PACKETS}"
echo "PACKET BYTES = ${PBYTES}"
echo "INTERFACE    = ${INTF}"
echo "CUSTOM       = ${CUSTOM}"
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi


eth() {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --bytes $numbytes
}

eth-st () {
  numpackets=$1
  numbytes=$2
  intf=$3
  headerSize=$4
  numRnd=$5
  customTest=$6
  sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55,0xABCD \
    --rnd $headerSize,$numRnd --bytes $numbytes --custom $customTest
}

eth-mpls_1 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000 --bytes $numbytes
}

eth-mpls_2 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000 --bytes $numbytes
}

eth-mpls_3 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000 --bytes $numbytes
}

eth-mpls_4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000 --bytes $numbytes
}

eth-mpls_5 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000 --bytes $numbytes
}

eth-mpls_6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000,6000 --bytes $numbytes
}

eth-mpls_7 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000,6000,7000 --bytes $numbytes
}

eth-mpls_8 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000,6000,7000,8000 --bytes $numbytes
}

eth-mpls_9 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000,6000,7000,8000,9000 --bytes $numbytes
}

eth-mpls_10 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000,6000,7000,8000,9000,10000 --bytes $numbytes
}

eth-mpls_1-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-mpls_2-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-mpls_3-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-mpls_4-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-mpls_5-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-mpls_1-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-mpls_2-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-mpls_3-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-mpls_4-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-mpls_5-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-mpls_1-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-mpls_2-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-mpls_3-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-mpls_4-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-mpls_5-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-mpls_1-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-mpls_2-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-mpls_3-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-mpls_4-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-mpls_5-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-mpls_1-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-mpls_2-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-mpls_3-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-mpls_4-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-mpls_5-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-ipv4-udp_bk () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,ac:1f:6b:62:b9:67 \
    --ip 192.168.1.1,10.98.10.2,0x17,4 --udp 54321 --bytes $numbytes
}

eth-mpls_1-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-mpls_2-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-mpls_3-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-mpls_4-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-mpls_5-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --mpls 1000,2000,3000,4000,5000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-vlan_1 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1001 --bytes $numbytes
}

eth-vlan_2 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1001,1002 --bytes $numbytes
}

eth-vlan_3 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1001,1002,1003 --bytes $numbytes
}

eth-vlan_4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1001,1002,1003,1004 --bytes $numbytes
}

eth-vlan_5 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1001,1002,1003,1004,1005 --bytes $numbytes
}

eth-vlan_1-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-vlan_2-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-vlan_3-ipv4 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000,3000 --ip 192.168.1.1,192.168.2.2,0x17,4 --bytes $numbytes
}

eth-vlan_1-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-vlan_2-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-vlan_3-ipv6 () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/code/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000,3000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --bytes $numbytes
}

eth-vlan_1-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-vlan_2-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-vlan_3-ipv4-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000,3000 --ip 192.168.1.1,192.168.2.2,0x17,4 --tcp 1000 --bytes $numbytes
}

eth-vlan_1-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-vlan_2-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-vlan_3-ipv6-tcp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000,3000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --tcp 1000 --bytes $numbytes
}

eth-vlan_1-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-vlan_2-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-vlan_3-ipv4-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000,3000 --ip 192.168.1.1,192.168.2.2,0x17,4 --udp 1000 --bytes $numbytes
}

eth-vlan_1-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-vlan_2-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 //home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

eth-vlan_3-ipv6-udp () {
   numpackets=$1
   numbytes=$2
   intf=$3
   sudo python3.8 /home/{user}/{repository}/{code_path}/{parser_path}/test_scripts/send.py  \
    --interface $intf  --packets $numpackets --ethernet AA:BB:CC:DD:EE:FF,00:11:22:33:44:55 \
    --vlan 1000,2000,3000 --ip6 0:0:0:0:0:ffff:c0a8:0101,0:0:0:0:0:ffff:c0a8:0202,6 --udp 1000 --bytes $numbytes
}

case $HEADERS in
  eth)
    eth $PACKETS $PBYTES $INTF
    ;;
  eth-st_*)
    arguments=(${HEADERS//_/ })
    eth-st $PACKETS $PBYTES $INTF ${arguments[1]} ${arguments[2]} $CUSTOM
    ;;
  eth-mpls_1)
    eth-mpls_1 $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_2)
    eth-mpls_2 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_3)
    eth-mpls_3 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_4)
    eth-mpls_4 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_5)
    eth-mpls_5 $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_6)
    eth-mpls_6 $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_7)
    eth-mpls_7 $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_8)
    eth-mpls_8 $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_9)
    eth-mpls_9 $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_10)
    eth-mpls_10 $PACKETS $PBYTES $INTF
    ;;
  



  eth-mpls_1-ipv4)
    eth-mpls_1-ipv4 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_2-ipv4)
    eth-mpls_2-ipv4 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_3-ipv4)
    eth-mpls_3-ipv4 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_4-ipv4)
    eth-mpls_4-ipv4 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_5-ipv4)
    eth-mpls_5-ipv4 $PACKETS $PBYTES $INTF
    ;;
  eth-ipv4)
    eth-ipv4 $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_1-ipv6)
    eth-mpls_1-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_2-ipv6)
    eth-mpls_2-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_3-ipv6)
    eth-mpls_3-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_4-ipv6)
    eth-mpls_4-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_5-ipv6)
    eth-mpls_5-ipv6 $PACKETS $PBYTES $INTF
    ;;
  eth-ipv6)
    eth-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_1-ipv4-tcp)
    eth-mpls_1-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_2-ipv4-tcp)
    eth-mpls_2-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_3-ipv4-tcp)
    eth-mpls_3-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_4-ipv4-tcp)
    eth-mpls_4-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_5-ipv4-tcp)
    eth-mpls_5-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;
  eth-ipv4-tcp)
    eth-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_1-ipv6-tcp)
    eth-mpls_1-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_2-ipv6-tcp)
    eth-mpls_2-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_3-ipv6-tcp)
    eth-mpls_3-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_4-ipv6-tcp)
    eth-mpls_4-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_5-ipv6-tcp)
    eth-mpls_5-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;    
  eth-ipv6-tcp)
    eth-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;    
  eth-mpls_1-ipv4-udp)
    eth-mpls_1-ipv4-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_2-ipv4-udp)
    eth-mpls_2-ipv4-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_3-ipv4-udp)
    eth-mpls_3-ipv4-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_4-ipv4-udp)
    eth-mpls_4-ipv4-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_5-ipv4-udp)
    eth-mpls_5-ipv4-udp $PACKETS $PBYTES $INTF
    ;;
  eth-ipv4-udp)
    eth-ipv4-udp $PACKETS $PBYTES $INTF
    ;;
  eth-mpls_1-ipv6-udp)
    eth-mpls_1-ipv6-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_2-ipv6-udp)
    eth-mpls_2-ipv6-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_3-ipv6-udp)
    eth-mpls_3-ipv6-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_4-ipv6-udp)
    eth-mpls_4-ipv6-udp $PACKETS $PBYTES $INTF
    ;;

  eth-mpls_5-ipv6-udp)
    eth-mpls_5-ipv6-udp $PACKETS $PBYTES $INTF
    ;;  
  eth-ipv6-udp)
    eth-ipv6-udp $PACKETS $PBYTES $INTF
    ;;  
  eth-vlan_1)
    eth-vlan_1 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_2)
    eth-vlan_2 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_3)
    eth-vlan_3 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_4)
    eth-vlan_4 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_5)
    eth-vlan_5 $PACKETS $PBYTES $INTF
    ;;
    

  eth-vlan_1-ipv4)
    eth-vlan_1-ipv4 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_2-ipv4)
    eth-vlan_2-ipv4 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_3-ipv4)
    eth-vlan_3-ipv4 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_1-ipv6)
    eth-vlan_1-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_2-ipv6)
    eth-vlan_2-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_3-ipv6)
    eth-vlan_3-ipv6 $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_1-ipv4-tcp)
    eth-vlan_1-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_2-ipv4-tcp)
    eth-vlan_2-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_3-ipv4-tcp)
    eth-vlan_3-ipv4-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_1-ipv6-tcp)
    eth-vlan_1-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_2-ipv6-tcp)
    eth-vlan_2-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_3-ipv6-tcp)
    eth-vlan_3-ipv6-tcp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_1-ipv4-udp)
    eth-vlan_1-ipv4-udp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_2-ipv4-udp)
    eth-vlan_2-ipv4-udp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_3-ipv4-udp)
    eth-vlan_3-ipv4-udp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_1-ipv6-udp)
    eth-vlan_1-ipv6-udp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_2-ipv6-udp)
    eth-vlan_2-ipv6-udp $PACKETS $PBYTES $INTF
    ;;

  eth-vlan_3-ipv6-udp)
    eth-vlan_3-ipv6-udp $PACKETS $PBYTES $INTF
    ;;

  *)
    echo -n "no option found"
    ;;
esac
