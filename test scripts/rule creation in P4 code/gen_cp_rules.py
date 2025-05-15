import statistics
import sys
import os
from glob import glob
import time


def gen_rules(type, rules, tables, matches, mask, kw, dir, filename):

    if type == "exact":
        if matches == 1:
            open(dir+"/"+filename, "w").close()
            with open(dir+"/"+filename, 'a') as f:
                for t in range (1, tables+1):
                    i = 0
                    counter = 0
                    f.write('\n\n')
                    while i < key_width[0]:
                        f.write('bfrt.switch.pipe.Ingress.t%d.add_with_set_output(field0=%d, port=2);' % (t, i))
                        i += 1
                        counter += 1
                        if counter == rules:
                            print("Forced END: For t=%d, entries=%d, i=%d" % (t, counter, i))
                            break;
                    if counter == key_width:
                        print("For t=%d, entries=%d, i=%d" % (t, counter, i))
                f.write('\n\n')
        elif matches == 2:
            open(dir+"/"+filename, "w").close()
            with open(dir+"/"+filename, 'a') as f:
                counter = 0
                for t in range (1, tables+1):
                    i = 0
                    j = 0
                    counter = 0
                    f.write('\n\n')
                    while i < key_width[0]:
                        while j < key_width[1]:
                            f.write('bfrt.switch.pipe.Ingress.t%d.add_with_set_output(custom1_field0=%d,custom2_field0=%d, port=2);' % (t, i, j))
                            j += 1
                            counter += 1
                            if counter == rules:
                                break;
                        if counter == rules:
                            print("Forced END: For t=%d, entries=%d, i=%d, j=%d" % (t, counter, i, j))
                            break;

                        i += 1
                        j = 0
                    print("For t=%d, entries=%d, i=%d, j=%d" % (t, counter, i, j))
                f.write('\n\n')
        elif matches == 3:
            open(dir+"/"+filename, "w").close()
            with open(dir+"/"+filename, 'a') as f:
                counter = 0
                for t in range (1, tables+1):
                    i = 0
                    j = 0
                    k = 0
                    counter = 0
                    f.write('\n\n')
                    while i < key_width[0]:
                        while j < key_width[1]:
                            while k < key_width[2]:
                                f.write('bfrt.switch.pipe.Ingress.t%d.add_with_set_output(custom1_field0=%d,custom2_field0=%d, custom3_field0=%d, port=2);' % (t, k, j, i))
                                k += 1
                                counter += 1
                                if counter == rules:
                                    break;
                            if counter == rules:
                                break;

                            j += 1
                            k = 0
                        
                        if counter == rules:
                            print("Forced END: For t=%d, entries=%d, k=%d, j=%d, i=%d" % (t, counter, k, j, i))
                            break;

                        i += 1
                        j = 0
                        k = 0
                    print("For t=%d, entries=%d, k=%d, j=%d, i=%d" % (t, counter, k, j, i))
                f.write('\n\n')
    else:
        print("Hi")
        if matches == 1:
            open(dir+"/"+filename, "w").close()
            with open(dir+"/rules.txt", 'a') as f:
                for t in range (1, tables+1):
                    counter = 0
                    base = 0
                    n = 2**(kw-mask)
                    f.write('\n\n')
                    while base < key_width[0]:
                        f.write('bfrt.switch.pipe.Ingress.t%d.add_with_set_output(field0=%d, field0_p_length=%d,port=2);' % (t, base, mask))
                        counter += 1
                        if counter == rules:
                            print("Forced END: For t=%d, entries=%d, base=%d" % (t, counter, base))
                            break;
                        base += n
                    
                    if base == key_width[0]:
                        print("For t=%d, entries=%d, i=%d" % (t, counter, base))
                f.write('\n\n')

if __name__ == "__main__":
    match_type = sys.argv[1]
    key_width = 2**int(sys.argv[2])[int(x) for x in sys.argv[2].split(":")]
    mask = int(sys.argv[3])
    num_rules = int(sys.argv[4])
    max_tables = int(sys.argv[5])
    matches = int(sys.argv[6])
    dir = sys.argv[7]
    filename = sys.argv[8]
    if not os.path.isdir(dir):
        print(problem)
    gen_rules(match_type, num_rules, max_tables, matches, mask, int(sys.argv[2]), dir, filename)
