// Code your testbench here
// or browse Examples
module tb_ou;
  reg [1:0] x, y;
  wire [2:0] z;
  reg mode;
  
produto produto_u0 (.A(x), 
          .B(y), 
          .C(z));
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  x = 2'b 10;
  y = 2'b 10;
  mode = 0;
  #10;
  $display("z: %d\n", z);
  x = 2'b 10;
  y = 2'b 10;
  mode = 1;
  #10;
  $display("z: %d\n", z);
  
  $finish();
end
  
endmodule
