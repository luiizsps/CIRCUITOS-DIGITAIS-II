module inv_flipflop(
  input rst_n,
  input clk,
  input S,
  input A,
  input B,
  output reg q
);
  
  wire d, out_xor, out_and;
  reg out_mux;
  
  assign out_xor = A^q;
  assign out_and = A&B;
  
  always @(*) 
    begin
    if(S)
      out_mux = out_and;
    else
      out_mux = out_xor;
  	end
  
  always @(posedge clk or negedge rst_n)
    begin
      if(!rst_n)
        q <= 1'b0;
      else
        q <= out_mux;
    end
endmodule
