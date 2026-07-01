# SPI Master in Verilog

SPI (Serial Peripheral Interface) Master controller implemented in Verilog using a finite state machine. Supports full-duplex communication with configurable data width, number of slaves, and clock polarity/phase (CPOL/CPHA).

## Project Structure

```
SPI/
├── MSPI.v         - Master module
├── SSPI.v         - Slave module
└── tbModSPI.v     - Integration testbench (Master + Slave)
```

## Configuration

The Master module is parameterizable:

| Parameter | Default | Description |
|-----------|---------|-------------|
| N         | 8       | Data width in bits |
| NumSlaves | 1       | Number of slave devices |
| CPOL      | 0       | Clock polarity (idle clock level) |
| CPHA      | 0       | Clock phase (sampling edge) |

## Module — Master (`MSPI.v`)

Serializes a data word and transmits it over MOSI while simultaneously receiving on MISO (full-duplex).

**Ports**

| Port      | Direction | Width            | Description |
|-----------|-----------|------------------|-------------|
| clk       | input  | 1 | System clock |
| reset     | input  | 1 | Synchronous reset (active high) |
| enable    | input  | 1 | Starts a transfer |
| data      | input  | N | Data word to transmit |
| slave_sel | input  | log2(NumSlaves) | Selects target slave |
| miso      | input  | 1 | Master In, Slave Out |
| mosi      | output | 1 | Master Out, Slave In |
| sclk      | output | 1 | Serial clock |
| cs        | output | NumSlaves | Chip select (active low per slave) |
| busy      | output | 1 | High during transfer |

**State Machine**

```
IDLE → START → TRANSFER → DONE → IDLE
```

- `IDLE`: Waits for `enable = 1`
- `START`: Asserts chip select and loads the shift register
- `TRANSFER`: Toggles SCLK, shifts data out on MOSI and in on MISO for N bits
- `DONE`: Deasserts chip select and returns to IDLE

## Simulation

### Run with Icarus Verilog

```bash
iverilog -o sim MSPI.v SSPI.v tbModSPI.v
./sim
```

### Run with Synopsys VCS

```bash
vcs -full64 MSPI.v SSPI.v tbModSPI.v -o simv
./simv
```

The testbench verifies full-duplex data transfer between the Master and Slave.

## Logic Synthesis with Synopsys Design Compiler

The Master was synthesized using **Synopsys Design Compiler (X-2025.06-SP1)** targeting the **SAED 32nm** standard cell library (HVT, 0.75 V, 125 °C) at a 50 MHz clock target.

### Area

| Metric | Value |
|--------|-------|
| Total cell area | 225.17 µm² |
| Total cells | 70 |
| Combinational cells | 52 |
| Sequential cells | 17 |
| Nets | 89 |

### Timing

| Metric | Value |
|--------|-------|
| Clock target | 50 MHz (20 ns period) |
| Data arrival time | 8.76 ns |
| **Slack** | **+9.68 ns (MET)** |
| Estimated max frequency | ~108 MHz |

### Power (0.75 V, 125 °C)

| Component | Power | Share |
|-----------|-------|-------|
| Clock network | 2.50 µW | 59.7% |
| Registers | 1.24 µW | 29.6% |
| Combinational | 0.45 µW | 10.7% |
| **Total dynamic** | **2.84 µW** | — |
| **Cell leakage** | **1.35 µW** | — |
| **Total** | **4.19 µW** | — |

## SPI Protocol

```
     ┌──────────────────────────────┐
CS   ┘                              └────
        ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐
SCLK ───┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └──
MOSI ──< b7 X b6 X b5 X b4 X b3 X b2 X b1 X b0 >──
MISO ──< b7 X b6 X b5 X b4 X b3 X b2 X b1 X b0 >──
```

Data is shifted MSB first, one bit per SCLK edge, in both directions simultaneously (full-duplex).