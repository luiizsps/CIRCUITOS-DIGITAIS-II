module fsm;
  
  reg clk, rst_n, enter, keyA, keyB;
  wire clk_div, sinc_enter, ERROR, LED, OPEN;
   	
  divisor_de_clock u0 (.clk(clk), .rst_n(rst_n), .clk_div(clk_div));
  sincronizador_enter_clock u1 (.clk_div(clk_div), .rst_n(rst_n), .enter(enter), .sinc_enter(sinc_enter));
  fsm_moore u2 (.keyA(keyA), .keyB(keyB), .clk_div(clk_div), .rst_n(rst_n), .sinc_enter(sinc_enter), .OPEN(OPEN), .ERROR(ERROR));
  pisca_led u3 (.clk_div(clk_div), .rst_n(rst_n), .ERROR(ERROR), .LED(LED));
  
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, fsm);
    
    rst_n = 0;
    keyA = 0;
    keyB = 0;
    enter = 0;
	repeat(10) @(negedge clk);
    rst_n = 1;
    
    keyA = 1;
    keyB = 0;
    enter = 1;
    repeat(10) @(negedge clk);
    enter = 0;
    repeat(100) @(negedge clk);

    keyA = 0;
    keyB = 1;
    enter = 1;
    repeat(10) @(negedge clk);
    enter = 0;
    repeat(100) @(negedge clk);
	// OPEN = 1
    
    keyA = 1;
    keyB = 1;
    enter = 1;
    repeat(10) @(negedge clk);
    enter = 0;
    repeat(100) @(negedge clk);
    
    keyA = 1;
    keyB = 1;
    enter = 1;
    repeat(10) @(negedge clk);
    enter = 0;
    repeat(100) @(negedge clk);
	// ERROR = 1
    
    enter = 1;
    @(negedge clk);
    enter = 0;
    repeat(100) @(negedge clk);
    
    $finish;
  end
endmodule

