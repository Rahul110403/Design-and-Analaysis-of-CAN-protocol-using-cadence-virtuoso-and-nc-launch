# CAN Protocol Transceiver Design – Major Project

This project implements a Controller Area Network (CAN) transmitter and receiver supporting reliable, multi-node automotive communication. The design covers the CAN physical and data-link layers, including differential signaling, arbitration, bit timing, frame formatting, and error handling.

## 🔧 Tools & Technologies Used

- Cadence Virtuoso – Schematic design, analog front-end, differential driver/receiver
- NC Launch / Cadence Incisive – Mixed-signal simulation, functional verification
- Spectre Simulator – Analog performance & signal integrity analysis
- Verilog / AMS – Digital logic for CAN framing, bit-stuffing, CRC, ACK checks
- CAN 2.0A/B Protocol Standards

## 🧩 Project Overview

The system consists of:

### CAN Transmitter

- Bit timing generator
- Arbitration and dominant/recessive signaling
- Frame formatting (SOF, ID, DLC, Data, CRC, ACK, EOF)
- Error flag generation

### CAN Receiver

- Sampling point logic
- Edge detection and bit decoding
- Stuff-bit removal
- CRC and error detection
- Acknowledgment handling

## 🚦 Methodology

- Designed differential CAN_H & CAN_L drivers in Virtuoso
- Implemented digital controller in Verilog
- Integrated analog & digital blocks for mixed-signal verification
- Performed timing, noise, and arbitration simulations in NC Launch
- Validated protocol behavior through waveform analysis
- Optimized bit timing and verified error frames

## 📈 Key Features

- Fully functional CAN TX & RX architecture
- Differential signaling with dominant/recessive states
- Realistic physical-layer behavior using analog simulations
- Complete protocol support: arbitration, bit-stuffing, CRC, ACK, error frames
- Mixed-signal co-simulation
- Automotive-grade communication reliability

## 📂 Repository Structure

```text
/schematics        -> Cadence Virtuoso design files
/simulations       -> NC Launch waveforms & testbenches
/verilog           -> Digital logic blocks
/docs              -> Block diagrams and timing charts
/results           -> Simulation outputs & analysis

> Designed a CAN protocol transmitter and receiver for reliable automotive communication using Cadence Virtuoso and NC Launch. Implemented differential signaling, bit timing, framing, and error handling. Performed mixed-signal simulations to validate signal integrity and protocol accuracy.
