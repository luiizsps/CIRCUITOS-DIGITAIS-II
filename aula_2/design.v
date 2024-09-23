module and_gate (
   input wire A,      
   input wire B,      
   output wire out
);


assign out = A & B;

endmodule


module soma_ou_produto (
	input wire [1:0] A,
	input wire [1:0] B,
	input wire selector,
	output wire [3:0] out,
	output wire [6:0] seg
);

always @ (*) begin
   if(selector == 0) 
		out = A + B;
	else
		out = A * B;
		
	end

endmodule


module bcd_to_7seg (
    input [3:0] bcd, 
    output reg [6:0] seg
);

    always @(*) begin
        case(bcd)
            4'b0000: seg = 7'b1000000;
            4'b0001: seg = 7'b1111001; 
            4'b0010: seg = 7'b0100100; 
            4'b0011: seg = 7'b0110000; 
            4'b0100: seg = 7'b0011001; 
            4'b0101: seg = 7'b0010010; 
            4'b0110: seg = 7'b0000010; 
            4'b0111: seg = 7'b1111000; 
            4'b1000: seg = 7'b0000000; 
            4'b1001: seg = 7'b0010000; 
            default: seg = 7'b1111111;
        endcase
    end

endmodule
