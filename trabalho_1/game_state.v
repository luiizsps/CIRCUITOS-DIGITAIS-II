module game_state (
  input clk,
  input rst_n,
  input internal_reset,
  input start,
  input restart,
  input wire clk_div,
  input wire [5:0] CAR_WIDTH,
  input wire [5:0] CAR_HEIGHT,
  input wire [9:0] car_user_x,
  input wire [8:0] car_user_y,
  input wire [9:0] car2_x,
  input wire [9:0] car2_y,
  input wire [9:0] car3_x,
  input wire [9:0] car3_y,
  output wire SHOW_CARS,
  output wire BEGINNING,
  output wire END,
  output wire [2:0] SPEED
);
	wire next, sinc_next, sinc_start, sinc_restart, collision;

	// gera pulso sincronizado para btn start
	debouncer_pulso deb_u2(
		.clk(clk),
		.rst_n(rst_n),
		.botao(start),
		.sinc_botao(sinc_start)
	);

	// gera pulso sincronizado para btn restart
	debouncer_pulso deb_u3(
		.clk(clk),
		.rst_n(rst_n),
		.botao(restart),
		.sinc_botao(sinc_restart)
	);

	// contador para mudan?a de estado
	counter_next_state cnt_u0(
		.clk_div(clk_div),       
		.rst_n(rst_n),
		.internal_reset(internal_reset),
		.next(next)      
	);

	// gera pulso sincronizado para sinal next
	debouncer_pulso deb_u4(
		.clk(clk),
		.rst_n(rst_n),
		.botao(next),
		.sinc_botao(sinc_next)
	);

	// verifica se houve colisao
	collision_checker cc_u0(
    		.clk(clk),
		.rst_n(rst_n),
		.internal_reset(internal_reset),
		.CAR_WIDTH(CAR_WIDTH),
		.CAR_HEIGHT(CAR_HEIGHT),
		.car_user_x(car_user_x),
		.car_user_y(car_user_y),
		.car2_x(car2_x),
		.car2_y(car2_y),
		.car3_x(car3_x),
		.car3_y(car3_y),
		.collision_detected(collision)
	);

	// maquina de estados para controlar fases do jogo
	fsm_moore fsm_u0 (
		.clk(clk),
		.rst_n(rst_n),
		.start(sinc_start),
		.restart(sinc_restart),
		.sinc_next(sinc_next),
		.collision(collision),
		.SHOW_CARS(SHOW_CARS),
		.BEGINNING(BEGINNING),
		.END(END),
		.SPEED(SPEED)
	);

endmodule

// maquina de estados que define a velocidade e exbicao dos carros no jogo
module fsm_moore (
  input clk,
  input rst_n,
  input start,
  input restart,
  input wire sinc_next,
  input collision,
  output reg SHOW_CARS,
  output reg BEGINNING,
  output reg END,
  output reg [2:0] SPEED
);
  parameter S0 = 3'b000,
  	    S1 = 3'b001,
  	    S2 = 3'b010,
  	    S3 = 3'b011,
  	    S4 = 3'b100,
	    E0 = 3'b101;
  			
  reg [2:0] current_state, next_state;
  
  always @ (posedge clk or negedge rst_n)
	begin: state_memory
   if (!rst_n)
      current_state <= S0;
   else
      current_state <= next_state;
    end
  
  always @ (*) begin
     case (current_state)
        S0:
          if (start == 1'b1) next_state = S1;
	  else next_state <= S0;
        S1:
	  if (collision) next_state = E0;
          else if (sinc_next == 1'b1) next_state = S2;
	  else next_state <= S1;
        S2:
          if (collision) next_state = E0;
          else if (sinc_next == 1'b1) next_state = S3;
	  else next_state <= S2;
       	S3:
          if (collision) next_state = E0;
          else if (sinc_next == 1'b1) next_state = S4;
	  else next_state <= S3;
	S4:
	  if (collision) next_state = E0;
	  else next_state = S4;
	E0:
	  if (restart) next_state = S0;
	  else next_state = E0;
        default: next_state = S0;
     endcase 
	end
  
  always @(*) begin
    SHOW_CARS = 1'b0;
    SPEED = 3'd0;
    BEGINNING = 1'b0;
    END = 1'b0;
    case (current_state)
      S0: begin
	BEGINNING = 1'b1;
	end
      S1: begin
	SHOW_CARS = 1'b1;
	SPEED = 3'd1;
	end
      S2: begin
	SHOW_CARS = 1'b1;
	SPEED = 3'd2;
	end
      S3: begin
	SHOW_CARS = 1'b1;
	SPEED = 3'd3;
	end
      S4: begin
	SHOW_CARS = 1'b1;
	SPEED = 3'd4;
	end
      E0: begin
	SHOW_CARS = 1'b1;
	SPEED = 3'd0;
	END = 1'b1;
	end
      default: begin
        SHOW_CARS = 1'b0;
    	SPEED = 3'd0;
      end
    endcase
  end
endmodule

// contagem de segundos para mudan?a de stage
module counter_next_state (
    input wire clk_div,       
    input wire rst_n,
    input wire internal_reset,
    output reg next      
);
	reg [8:0] counter;

	always @(posedge clk_div or negedge rst_n) begin
            if (!rst_n) begin
                counter <= 9'd0;
                next <= 1'b0;
	    end else if (internal_reset) begin
    		counter <= 9'd0;
                next <= 1'b0;
            end else begin
            if (counter >= 9'd300) begin  // 5 segundos
                counter <= 9'd0;
                next <= 1'b1;   
            end else begin
                counter <= counter + 9'd1;
						next <= 1'b0;
            end
        end
    end
endmodule

