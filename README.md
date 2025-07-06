# FIFO-nomenal: Cocotb & Verilator Circus

A no‑fluff demo repo combining a minimal Verilog FIFO and a cocotb testbench, using Verilator on macOS M2 Pro. Copy, tweak, run.

## Prerequisites

* **macOS M1/M2** (tested on M2 Pro)
* **Homebrew**
* **Verilator** (v5.x)
* **Python 3.11+** (Homebrew)
* **cocotb 1.9+**
* **GNU make**

## Setup

```bash
# 1. Install dependencies (if you haven't already)
brew install verilator python@3.11
pip3 install --upgrade pip setuptools wheel
pip3 install cocotb

# 2. Clone this repo
git clone https://github.com/<your-username>/fifo-nomenal-circus.git
cd fifo-cocotb-verilator-demo
```

## Repo Layout

```
├── fifo.v            # Simple parametrizable FIFO RTL
├── test_fifo.py      # cocotb testbench skeleton (randomized push/pop)
├── Makefile          # Builds with Verilator + cocotb harness
└── README.md         # (you’re reading it)
```

## Running the Test

```bash
make
```

* **Verilator** compiles `fifo.v` into a shared library
* **cocotb** drives the simulation
* Look for `ASSERTION` failures or data mismatches in the console/log

## Customize

* Edit `fifo.v`: adjust `WIDTH` or `DEPTH`, add flags (almost‑full, show‑ahead, etc.)
* Extend `test_fifo.py`: add targeted tests (reset behavior, corner cases)
* Tweak clock period or reset timing in the Python test

## License

MIT
