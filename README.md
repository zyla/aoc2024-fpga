# `aoc2024-fpga`

Solving [Advent of Code 2024](https://adventofcode.com/2024) tasks in Verilog on an FPGA.

## Why?

Because fun!

## Architecture

The task communicates with the host computer via USB-UART, as if it was stdin/stdout.

The actual task is in [`rtl/puzzle.sv`](./rtl/puzzle.sv), which has a byte-oriented interface:

```systemverilog
module puzzle
(
    input clk,
    input rst,

    input wire       input_valid,  // Valid data recieved and available.
    input wire  [7:0] input_data,   // The recieved data.

    input  wire       output_busy,  // Module busy sending previous item.
    output logic       output_en,    // Send the data on output_data
    output logic [7:0] output_data   // The data to be sent
);
```

The toplevel module connects it to an UART module to communicate with the host.

## Running it

First, synthesize and write the bistream to your favourite FPGA board.

An example Vivado project is provided for [Digilent Cmod S7](https://digilent.com/reference/programmable-logic/cmod-s7/start) (Spartan-7 FPGA),
in [vivado-cmod-s7](./vivado-cmod-s7). It imports the RTLs and defines constraints specific to the board.

You need to connect an USB-UART to the board. The S7 has a built-in converter. If your board doesn't have it, you can use an external one.

Once the circuit is running, you can communicate with it by reading/writing to/from the UART.

First setup the baudrate:

```sh
stty -F /dev/ttyUSB1 115200 -cstopb
```

In one terminal you can see the output:

```sh
cat /dev/ttyUSB1
```

In another you can write to it:

```sh
echo -ne "123\n456\n" > /dev/ttyUSB1
```

## Current state of the puzzles

We haven't implemented any of the actual puzzles yet.

But: the UART communication is working, and there's an example program in `puzzle.v` that
reads two (decimal) integers separated by newlines, multiplies them, and outputs the result (also in decimal).

## Plans

These puzzles seem sensible to do on an FPGA:

- [Day 3 - Mull It Over](https://adventofcode.com/2024/day/3) - easy, can be done in a streaming way (so no RAM blocks)
- [Day 17: Chronospatial Computer](https://adventofcode.com/2024/day/17) - seems like a simple interpreter
- [Day 24: Crossed Wires](https://adventofcode.com/2024/day/24) - also seems like a simple evaluator
- maybe others? I haven't read them all...
