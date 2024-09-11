// Code your design here
// C = 2A - B
module produto (
  input [1:0] A,
  input [1:0] B,
  output reg [2:0] C);
  
  wire [2:0] D;
  //assign D = 2'd2*A;
  //assign C = D - B;
  
  always @ (*) begin
    D = 2'd2*A;
  	C = D - B;
  end

endmodule
