# Krazy Karaoke

**Krazy Karaoke** is a hardware-accelerated audio scoring system, inspired by rhythm games like *Rock Band*. It was developed as a final project for EC551 (Advanced Digital Design with Verilog and FPGAs) at Boston University, with the goal of exploring digital signal processing and FPGA-based system design.

## Overview

The system captures sung audio, extracts pitch using an FFT, and scores the performance against a reference melody in near real-time. Key goals were to demonstrate:

- Audio signal acquisition using ADC  
- Real-time frequency extraction via a radix-2 DIT FFT  
- A scoring algorithm that compares pitch accuracy between a reference and sung track  
- Visual feedback using a VGA display  

## Features

- **ADC Audio Input**: Microphone input is preprocessed and digitized for analysis.  
- **FFT Module**: Custom frequency analysis pipeline identifies dominant frequencies in real time.  
- **Scoring Logic**: State-machine-based scoring system compares sung notes to reference input using octave binning and tolerance windows.  
- **Display Output**: VGA output shows score and performance feedback. A Python script was written to help generate the VGA character ROM.  

## Tools and Technologies

- **Platform**: Digilent Nexys A7 FPGA board  
- **Language**: Verilog HDL  
- **Signal Processing**: Fixed-point FFT and frequency bin mapping  
- **Display**: VGA character grid display rendered using synthesized ROM  
- **Other Tools**: Python script to generate Verilog ROM blocks  

## Status and Limitations

Time constraints prevented full integration of all modules into a polished game loop. However, major components—ADC capture, frequency extraction, scoring logic, and VGA output—were implemented and tested.

## Role and Contributions

I designed and implemented the system architecture, ADC interface, scoring algorithm, VGA controller, and supporting Verilog modules. I also wrote the Python tool to assist with display rendering.  

**Joseph Biernacki** contributed to early FFT prototyping using MATLAB, hardware integration, and troubleshooting microphone/speaker interfacing.
