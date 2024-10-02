module test;
  reg clk, rst_n, A, B, S;
  wire q;
 		
  
  initial begin
    clk = 0;
    while (1) begin
      #10;
      clk = ~clk;
    end
  end
  
  inv_flipflop u0(.rst_n(rst_n), .clk(clk), .S(S), .A(A), .B(B), .q(q));
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    rst_n = 0;
    A = 0; B = 0; S = 0;
    repeat(3) @(negedge clk);
    
    rst_n = 1;
    A = 1; B = 0; S = 1;
    @(negedge clk);
    
    A = 1; B = 1; S = 0;
    @(negedge clk);
    #50;
    
    $finish();
    end
endmodule
  
  
  

