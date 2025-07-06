# test_fifo.py
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def fifo_randomized_test(dut):
    """ Push a random pattern through FIFO and check it comes out intact. """
    # reset
    dut.rst_n.value = 0
    dut.wr_en.value = 0
    dut.rd_en.value = 0
    await Timer(100, units='ns')
    dut.rst_n.value = 1

    # start clock
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    # reference queue
    ref = []
    max_ops = 100

    for i in range(max_ops):
        await RisingEdge(dut.clk)

        # randomize operations
        wr = random.choice([0,1])
        rd = random.choice([0,1])

        # prevent overflow/underflow
        if len(ref) == 0:
            rd = 0
        if len(ref) >= int(dut.mem.depth if hasattr(dut, 'mem') else 16):
            wr = 0

        dut.wr_en.value = wr
        dut.rd_en.value = rd
        if wr:
            data = random.getrandbits(int(dut.din._n_bits))
            dut.din.value = data
            ref.append(data)

        # read before sampling output
        if rd:
            expected = ref.pop(0)

        await RisingEdge(dut.clk)
        if rd:
            got = dut.dout.value.integer
            assert got == expected, f"FIFO data mismatch: got {got}, expected {expected}"

    # final sanity
    assert dut.empty.value == (len(ref)==0)