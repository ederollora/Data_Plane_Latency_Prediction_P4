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
    -n|--numheaders)
    NUMHEADERS="$2"
    shift # past argument
    shift # past value
    ;;
    -z|--hbytes)
    HBYTES="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--spackets)
    SENDPACKETS="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--spayload)
    SENDPAYLOAD="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--sintf)
    SINTF="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--rintf)
    RINTF="$2"
    shift # past argument
    shift # past value
    ;;
    -w|--rpath)
    RECPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--rfilename)
    RECFILENAME="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--custom)
    CUSTOM="$2"
    CUSTOM_ARG="--custom"
    WITH_CUSTOM=true
    shift # past argument
    shift # past value
    ;;
    -t|--list)
    LIST_HDRS="$2"
    LIST_WKH=true
    shift # past argument
    shift # past value
    ;;
    -j|--testname)
    TESTNAME="$2"
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
echo "NUMHEADERS   = ${NUMHEADERS}"
echo "HBYTES       = ${HBYTES}"
echo "SENDPACKETS  = ${SENDPACKETS}"
echo "SENDPAYLOAD  = ${SENDPAYLOAD}"
echo "SINTF        = ${SINTF}"
echo "RINTF        = ${RINTF}"
echo "RECPATH      = ${RECPATH}"
echo "RECFILENAME  = ${RECFILENAME}"
echo "CUSTOM       = ${CUSTOM}"
echo "LIST_HDRS    = ${LIST_HDRS}"
echo "TESTNAME     = ${TESTNAME}"

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi

if [ "$LIST_WKH" = true ]; then
    hdrs=(${LIST_HDRS//,/ })
    NUMHEADERS=$(( ${#hdrs[@]} - 1 ))
fi


START=0
END=$NUMHEADERS
## save $START, just in case if we need it later ##
n=$START
for n in $(eval echo "{$START..$END}")
do
    echo "Running send and receive scripts for n=$n"
    SEND_PID=0
    TYPEHDR="rnd"

    if [[ "$n" -eq "0" ]]; then

        if [ "$WITH_CUSTOM" = true ]; then
            TYPEHDR=$CUSTOM
            fn="15_${CUSTOM}_eth"
        elif [ "$LIST_WKH" = true ]; then
            everyHeader=(${LIST_HDRS//,/ })
            fn="15_${TESTNAME}_${everyHeader[${n}]}_${n}case"
        else
            TYPEHDR="rnd"
            fn="15_${TYPEHDR}_${HBYTES}B_eth"
        fi

        sudo python3.8 ~/{repository}/{code_path}/{parser_path}/{test_scripts_path}/receive.py \
        --interface $RINTF --filename $fn --packets $SENDPACKETS --resultpath $RECPATH  > /dev/null 2>&1 &
        
        REC_PID=$!
        echo "Receiver running,  script PID: $REC_PID"

        sleep 2

        sudo ~/{repository}/{code_path}/{parser_path}/{test_scripts_path}/packet_choose.sh \
        -h eth -i $SINTF -p $SENDPACKETS -b $SENDPAYLOAD $CUSTOM_ARG $CUSTOM
        SEND_PID=$!
        echo "Sender script PID: $SEND_PID"
        
    else

        if [ "$WITH_CUSTOM" = true ]; then
            TYPEHDR=$CUSTOM
            fn="15_${CUSTOM}_${n}case"
            headr="eth-st_${HBYTES}B_${n}"
        elif [ "$LIST_WKH" = true ]; then
            everyHeader=(${LIST_HDRS//,/ })
            fn="15_${TESTNAME}_${everyHeader[${n}]}_${n}case"
            headr="${everyHeader[$n]}"
        else
            TYPEHDR="rnd"
            fn="15_${TYPEHDR}_${HBYTES}B_${n}hdrs"
            headr="eth-st_${HBYTES}B_${n}"
        fi

        sudo python3.8 ~/{repository}/{code_path}/{parser_path}/{test_scripts_path}/receive.py \
        --interface $RINTF --filename $fn --packets $SENDPACKETS --resultpath $RECPATH > /dev/null 2>&1 &
        
        REC_PID=$!
        echo "Receiver running, script PID: $REC_PID"  

        sleep 2


        sudo ~/{repository}/{code_path}/{parser_path}/{test_scripts_path}/packet_choose.sh \
        -h $headr -i $SINTF -p $SENDPACKETS -b $SENDPAYLOAD $CUSTOM_ARG $CUSTOM
        
        SEND_PID=$!
        echo "Sender script PID: $SEND_PID"

    fi

    FIN_SEND=0
    FIN_REC=0
    FINISHED=1

    while [[ "$FIN_REC" != "$FINISHED" ]]
    do
        FIN_REC=$(ps -p "$REC_PID" | wc -l)
        
        sleep 5
    done

    echo "Finished running send and receive scripts for n=$n"
    
    sleep 3
    
done

