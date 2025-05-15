import statistics
import sys
import os
from glob import glob

writeALL=True
writeAvgs=True


def process_stats(main_dir, dir):
    # All
    resultAcc = [y for x in os.walk(dir) for y in glob(os.path.join(x[0], '{ingress_latency}.txt'))]
    resultConv = [y for x in os.walk(dir) for y in glob(os.path.join(x[0], '*{conv_ingress_latency}.txt'))]
    # The start (*) is intentional

    meanResults = {}
    for file in resultAcc:
        n = file.split("/")[2]

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

        print(n+" : "+str(mean))
        
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
                        case = "ET"
                    else:
                        case = str(index)+"H"
                    print("        ^ %s: %s" % (case, latency,))


        #print("%s -> Mean: %f , Media: %f" % (name, statistics.mean(latencies), statistics.median(latencies),))
        #print("Mean: ", statistics.mean(latencies))
        #print("Median: ", statistics.median(latencies))
        #print("Median Low: ", statistics.median_low(latencies))
        #print("Median High: ", statistics.median_high(latencies))
        #print("Multimode: ", statistics.multimode(latencies))
        #print("Std. Deviation: ", statistics.stdev(latencies))
        #print("Variance: ", statistics.variance(latencies))

if __name__ == "__main__":
    main_dir = sys.argv[1]
    for dir in os.scandir(main_dir):
        if not dir.is_dir():
            continue
        p=dir.path
        
        process_stats(main_dir, dir.path)
