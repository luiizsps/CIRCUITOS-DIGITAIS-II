module tb_contador;

    localparam TAM8 = 2;
    localparam TAM1 = 4;

    reg clk, rst_n;
    wire [TAM8-1:0] cont0;
    wire [TAM1-1:0] cont1;
    wire clk_d8, clk_d32;

    contador #(.SIZE(TAM8)) u0 (
        .clk(clk),
        .rst_n(rst_n),
        .cont(cont0),
        .clk_div(clk_d8)
    );

    contador #(.SIZE(TAM1)) u1 (
        .clk(clk),
        .rst_n(rst_n),
        .cont(cont1),
        .clk_div(clk_d32)
    );

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
        repeat(3) @(negedge clk);
        rst_n = 1;
        repeat(20) @(negedge clk);
      	$finish;
    end

endmodule
