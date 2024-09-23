module soma (
  input wire [2:0] A,
  input wire [2:0] B,
  output wire [5:0] C
);

  assign C = {3'b000, (A + B)};
  
endmodule

module subtracao (
  input wire [2:0] A,
  input wire [2:0] B,
  output reg [5:0] C
);
  always @(*) begin
    if (A < B)
      C = {3'b000, (B - A)};
    else
      C = {3'b000, (A - B)};
  end
endmodule


module produto (
  input wire [2:0] A,
  input wire [2:0] B,
  output wire [5:0] C
);
  
  assign C = A * B;
  
endmodule

module divisao (
 input wire [2:0] A,
 input wire [2:0] B,
  output wire [5:0] C
);
  wire [2:0] result_resto;
  resto resto_u1 (.A(A), .B(B), .C(result_resto));
  assign C = (B != 0) ? {result_resto, (A / B)} : 6'b000000;

endmodule

module resto (
 input wire [2:0] A,
 input wire [2:0] B,
 output wire [2:0] C
);
  
  assign C = A % B;
  
endmodule

module bcd_p_7seg (
  input  wire [3:0] bcd, 
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

module separa_digitos (
  input wire [5:0] result,
  input wire [1:0] sel,
  output reg [3:0] unidade,
  output reg [3:0] dezena
);
  always @(*) begin
    if (sel == 2'b11) begin
      unidade = result[2:0]; // quociente
      dezena = result[5:3];  // resto
    end else begin
      dezena = result / 10;
      unidade = result % 10;
    end
  end
endmodule

module calculadora (
  input wire [2:0] A,
  input wire [2:0] B,
  input wire [1:0] sel,
  output reg [5:0] result
);
  wire [5:0] result_soma, result_sub, result_prod, result_div;
  
  soma soma_u1(.A(A), .B(B), .C(result_soma));
  subtracao sub_u1(.A(A), .B(B), .C(result_sub));
  produto prod_u1(.A(A), .B(B), .C(result_prod));
  divisao div_u1(.A(A), .B(B), .C(result_div));
  
  always @(*) begin
    case (sel)
      2'b00: result = result_soma;
      2'b01: result = result_sub;
      2'b10: result = result_prod;
      2'b11: result = result_div;
      default: result = 6'b000000;
    endcase
  end
endmodule
