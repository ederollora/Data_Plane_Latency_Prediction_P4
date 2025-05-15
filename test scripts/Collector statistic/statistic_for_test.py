import statistics
import sys
import os
from glob import glob

writeALL=True
writeAvgs=True

INCR_LIST = [1,2,4,8,16,32,50,64,100,128]
meanResults = {}

def process_stats(main_dir, dir):
    # All
    resultAcc = [y for x in os.walk(dir) for y in glob(os.path.join(x[0], '{ingress_latency}.txt'))]
    resultConv = [y for x in os.walk(dir) for y in glob(os.path.join(x[0], '*{conv_ingress_latency}.txt'))]
    # The start (*) is intentional
    #print(result)



    for file in resultAcc:
        file=file.replace(":","_")
        file=file.replace("HDR","H")

        #if "ONLYETH" not in file:
        #    if "x1H" not in file:
        #        continue
        #if "_404B" not in file:
        #    if "1204B" not in file:
        #    continue
        name=file.split("/")[9]
        #print(name)

        file_name = "_".join(name.split("_")[0:7])
        packet_size = name.split("_")[3].split("B")[0]
        header_type = name.split("_")[5]
        header_amount = name.split("_")[6]
        tables = name.split("_")[7]
        tb_entry_size = name.split("_")[8]
        number_keys = name.split("_")[9]
        key_size = name.split("_")[10]
        action = name.split("_")[11]
        output = name.split("_")[12]

        #print(name)
        #print(file_name)
        #print(packet_size)
        #print(byte_extract)
        #print(header_amount)

        lines = []
        with open(file, 'r') as reader:
            lines = reader.readlines()

        if not lines:
            continue

        accumulator = 0
        samples = 0   
        for line in lines[1:]:
            ingress_latency = line.split(",")[0]
            count = line.split(",")[1]
            accumulator += (int(ingress_latency) * int(count))
            samples += int(count)    
        
        mean = format(accumulator / samples, ".3f")

        if file_name not in meanResults:
            print(file_name)
            meanResults[file_name] = { "mean_lib" : [0]*11, "means" : [0]*11 }

        currentIndex = 0
        t = tables.split("-")
        if len(t) > 1:
            currentIndex = int(t[1])
        else:
            currentIndex = int(t[0][1:])

        new_means_list = [mean if index == currentIndex else value for index, value in enumerate(meanResults[file_name]["means"])]
        #print(new_means_list)
        meanResults[file_name]["means"] = new_means_list

def print_resultS(main_dir, dir):
    print(main_dir)
    
    for name, values in meanResults.items():
        with open(main_dir+"/all.txt", 'a') as all_data:
            with open(dir+"/"+name+"_averages.txt", 'a') as the_file:

                speed=name.split("_")[0][:-1]
                port_config=0
                if speed == "95":
                    port_config = "100"
                elif speed == "9.5":
                    port_config = "10"

                packet_size =  int(name.split("_")[3].split("B")[0])-4
                byte_extract = name.split("-")[-1].split("x")[0][:-1]
                
                print(name+" :")
                print("  "+name.split("_")[3].split("y")[0]+" :")
                for index, latency in enumerate(values["means"]):
                    if latency == 0:
                        continue
                    
                    case = ""
                    if index == 0:
                        case = "0T"
                    else:
                        case = str(index)+"T"
                    print("        ^ %s: %s" % (case, latency,))

                    #if writeAvgs:
                    #    the_file.write('%s\n' % (latency,))
                    if writeALL:
                        new_byte_extract = byte_extract
                        if(not byte_extract.isnumeric()):
                            if byte_extract == "INC" or byte_extract == "DEC":
                                byte_list = INCR_LIST if byte_extract == "INC" else INCR_LIST.reverse()
                                i = 1
                                extracted_bts = [0] * 10
                                while i <= int(index):
                                    extracted_bts = [byte_list[i-1] if i-1 == listIndex else value for listIndex, value in enumerate(extracted_bts)]
                                    i += 1
                                new_byte_extract = ";".join(str(x) for x in extracted_bts)
                        
                    #    all_data.write('%s,%s,%s,%d,%s\n' %(port_config, new_byte_extract, index, packet_size, latency))

        #print("%s -> Mean: %f , Media: %f" % (name, statistics.mean(latencies), statistics.median(latencies),))
        #print("Mean: ", statistics.mean(latencies))
        #print("Median: ", statistics.median(latencies))
        #print("Median Low: ", statistics.median_low(latencies))
        #print("Median High: ", statistics.median_high(latencies))
        #print("Multimode: ", statistics.multimode(latencies))
        #print("Std. Deviation: ", statistics.stdev(latencies))
        #print("Variance: ", statistics.variance(latencies))
    
    #print("#####################################################")

if __name__ == "__main__":
    main_dir = sys.argv[1]
    for dir in os.scandir(main_dir):
        if not dir.is_dir():
            continue
        p=dir.path
        
        process_stats(main_dir, dir.path)
    
    print(meanResults)
    print_resultS(main_dir, dir.path)
