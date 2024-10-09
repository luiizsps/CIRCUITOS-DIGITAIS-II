module tb_contador;
  
  reg clk, rst_n;
  wire [3:0] cont;
  wire clk_div;
  wire [6:0] seg;
   	
  divisor_de_clock u0 (.clk(clk), .rst_n(rst_n), .clk_div(clk_div));
  contador u1 (.clk(clk_div), .rst_n(rst_n), .cont(cont));
  bcd_p_7seg u2 (.bcd(cont), .rst_n(rst_n), .seg(seg));
  
  initial begin
    clk = 0;
    while (1) begin
      #10;
      clk = ~clk;
    end
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    rst_n = 0;
    @(negedge clk);
    rst_n = 1;
    repeat(100000) @(negedge clk);
    $finish;
  end

endmodule

    
      
