
## NOT BEING USED, SOME PARTS MAYBE WORKING AND SOME OTHER PARTS MAYBE NOT. IN SUMMARY, WE HAVE NOT TIME TO MAKE IT WORK.

from bcc import BPF
from bcc.utils import printb
import multiprocessing
import os, datetime


parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('-i', '--interface', type=str, help='Interface to listen on')
parser.add_argument('-f', '--filename', type=str, help='Filename')
parser.add_argument('-r', '--resultpath', type=str, help='Path for result files')
parser.add_argument('-s', '--staticpath', type=str, help='')


args = parser.parse_args()


ret = "XDP_DROP"
ctxtype = "xdp_md"
mode = BPF.XDP


def main():

    if args.interface:
        ethernetParams = [p for p in args.ethernet.split(',')]

    if args.rnd:
        rndParams = [p for p in args.rnd.split(',')]

    if args.vlan:

    #b = BPF(src_file="ts_picker.c", cflags=["-DNUM_CPUS=%d" % multiprocessing.cpu_count()])
    b = BPF(src_file="ts_picker.c", cflags=["-w", "-DRETURNCODE=%s" % ret, "-DCTXTYPE=%s" % ctxtype])
    fn = b.load_func("timestamp_picker", mode) #4
    b.attach_xdp(args.interface, fn, 0) #5

    ingress_lat_cnt = b.get_table("ingress_lat_cnt")
    egress_lat_cnt = b.get_table("egress_lat_cnt")
    e2e_lat_cnt = b.get_table("e2e_lat_cnt")

    try:
        b.trace_print() #6
    except KeyboardInterrupt: #7

        #pktCounter = b.get_table("pkt_counter")

        #for k, v in pktCounter.items():
        #    print("Packet Counter %10d" % v.value)

        total = 0

        mydir = ""

        nameIngress = "ingressLatency"
        nameIngress = "egressLatency"
        nameE = "e2eLatency"


        if not args.staticpath:
            mydir = os.path.join(args.resultpath, args.filename, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S'))
        else:
            mydir = args.staticpath
    

        myfile = os.path.join(mydir,"results_"+nameIngress+args.filename+".txt")
        for k, v in ingress_lat_cnt.items():
            #print("INGRESS -> TIME: %d, COUNT: %d" % (k.value, v.value))
             myfile.write("%d,%d\n" % (k.value, v.value))
            total = total + v.value
        print("Writen to ingress latency file.")
        myfile.close()

        myfile = os.path.join(mydir,"results_"+nameEgress+args.filename+".txt")
        for k, v in egress_lat_cnt.items():
            #print("EGRESS -> TIME: %d, COUNT: %d" % (k.value, v.value))
            myfile.write("%d,%d\n" % (k.value, v.value))
        print("Writen to egress latency file.")
        myfile.close()

        myfile = os.path.join(mydir,"results_"+nameEgress+args.filename+".txt")
        for k, v in e2e_lat_cnt.items():
            #print("E2E -> TIME: %d, COUNT: %d" % (k.value, v.value))
            myfile.write("%d,%d\n" % (k.value, v.value))
        print("Writen to egress latency file.")
        myfile.close()
        
        print("Total ingress latency probes: %10d" % total)

    b.remove_xdp(device) #11

if __name__ == '__main__':
    main()
