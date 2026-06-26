`timescale 1ns/1ps

module tbMSPI ();
    localparam  N = 8;
    localparam  NumSlaves = 2;

    reg miso, clk, reset, enable;
    reg [N-1:0] data;
    reg [$clog2(NumSlaves)-1:0] slave_sel;
    wire mosi, sclk, busy;
    wire [NumSlaves-1:0] cs;



    always #10 clk = ~clk;

    MSPI #(.N(N), .NumSlaves(NumSlaves), .CPOL(0),.CPHA(0)) dut(
        .miso(miso),
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .data(data),
        .slave_sel(slave_sel),
        .mosi(mosi),
        .sclk(sclk),
        .busy(busy),
        .cs(cs)
    );

    initial begin
        clk = 0; reset = 1; enable = 0;

        $monitor("t=%0t reset=%b enable=%b busy=%b cs=%b mosi=%b sclk=%b", 
          $time, reset, enable, busy, cs, mosi, sclk);

        #100
        reset = 0; enable = 1;
        data =   8'd5;
        slave_sel = 1;

        @(negedge busy);
        enable = 0;
        $finish;
    end
endmodule