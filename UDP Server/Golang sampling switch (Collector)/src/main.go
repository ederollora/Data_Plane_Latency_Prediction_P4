package main

import (
	"encoding/binary"
	//"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"path"
	"runtime"
	"sync"
	"sync/atomic"
	"time"

	"github.com/akamensky/argparse"
)

const (
	flushInterval = time.Duration(1) * time.Second
	maxQueueSize  = 10000000
	UDPPacketSize = 1500
	locTS6        = 8
	locTS5        = 14
	locTS4        = 17
	locTS3        = 20
	locTS2        = 26
	locTS1        = 32
)

var address string
var bufferPool sync.Pool
var ops uint64 = 0
var total uint64 = 0
var flushTicker *time.Ticker
var nbWorkers int

var smInLat sync.Map
var smEgLat sync.Map
var smE2ELat sync.Map

func init() {
	//flag.StringVar(&address, "addr", ":54321", "Address of the UDP server to test")
	//flag.IntVar(&nbWorkers, "concurrency", runtime.NumCPU(), "Number of workers to run in parallel")
}

type message struct {
	addr   net.Addr
	msg    []byte
	length int
}

type latency struct {
	ingressLat uint64
	egressLat  uint64
	e2eLat     uint64
}

type messageQueue chan message
type latencyQueue chan latency

var fileName *string
var resultPath *string
var intfw *string
var listenPort *string

var workers int = runtime.NumCPU()

var ingressLatencyFile = "{ingress_latency_path.txt}"

//string egressLatencyFile = "{egress_latency_path.txt}"
//string e2eLatencyFile = "{eg2eg_latency_path.txt}.txt"

func (mq messageQueue) msgEnqueue(m message) {
	mq <- m
}

func (mq messageQueue) msgDequeue() {
	for m := range mq {
		handleMessage(m.addr, m.msg[0:m.length])
		bufferPool.Put(m.msg)
	}
}

func (lq latencyQueue) latEnqueue(l latency) {
	lq <- l
}

func (lq latencyQueue) latDequeue() {
	for l := range lq {
		handleLatency(l)
		//bufferPool.Put(m.msg)
	}
}

var mq messageQueue
var lq latencyQueue

func main() {

	parser := argparse.NewParser("main", "Listens for UDP packets")

	listenPort = parser.String(
		"p",
		"lPort",
		&argparse.Options{Required: true, Help: "Listen for the UDP server to listen on"})

	fileName = parser.String(
		"f",
		"filename",
		&argparse.Options{Required: true, Help: "Name of the file to be used in results"})

	resultPath = parser.String(
		"r",
		"resultpath",
		&argparse.Options{Required: true, Help: "Path to store the results"})

	intfw = parser.String(
		"i",
		"interface",
		&argparse.Options{Required: true, Help: "Interface ot listne on"})

	err := parser.Parse(os.Args)

	if err != nil {
		//fmt.Print(parser.Usage(err))
		log.Print("Parser for CLI arguments is Ok.\n")
	}

	log.Printf("Path: %s", GetPathName())
	log.Printf("ResPath: %s", *resultPath)
	log.Printf("Filename: %s", *fileName)
	log.Printf("Port: %s", *listenPort)

	//runtime.GOMAXPROCS(runtime.NumCPU())

	log.Printf("Cores: %d", runtime.NumCPU())
	//flag.Parse()

	bufferPool = sync.Pool{
		New: func() interface{} { return make([]byte, UDPPacketSize) },
	}

	mq = make(messageQueue, maxQueueSize)
	lq = make(latencyQueue, maxQueueSize)

	listenAndReceive(workers)
	countOccurrences(workers)

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		for range c {
			atomic.AddUint64(&total, ops)
			log.Printf("Total ops %d", total)
			smPrint()
			os.Exit(0)
		}
	}()

	flushTicker = time.NewTicker(flushInterval)
	for range flushTicker.C {
		log.Printf("Ops/s %f", float64(ops)/flushInterval.Seconds())
		atomic.AddUint64(&total, ops)
		atomic.StoreUint64(&ops, 0)
	}
}

func countOccurrences(maxWorkers int) error {

	for i := 0; i < maxWorkers; i++ {
		go lq.latDequeue()
		//go receive(c)
	}
	return nil
}

func listenAndReceive(maxWorkers int) error {
	c, err := net.ListenPacket("udp4", ":"+*listenPort)
	if err != nil {
		return err
	}
	log.Printf("Workers: %d", maxWorkers)
	for i := 0; i < maxWorkers; i++ {
		go mq.msgDequeue()
		go receive(c)
	}
	return nil
}

// receive accepts incoming datagrams on c and calls handleMessage() for each message
func receive(c net.PacketConn) {
	defer c.Close()

	for {
		msg := bufferPool.Get().([]byte)
		nbytes, addr, err := c.ReadFrom(msg[0:])
		if err != nil {
			log.Printf("Error %s", err)
			continue
		}
		mq.msgEnqueue(message{addr, msg, nbytes})
	}
}

