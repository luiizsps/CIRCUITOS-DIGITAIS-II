// 2¹⁵ = 32768
module divisor_de_clock (
    input clk,
    input rst_n,
    output clk_div
);
  	reg [14:0] cont;
  
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)
            cont <= 0;
        else 
            cont <= cont + 1;
    end

  assign clk_div = cont[14];

endmodule


module contador (
  input clk,
  input rst_n,
  output reg [3:0] cont
);
  
  always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)
            cont <= 4'd0;
        else begin
          if(cont < 4'd10)
            cont <= cont + 4'd1;
          else
            cont <= 4'd0;
        end
    end
  
endmodule

module bcd_p_7seg (
  input  wire [3:0] bcd,
  input rst_n,
  output reg [6:0] seg
);
  always @ (*) begin
      if (!rst_n)
        seg = 7'b1111111;
      else begin
        case(bcd)
          4'b0000: seg = 7'b1000000;
          4'b0001: seg = 7'b1111001; 
          4'b0010: seg = 7'b0100100; 
          4'b0011: seg = 7'b0110000; 
          4'b0100: seg = 7'b0011001; 
          4'b0101: seg = 7'b0010010; 
          4'b0110: seg = 7'b0000010; 
          4'b0111: seg = 7'b1111000; 
          4'b1000: seg = 7'b0000000; 
          4'b1001: seg = 7'b0010000; 
          default: seg = 7'b1111111;
        endcase
      end
    end

endmodule
