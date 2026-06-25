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
                    if(enable==1) begin
                        state <= START;
                        busy <= 1;
                    end else begin
                        busy <= 0;
                        cs <= 0;
                    end
                end 
                START: begin
                    cs <=1;
                    shift_reg <= data;
                    state <= TRANSFER;
                end 
                TRANSFER: begin
                    sclk <= ~sclk;
                    if (!sclk) begin
                        mosi <= shift_reg[N-1];
                        shift_reg <= {shift_reg[N-2:0], 1'b0};
                    end else begin
                        counter <= counter +1;
                        if (counter == N-1) begin
                            state <= DONE;
                        end
                    end
                end
                DONE: begin
                    cs <= 0;
                    busy <= 0;
                    counter <= 0;
                    sclk <= 0;
                    state <= IDLE;
                end
                default: 
            endcase

    end

end
    
endmodule