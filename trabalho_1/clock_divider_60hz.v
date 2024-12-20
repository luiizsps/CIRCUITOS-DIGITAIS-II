// reduz o clock de 25MHz para 60Hz
module clock_divider (
    input wire clk,          // 25 MHz
    input wire rst_n,
    input wire internal_reset,
    output reg clk_div          // clock reduzido a 60 Hz
);
    reg [18:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 19'd0;
            clk_div <= 1'b0;
        end else if (internal_reset) begin
	    counter <= 19'd0;
            clk_div <= 1'b0;
	end else begin
            if (counter >= 19'd416667) begin  
                counter <= 19'd0;
                clk_div <= ~clk_div;   
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

