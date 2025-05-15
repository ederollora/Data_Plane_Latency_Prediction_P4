## NOT BEING USED, SOME PARTS MAYBE WORKING AND SOME OTHER PARTS MAYBE NOT. IN SUMMARY, WE HAVE NOT TIME TO MAKE IT WORK.

#!/usr/bin/env python

from bcc import BPF

# load BPF program
b = BPF(text="""

BPF_HASH(last);

int do_trace(struct pt_regs *ctx) {
        bpf_trace_printk("Packet arrived\\n");
	return 0;
}
""")

b.attach_kprobe(event="sys_sync", fn_name="do_trace")
print("Tracing for quick sync's... Ctrl-C to end")

# format output
start = 0
while 1:
    (task, pid, cpu, flags, ts, ms) = b.trace_fields()
    if start == 0:
        start = ts
    ts = ts - start
    print("At time %.2f s: multiple syncs detected, last %s ms ago" % (ts, ms))
