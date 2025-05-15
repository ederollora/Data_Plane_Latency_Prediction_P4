import statistics
import sys
import os
from glob import glob
import time
from collections import Counter
import random

def getAllEntries(maxKeyEntries):
    allNumentries = 1
    for num in maxKeyEntries:
        allNumentries = allNumentries * num
    return allNumentries

def comb_in_list(entry, allGenEntries):
    if entry in allGenEntries:
        return True
    return False    
    #for list in allEntries:
    #    if Counter(entry) == Counter(list):
    #        return True
    #return False

def get_rand_combination(ks, mask, types, allGenEntries, maxPosEntries):
    cntinue = True
    oneEntry = None
    i = 0
    while cntinue:
        oneEntry=[]
        for idx, bit_width in enumerate(ks):
            if types[idx] == "exact":
                oneEntry.append(random.randint(0, 2**bit_width-1))
            else:
                oneEntry.append(random.randrange(0, (2**bit_width), (2**(bit_width-mask[idx]))))
        cntinue = comb_in_list(oneEntry, allGenEntries)
        i +=1

        #if(i%1000==0):
        #    print("%d,%d" % (len(allGenEntries), maxPosEntries))
        #    time.sleep(2)
        if len(allGenEntries) == maxPosEntries:
            return None
    return oneEntry


def gen_rules(table_name, action_name, key_names, key_types, key_sizes, key_masks, arg_names, arg_values, total_rules, dir, filename):

    allGenEntries = []

    i = 0

    maxPosEntries = getAllEntries([2**b if key_types[i] == "exact" else 2**(key_masks[i]) for i, b in enumerate(key_sizes)])
    print(maxPosEntries)

    while i < total_rules:
        if len(allGenEntries) == maxPosEntries:
            break;
        oneEntry = get_rand_combination(key_sizes, key_masks, key_types, allGenEntries, maxPosEntries)
        
        if oneEntry == None:
            break
        allGenEntries.append(oneEntry)
        i+=1
    
    if len(allGenEntries) == maxPosEntries:
        print("Generated as many entries (%d) as possible (%d)" % (len(allGenEntries), maxPosEntries) )
    elif len(allGenEntries) == total_rules:
        print("Generated as many entries (%d) as the total rules needed (%d)" % (len(allGenEntries), total_rules) )
    
    open(dir+"/"+filename, "w").close()
    with open(dir+"/"+filename, 'a') as f:
        num_keys = len(key_names)
        for entry in allGenEntries:
            argparts = ["{}={}".format(arg, arg_values[idx]) for idx, arg in enumerate(arg_names) if arg!="_"]

            keyparts = []
            for idx, key in enumerate(key_names):
                #if(key == "_"):
                #    continue
                if(key_types[idx] == "exact"):
                    keyparts.append("{}={}".format(key, entry[idx]))
                else:
                    keyparts.append("{}={}, {}_p_length={}".format(key, entry[idx], key, key_masks[idx]))
            
            
            keyvalues = ','.join(keyparts)
            argvalues = ','.join(argparts)

            allArgs = ','.join(filter(None, [keyvalues, argvalues]))

            f.write('bfrt.switch.pipe.Ingress.%s.add_with_%s(%s);\n' % (table_name, action_name, allArgs))
            #print('bfrt.switch.pipe.Ingress.%s.add_with_%s(%s, %s);' % (table_name, action_name, keyvalues, argvalues))

if __name__ == "__main__":
    table_name = sys.argv[1]
    action_name = sys.argv[2]
    key_names = [name for name in sys.argv[3].split(":")]
    key_types = [type for type in sys.argv[4].split(":")]
    key_sizes = [int(size) for size in sys.argv[5].split(":")]
    key_masks = [int(mask) for mask in sys.argv[6].split(":")]
    arg_names = [arg for arg in sys.argv[7].split(":")]
    arg_values = [argval for argval in sys.argv[8].split("/")]
    total_rules = int(sys.argv[9])
    dir = sys.argv[10]
    filename = sys.argv[11]
    
    if not os.path.isdir(dir):
        print(problem)
    
    gen_rules(table_name, action_name, key_names, key_types, key_sizes, key_masks, arg_names, arg_values, total_rules, dir, filename)
