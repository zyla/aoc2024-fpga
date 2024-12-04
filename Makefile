# Based on Verilator example makefile (https://github.com/n-kremeris/verilator_basics, see LICENSE.verilator_basics)
MODULE=puzzle

.PHONY:sim
sim: waveform.vcd

.PHONY:verilate
verilate: .stamp.verilate

.PHONY:build
build: obj_dir/V$(MODULE)

.PHONY:waves
waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd -a gtkwave_setup.gtkw

waveform.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	./obj_dir/V$(MODULE) +verilator+rand+reset+2 

./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -j -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: $(MODULE).v tb.cpp
	@echo
	@echo "### VERILATING ###"
	verilator -Wall --trace --x-assign unique --x-initial unique -cc $(MODULE).v --exe tb.cpp
	@touch .stamp.verilate

.PHONY:lint
lint: $(MODULE).v
	verilator --lint-only $(MODULE).v

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd
