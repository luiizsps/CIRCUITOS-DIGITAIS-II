// 2¹⁵ = 32768
module contador
    #(parameter SIZE = 4)
    (
    input clk,
    input rst_n,
    output reg [SIZE-1:0] cont,
    output clk_div
    );

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cont <= 0;
        end else begin
          if(count < 10) 
            cont <= cont + 1;
          else
            count <= 0;
        end
    end

    assign clk_div = cont[SIZE-1];

endmodule
