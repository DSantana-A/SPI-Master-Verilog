module MSPI #(parameter N =8)(
    input miso, clk, reset, enable,
    input [N-1:0] data,
    output reg mosi, sclk, cs, busy
);
    localparam  IDLE =  2'b00;
    localparam START = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam DONE = 2'b11;

reg [1:0] state;
reg [N-1:0] shift_reg;
reg [$clog2(N)-1:0] counter;

always @(posedge clk ) begin
    if (reset) begin
        sclk <=0;
        mosi <=0;
        busy<=0;
        cs<=0;
        shift_reg <= 0;
        counter <= 0;
        state <= IDLE;
    end else begin
            case (state)
                IDLE: begin
                    
                end 
                START: begin
                    
                end 
                TRANSFER: begin
                    
                end
                DONE: begin
                    
                end
                default: 
            endcase

    end

end
    
endmodule