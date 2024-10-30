// 2¹¹ = 2048
// 32768Hz / 2048 = 16Hz
module divisor_de_clock (
    input clk,
    input rst_n,
    output wire clk_div
);
  	reg [10:0] cont;
  
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)
            cont <= 0;
        else 
            cont <= cont + 1;
    end

  assign clk_div = cont[10];

endmodule

module sincronizador_enter_clock (
  input clk_div,
  input enter,
  input rst_n,
  output reg sinc_enter
);
  reg registrador_1, registrador_2;
  
  always @(posedge enter or negedge rst_n) begin
    if (!rst_n)
      registrador_1 <= 0;
    else
      registrador_1 <= 1;
  end
  
  always @(posedge clk_div or negedge rst_n) begin
    if (!rst_n)
      begin
    	sinc_enter <= 0;
    	registrador_2 <= 0;
      end
    else
      begin
    	registrador_2 <= registrador_1;
    	sinc_enter <= registrador_1 && !registrador_2;
      end
    
    if(sinc_enter)
      registrador_1 <= 0;
    
  end
  
endmodule

module pisca_led (
  input ERROR,
  input clk_div,
  input rst_n,
  output reg LED
);
 
  always @(posedge clk_div or negedge rst_n) begin
    if(!rst_n) begin
    	LED <= 0;
    	end
    else if(ERROR)
      LED <= ~LED;
    else
      LED <= 0;
  end
endmodule

// combinação: 0110
module fsm_moore (
  input keyA,
  input keyB,
  input clk_div,
  input sinc_enter,
  input rst_n,
  output reg OPEN,
  output reg ERROR
);
  reg S0, S1, E1;
  
  always @(posedge clk_div or negedge rst_n) begin
    if (!rst_n) begin
      S0 <= 1;
      S1 <= 0;
      E1 <= 0;
      OPEN <= 0;
      ERROR <= 0;
    end
    else if (sinc_enter) begin
      if (S0) begin
        S0 <= 0;
        if (keyB == 0 && keyA == 1)
          S1 <= 1;
        else
          E1 <= 1;
      end
      else if (S1) begin
        S1 <= 0;
        if (keyB == 1 && keyA == 0)
          OPEN <= 1;
        else
          ERROR <= 1;
      end
      else if (E1) begin
        E1 <= 0;
        ERROR <= 1;
      end
      else if (ERROR) begin
        ERROR <= 0;
        S0 <= 1;
      end
    end
    
    if (OPEN) begin
      OPEN <= 0;
      S0 <= 1;
    end
  end
endmodule
    	
