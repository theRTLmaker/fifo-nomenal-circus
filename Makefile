# Tell cocotb what language and simulator to use
TOPLEVEL_LANG   = verilog
SIM             = verilator

# Your DUT top-level and your cocotb test module
TOPLEVEL        = fifo
MODULE          = test_fifo

VERILOG_SOURCES = fifo.sv

# Bring in cocotb’s standard Verilator rules
include $(shell cocotb-config --makefiles)/Makefile.sim