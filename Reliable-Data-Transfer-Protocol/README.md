# Reliable Data Transfer (RDT) Protocol Simulator

## 🎯 Overview
This project implements a transport-layer reliable data transfer protocol over a simulated unreliable network layer. It is designed to handle packet loss, packet corruption, and delayed delivery, mimicking the core functionality of TCP.

## My Contributions
The simulated network environment and packet structures were provided as university boilerplate. My work focused entirely on designing the protocol logic within `Sender.java` and `Receiver.java`:

* **Protocol Design:** Implemented a [Stop-and-Wait OR Go-Back-N] protocol to guarantee in-order, uncorrupted data delivery.
* **Error Detection:** Designed and implemented a custom checksum algorithm combining sequence numbers, acknowledgment numbers, and payload character values to detect bit-level corruption.
* **Timeout & Retransmission:** Managed simulated hardware timer interrupts to handle dropped packets and trigger retransmissions without duplicating data.
* **State Management:** Handled state transitions, sliding windows, and buffer management for outstanding, unacknowledged packets.

## 🚀 How to Run
The protocol is tested via a command-line interface that simulates an unreliable channel. 

Compile the Java files:
`javac *.java`

Run the simulator with the following parameters (Number of messages, Loss Probability, Corruption Probability, Delay, Trace Level, Seed):
`java Testing 20 0.1 0.2 10000 2 256`
