// Code your testbench here
// or browse Examples
module fsm;
  
  reg clk, rst_n, enter, keyA, keyB, OPEN;
  wire clk_div, sinc_enter, ERROR, LED;
   	
  divisor_de_clock u0 (.clk(clk), .rst_n(rst_n), .clk_div(clk_div));
  sincronizador_enter_clock u1 (.clk_div(clk_div), .rst_n(rst_n), .enter(enter), .sinc_enter(sinc_enter));
  fsm_moore u2 (.keyA(keyA), .keyB(keyB), .clk_div(clk_div), .rst_n(rst_n), .sinc_enter(sinc_enter), .OPEN(OPEN), .ERROR(ERROR));
  pisca_led u3 (.clk_div(clk_div), .rst_n(rst_n), .ERROR(ERROR), .LED(LED));
  
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
    keyB = 1;
    keyA = 1;
    enter = 1;
    repeat(5) @(negedge clk);
    enter = 0;
    repeat(10000) @(negedge clk);
    keyB = 1;
    keyA = 1;
    enter = 1;
    repeat(5) @(negedge clk);
    enter = 0;
    repeat(20000) @(negedge clk);
    $finish;
  end

endmodule
