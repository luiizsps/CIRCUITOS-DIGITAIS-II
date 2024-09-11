// Code your design here
// Se mode 0, C = 2A - B
// Senão, C = 2A + B
module produto (
  input [1:0] A,
  input [1:0] B,
  input mode,
  output reg [2:0] C); // reg é utilizado junto ao always
  
  wire [2:0] D; // wire é utilizado junto ao assign
  assign D = 2'd2*A;
  //assign C = D - B;
  
  always @ (*) begin // always simula um multiplexador, aqui a ordem do código importa
    if(mode ==0)
      C = D - B;
    else
      C = D + B;
  	
  end

endmodule
