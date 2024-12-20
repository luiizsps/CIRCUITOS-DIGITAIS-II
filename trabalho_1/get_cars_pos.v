module get_cars_pos (
    input clk,
    input sVS,
    input rst_n,
    input internal_reset,
    input clk_div,
    input btn_left,
    input btn_right,
    input END,
    input [7:0] PISTA_MIN_X,
    input [9:0] PISTA_MAX_X,
    input [9:0] PISTA_WIDTH,
    input [5:0] CAR_WIDTH,
    input [5:0] CAR_SPEED,
    input [2:0] SPEED,
    input [9:0] SCREEN_HEIGHT,
    output wire [9:0] car_user_x,
    output reg [9:0] car2_x,
    output reg [9:0] car2_y,
    output reg [9:0] car3_x,
    output reg [9:0] car3_y
); 

    // armazena posicao aleatoria gerada para o carro
    wire [7:0] posicao_aleatoria_1, posicao_aleatoria_2;

    gera_posicao_aleatoria pos_u0 (
        .clk(clk),
        .rst_n(rst_n),
			.internal_reset(internal_reset),
        .pos(posicao_aleatoria_1)
    );
	
    gera_posicao_aleatoria pos_u1 (
        .clk(clk),
        .rst_n(rst_n),
		.internal_reset(internal_reset),
        .pos(posicao_aleatoria_2)
    );
	
    update_player_car user_car (
		.clk(clk),
		.clk_div(clk_div),
		.rst_n(rst_n),
		.internal_reset(internal_reset),
		.PISTA_MIN_X(PISTA_MIN_X),
    	.PISTA_MAX_X(PISTA_MAX_X),
    	.CAR_WIDTH(CAR_WIDTH),
		.END(END),
    	.btn_left(btn_left),
    	.btn_right(btn_right),
    	.car1_x_n(car_user_x)
    );

    always @(posedge sVS or negedge rst_n or posedge internal_reset) begin
        if (!rst_n) begin
            // inicializa as posicoes dos carros
            car2_x <= PISTA_MIN_X + 6'd50;
            car2_y <= 0;
            car3_x <= PISTA_MAX_X - 6'd50;
            car3_y <= 0;
	end else if (internal_reset) begin
	    // inicializa as posicoes dos carros
            car2_x <= PISTA_MIN_X + 6'd50;
            car2_y <= 0;
            car3_x <= PISTA_MAX_X - 6'd50;
            car3_y <= 0;
        end else begin
            // move os carros para baixo
            if ((car3_y >= (SCREEN_HEIGHT / 2'd2)) || car2_y > 0)
				car2_y <= car2_y + SPEED;
            car3_y <= car3_y + SPEED;


            // carros retornam ao inicio ao alcancarem o fim da tela
            if (car2_y >= SCREEN_HEIGHT) begin
                car2_y <= 0;
                car2_x <= (PISTA_MIN_X + posicao_aleatoria_1 - CAR_WIDTH); // lado esquerdo
            end
            if (car2_x < PISTA_MIN_X) car2_x <= PISTA_MIN_X + 2'd2;

            if (car3_y >= SCREEN_HEIGHT) begin
                car3_y <= 0;
                car3_x <= (PISTA_MAX_X - posicao_aleatoria_2 + CAR_WIDTH); // lado direito
            end
            if (car3_x > (PISTA_MAX_X - CAR_WIDTH)) car3_x <= (PISTA_MAX_X - CAR_WIDTH - 2'd2);
        end
    end
endmodule

// gera posicao "aleatoria" para o carro dentro do range de metade da pista (128 - 256)
module gera_posicao_aleatoria (
    input wire clk,           
    input wire rst_n,
    input wire internal_reset,   
    output reg [7:0] pos 
);

    reg [7:0] lfsr;          // LFSR de 8 bits

    // Inicializa??o do LFSR com uma semente n?o nula
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)lfsr <= 8'b10110101; // Semente inicial arbitr?ria
	else if (internal_reset) lfsr <= 8'b10110101;
        else lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]}; // LFSR com feedback nos bits 8, 6, 5, e 4 (polin?mio: x^8 + x^6 + x^5 + x^4 + 1)
    end

    // A posi??o recebe o valor atual do LFSR
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pos <= lfsr;
	else if (internal_reset) pos <= lfsr;
        else pos <= lfsr;
    end

endmodule



// atualiza posicao atual do carro do jogador quando um dos botoes (esquerda ou direita) e pressionado
module update_player_car (
    input clk,
    input clk_div,
    input rst_n,
    input internal_reset,
    input [7:0] PISTA_MIN_X,
    input [9:0] PISTA_MAX_X,
    input [5:0] CAR_WIDTH,
    input END,
    input btn_left,
    input btn_right,
    output reg [9:0] car1_x_n 
);
	wire sinal_btn_left, sinal_btn_right;

	// btn esquerda
	debouncer_continuo deb_u0(
		.clk(clk),
		.botao(btn_left),
		.rst_n(rst_n),
		.internal_reset(internal_reset),
		.sinal_btn(sinal_btn_left)
	);
	
	// btn direita
	debouncer_continuo deb_u1(
		.clk(clk),
		.botao(btn_right),
		.rst_n(rst_n),
		.internal_reset(internal_reset),
		.sinal_btn(sinal_btn_right)
	);

always @(posedge clk_div or negedge rst_n) begin
   if (!rst_n) begin
      car1_x_n <= ((PISTA_MIN_X + PISTA_MAX_X) / 2'd2) - (CAR_WIDTH / 2'd2);
   end else if (internal_reset) begin
      car1_x_n <= ((PISTA_MIN_X + PISTA_MAX_X) / 2'd2) - (CAR_WIDTH / 2'd2);
   end else begin
      if (~END) begin
         if (sinal_btn_left && (car1_x_n >= PISTA_MIN_X)) car1_x_n <= car1_x_n - 5;  // Move para a esquerda
         else if (sinal_btn_right && (car1_x_n < (PISTA_MAX_X - CAR_WIDTH))) car1_x_n <= car1_x_n + 5;  // Move para a direita
         else car1_x_n <= car1_x_n;    // Mant�m o valor atual
      end
   end
end

endmodule


