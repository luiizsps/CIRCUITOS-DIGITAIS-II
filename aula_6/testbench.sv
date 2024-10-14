// Code your testbench here
// or browse Examples
module teste;
  
  reg clk, rst_n, e;
  wire s;
  
  detector u0 (.clk(clk), .rst_n(rst_n), .e(e), .s(s));
  
  initial begin
    clk = 0;
    while (1) begin
      #10
      clk = ~clk;
    end
  end
  
  initial begin
    rst_n = 0;
    e = 0;
    repeat (3) @(negedge clk);
    rst_1 = 0;
    repeat (5) @(negedge clk);
    e=1; @(negedge clk);
    e=1; @(negedge clk);
    e=0; @(negedge clk);
    e=1; @(negedge clk);
    e=0; @(negedge clk);
    repeat (5) @(negedge clk);
    $finish();
  end
endmodule
