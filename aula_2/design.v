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


module display(
	input wire [3:0] bcd,
	output reg [6:0] seg
);

always @ (*) begin
	case(bcd)
    // errado
		4'd0: seg = 7'b0000001; // 0
		4'd1: seg = 7'b1001111; // 1
		4'd2: seg = 7'b0010010; // 2
		4'd3: seg = 7'b0000110; // 3
		4'd4: seg = 7'b1001100; // 4
		4'd5: seg = 7'b0100100; // 5
		4'd6: seg = 7'b0100000; // 6
		4'd7: seg = 7'b0001111; // 7
		4'd8: seg = 7'b0000000; // 8
		4'd9: seg = 7'b0000100; // 9
		default: seg = 7'b1111111; // desligado
		  
    endcase
end

endmodule
