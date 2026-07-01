`timescale 1ns/1ps

module Slave #(parameter N =  8) (
    input mosi, sclk, cs,
    output reg miso, done,
    output reg [N-1:0] dataOut
);
    
    reg [N-1:0] shift_reg;
    reg [$clog2(N)-1:0] counter;

    initial begin
    done = 0;
    counter = 0;
    dataOut = 0;
    shift_reg = 0;
    end

    always @(posedge sclk ) begin
         if (cs == 1) begin
            shift_reg <= {shift_reg[N-2:0],mosi};
            counter <= counter + 1;
            if (counter == N-1) begin
                dataOut <= {shift_reg[N-2:0],mosi};
                done <= 1;
            end
        end
        
    end
endmodule