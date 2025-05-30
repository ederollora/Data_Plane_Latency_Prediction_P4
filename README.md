# Data Plane Latency Prediction P4



This code repository will be made public after the paper *"Data Plane Latency Predictability in P4 Programmable ASIC-based Hardware"* is reviewed.



#### Things to know

1. A list of commands can be found in  [`commands_list.txt`](commands/how_to_process.txt) .

2. An example packet in plain text is available in [`packet_example.txt`](commands/packet_example.txt) 

   1. The tools for generating traffic for the [`rules for S1 switch`](P4%20Code/rules%20for%20S1%20switch)   are located in the [`rules`](test%20scripts/rule%20creation%20in%20P4%20code) folder.

3. The P4 collector is implemented in Go (UDP server), and the main file is available at  [`main.go`](UDP%20Server/Golang%20sampling%20switch%20(Collector)/src). 

   - The [`BPF collector`](UDP%20Server/BPF%20(not%20used)) **<u>IS NOT BEING USED</u>** but it’s included in case it’s useful for others. It will be marked as not being used.

4. The P4 programs are located in [`P4 Code/p4`](P4%20Code/p4). Additional rules (you can't configure the tables without entries) can be found in [`P4 code/rules for S1 switch`](P4%20Code/rules%20for%20S1%20switch) .

5. We run the whole file (P4) with this command:

   **`~/tools/p4_build.sh switch.p4 P4PPFLAGS="-DHDR_20B -DRND_HEADER -DSAME_10HDR -DCASE_10ST"`**

6. There are [`send or receive`](test%20scripts/Send%20or%20receive) available to verify if packets pass through the switch. If a packet reaches S2, it means the configuration is working as expected. For example:

   **`test_scripts/packet_choose_for_test.sh -h eth-mpls_3-ipv4 -p 10 -b 128 -i eth0`**

   - sends 50 packets (-p 50)
   - 128B payload (-l 128)
   - eth-st header (-h)
   - 2 randomized headers (-n 2) of 16 bytes each (-z 16),
   - eth0 to send, eth1 to receive
   - saves results to /home/user/results/resultfile_*

7. You will use the [`collector statistics`](test%20scripts/Collector%20statistic) to analyze latency for predictability or informational purposes.

   


#### Wireshark

**`sudo xauth add $(xauth -f .Xauthority list|tail -1)`** 
