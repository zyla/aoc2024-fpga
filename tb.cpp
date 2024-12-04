#include <stdlib.h>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vpuzzle.h"

vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    Vpuzzle dut;

    Verilated::traceEverOn(true);
    VerilatedVcdC trace;
    dut.trace(&trace, 5);
    trace.open("waveform.vcd");

    dut.clk = 0;
    dut.eval();
    trace.dump(sim_time);
    sim_time++;

    dut.rst = 1;
    dut.clk = 1;
    dut.eval();
    trace.dump(sim_time);
    sim_time++;

    dut.clk = 0;
    dut.eval();
    trace.dump(sim_time);
    sim_time++;

    dut.rst = 0;

    char c;

    while ((c = getchar()) != EOF) {
        dut.input_data = c;
        dut.input_valid = 1;
        dut.clk = 1;
        dut.eval();
        trace.dump(sim_time);
        sim_time++;

        if(dut.output_en) {
          printf("Output: '%c' (0x%02x)\n", dut.output_data, dut.output_data);
        }

        dut.clk = 0;
        dut.input_valid = 0;
        dut.eval();
        trace.dump(sim_time);
        sim_time++;
    }

    trace.close();
}
