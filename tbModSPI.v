`timescale 1ns/1ps

module tbModSPI ();
    localparam  N = 8;
    localparam  NumSlaves = 2;

    reg clk, reset, enable;
    reg [N-1:0] data;
    reg [$clog2(NumSlaves)-1:0] slave_sel;
    wire mosi, sclk, busy, done0, done1, miso;
    wire [N-1:0] dataOut0, dataOut1;
    wire [NumSlaves-1:0] cs;

    always #10 clk = ~clk;

    Master #(.N(N), .NumSlaves(NumSlaves), .CPOL(0),.CPHA(0)) dutM(
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

    Slave #(.N(N)) dutS0(
        .mosi(mosi), 
        .sclk(sclk), 
        .cs(cs[1]), 
        .miso(miso), 
        .done(done0),
        .dataOut(dataOut0)
        );

    Slave #(.N(N)) dutS1(
        .mosi(mosi), 
        .sclk(sclk), 
        .cs(cs[0]), 
        .miso(miso), 
        .done(done1),
        .dataOut(dataOut1)
        );

        initial begin
            clk = 0; reset = 1;  enable = 0;

            $monitor("t=%0t reset=%b enable=%b busy=%b cs=%b mosi=%b sclk=%b done0=%b dataOut0=%b done1=%b dataOut1=%b", 
            $time, reset, enable, busy, cs, mosi, sclk, done0, dataOut0, done1, dataOut1);


            #100
            reset = 0; 
            
            slave_sel = 0;
            data = 8'd5;
            enable = 1;
            @(negedge busy);
            enable = 0;
            #20;

            slave_sel = 1;
            data = 8'd10;
            enable = 1;
            @(negedge busy);
            enable = 0;

            $finish;

        end

endmodule