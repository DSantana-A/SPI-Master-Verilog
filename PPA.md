# SPI Master — Synthesis Report

**Design:** SPI Master Controller
**Language:** Verilog RTL
**Synthesis Tool:** Synopsys Design Compiler X-2025.06-SP1
**Technology:** SAED 32nm (HVT standard cells)
**Operating Conditions:** 0.75 V, 125 °C (ss corner — worst case)
**Clock Target:** 50 MHz (20 ns period)

---

## 1. Area

| Metric | Value |
|--------|-------|
| Total cell area | 225.17 µm² |
| Combinational area | 112.08 µm² |
| Noncombinational area | 113.09 µm² |
| Total cells | 70 |
| Combinational cells | 52 |
| Sequential cells (flip-flops) | 17 |
| Buffers / inverters | 9 |
| Number of nets | 89 |
| Number of ports | 18 |

The 17 sequential cells correspond to the FSM state register, the data shift
register, and the bit counter.

---

## 2. Performance (Timing)

| Metric | Value |
|--------|-------|
| Clock period (target) | 20.00 ns (50 MHz) |
| Data arrival time | 8.76 ns |
| Data required time | 18.44 ns |
| Library setup time | 1.56 ns |
| **Slack** | **+9.68 ns (MET)** |
| Estimated max frequency | ~108 MHz |

**Critical path:** runs from the FSM state register (`state_reg[0]`) through the
control logic (NAND/INV/AND-OR cells) to the bit counter (`counter_reg[2]`). The
large positive slack indicates the design is well within timing at 50 MHz.

---

## 3. Power (0.75 V, 125 °C)

| Power Group | Total | Share |
|-------------|-------|-------|
| Clock network | 2.50 µW | 59.7% |
| Registers | 1.24 µW | 29.6% |
| Combinational | 0.45 µW | 10.7% |

| Summary | Value |
|---------|-------|
| Cell internal power | 2.69 µW (95%) |
| Net switching power | 147.6 nW (5%) |
| **Total dynamic power** | **2.84 µW** |
| **Cell leakage power** | **1.35 µW** |
| **Total power** | **4.19 µW** |

**Observation:** As with most sequential designs, the clock network is the
largest power contributor (59.7%), making clock gating the primary candidate for
power optimization.

---