func handleLatency(latValues latency) {

	if _, ok := smInLat.Load(latValues.ingressLat); !ok {
		smInLat.Store(latValues.ingressLat, uint64(1))
	} else {
		v, _ := smInLat.Load(latValues.ingressLat)
		val, _ := v.(uint64)
		smInLat.Store(latValues.ingressLat, val+uint64(1))
	}

	if _, ok := smEgLat.Load(latValues.egressLat); !ok {
		smEgLat.Store(latValues.egressLat, uint64(1))
	} else {
		v, _ := smEgLat.Load(latValues.egressLat)
		val, _ := v.(uint64)
		smEgLat.Store(latValues.egressLat, val+uint64(1))
	}

	if _, ok := smE2ELat.Load(latValues.e2eLat); !ok {
		smE2ELat.Store(latValues.e2eLat, uint64(1))
	} else {
		v, _ := smE2ELat.Load(latValues.e2eLat)
		val, _ := v.(uint64)
		smE2ELat.Store(latValues.e2eLat, val+uint64(1))
	}

}

func handleMessage(addr net.Addr, buf []byte) {

	//log.Printf("Packet received\n")
	//var ts2Lat uint64

	ingressLat := uint64(0)
	egressLat := uint64(0)
	e2eLat := uint64(0)

	ts6_unprocessed := append([]byte{0x0, 0x0}, buf[0:locTS6-2]...)    // From 0 to 6 bytes (ignore last 2 bytes which are fraction)
	ts5_unprocessed := append([]byte{0x0, 0x0}, buf[locTS6:locTS5]...) // form byte 8 to byte 14
	ts3_unprocessed := append([]byte{0x0, 0x0, 0x0, 0x0, 0x0}, buf[locTS4:locTS3]...)
	ts2_unprocessed := append([]byte{0x0, 0x0}, buf[locTS3:locTS2]...)
	ts1_unprocessed := append([]byte{0x0, 0x0}, buf[locTS2:locTS1]...)

	//fmt.Printf("[% x]\n", ts3_unprocessed)
	//fmt.Printf("[% x]\n", ts2_unprocessed)

	ts6 := binary.BigEndian.Uint64(ts6_unprocessed) & 0x3FFFF
	ts5 := binary.BigEndian.Uint64(ts5_unprocessed) & 0x3FFFF
	ts3 := binary.BigEndian.Uint64(ts3_unprocessed) & 0x3FFFF
	ts2 := binary.BigEndian.Uint64(ts2_unprocessed) & 0x3FFFF
	ts1 := binary.BigEndian.Uint64(ts1_unprocessed) & 0x3FFFF

	//log.Printf("ts3 shifted: %d", uint64(ts3))
	//log.Printf("ts2 shifted: %d", uint64(ts2))

	if ts3 < ts2 {
		ingressLat = uint64(0x3FFFF) - ts2 + ts3 + uint64(1)
	} else {
		ingressLat = ts3 - ts2
	}

	egressLat = ts6 - ts5
	e2eLat = ts6 - ts1

	//log.Printf("Value of ingress latency: %d", uint64(ts2Lat))

	allLatencies := latency{
		ingressLat,
		egressLat,
		e2eLat,
	}
	lq.latEnqueue(allLatencies)
	//handleLatency(ts2Lat)

	atomic.AddUint64(&ops, 1)
	//log.Printf("Packet count: %d", uint64(ops))
}

func GetPathName() string {
	t := time.Now()
	return path.Join(*resultPath, *fileName, *fileName+"_"+t.Format("2006_01_02_15_04_05"))
}

func addToPath(pathName string, additional string) string {
	return path.Join(pathName, additional)
}

func smPrint() {
	mIngLat := map[string]interface{}{}
	smInLat.Range(func(key, value interface{}) bool {
		mIngLat[fmt.Sprint(key)] = value
		return true
	})

	mEgrLat := map[string]interface{}{}
	smEgLat.Range(func(key, value interface{}) bool {
		mEgrLat[fmt.Sprint(key)] = value
		return true
	})

	mE2ELat := map[string]interface{}{}
	smE2ELat.Range(func(key, value interface{}) bool {
		mE2ELat[fmt.Sprint(key)] = value
		return true
	})

	path := GetPathName()

	if _, err := os.Stat(path); os.IsNotExist(err) {
		fmt.Println("Creating directory")
		os.MkdirAll(path, os.ModePerm)
	}

	f1, err := os.Create(addToPath(path, ingressLatencyFile))
	if err != nil {
		fmt.Println(err)
		return
	}

	f2, err := os.Create(addToPath(path, "conv_"+ingressLatencyFile))
	if err != nil {
		fmt.Println(err)
		return
	}

	for key, element := range mIngLat {
		//fmt.Printf("Latency: %s => Counted: %d \n", key, element)
		line := fmt.Sprintf("%s,%d\n", key, element)
		_, err := f1.WriteString(line)
		if err != nil {
			fmt.Println(err)
			f1.Close()
			return
		}

		var timesFound uint64 = element.(uint64)

		sum := 0
		for i := 0; i < int(timesFound); i++ {
			line := fmt.Sprintf("%s\n", key)
			_, err := f2.WriteString(line)
			if err != nil {
				fmt.Println(err)
				f2.Close()
				return
			}
			sum += i
		}
	}

	//fmt.Println(l, "bytes written successfully")
	err = f1.Close()
	if err != nil {
		fmt.Println(err)
		return
	}

	err = f2.Close()
	if err != nil {
		fmt.Println(err)
		return
	}

}
