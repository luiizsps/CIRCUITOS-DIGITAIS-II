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
  
  always @(posedge clk_div or negedge rst_n) begin
    if (!rst_n)
      begin
    	sinc_enter <= 0;
		registrador_1 <= 0;
    	registrador_2 <= 0;
      end
    else
      begin
		registrador_1 <= enter;
    	registrador_2 <= registrador_1;
    	sinc_enter <= registrador_1 & ~registrador_2;
      end
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
  parameter S0 = 3'b000,
  			S1 = 3'b001,
  			S2 = 3'b010,
  			E1 = 3'b011,
  			E2 = 3'b100;
  			
  reg [2:0] current_state, next_state;
  
  always @ (posedge clk_div or negedge rst_n)
	begin: state_memory
   if (!rst_n)
      current_state <= S0;
   else
      current_state <= next_state;
    end
  
  always @ (*)
	begin
     case (current_state)
        S0:
          if (sinc_enter == 1'b1) begin
            if(keyA == 1 && keyB == 0)
              next_state = S1;
            else
              next_state = E1;
          end
          else next_state = S0;
        S1:
          if (sinc_enter == 1'b1) begin
            if(keyA == 0 && keyB == 1)
              next_state = S2;
            else
              next_state = E2;
          end
          else next_state = S1;
        E1:
          if (sinc_enter == 1'b1)
            next_state = E2;
          else 
            next_state = E1;
       	E2:
          if (sinc_enter == 1'b1)
            next_state = S0;
          else
            next_state = E2;   
        default: next_state = S0;
     endcase   
	end
  
  always @(*) begin
    OPEN = 1'b0;
    ERROR = 1'b0;
    case (current_state)
      S2: OPEN = 1'b1;
      E2: ERROR = 1'b1;
      default: begin
        OPEN = 1'b0;
        ERROR = 1'b0;
      end
    endcase
  end
endmodule
