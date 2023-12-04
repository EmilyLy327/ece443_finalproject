ECE 443 Final Project Fall 2023
Authors: Emily Ly & Brice Zimmerman

This is an implementation of a single cycle processor. It will support the following:
- 7 different instructions
- 2 instruction formats (R-Type and I-Type)
- 256 half words of RAM (256 addresses by 16 bits)
- 8 registers

The project consists of the following components and files:
The Components folder contains all of the individual components, including the instruction memory, instruction fetch, instruction decode/execute, register file, ALU, and data memory.
The Simple Processor contains all of the individual components working together to make up the processor.
The Simple_Processor2 is our attempt at separating the instruction decode and execute into different processes.