`timescale 1ns/1ps
module enduro_game_tb();

    reg clk, rst_n, Hs, Vs, blank, btn_left, btn_right, start, restart;
    wire rst, blank_n, sHs, sVS, clk_div, SHOW_CARS, BEGINNING, END;
    reg [18:0] ADDR;
    reg [7:0] PISTA_MIN_X;
    reg [9:0] PISTA_MAX_X, PISTA_WIDTH, SCREEN_HEIGHT;
    reg [10:0] SCREEN_WIDTH;
    reg [5:0] CAR_WIDTH, CAR_HEIGHT, CAR_SPEED;
    reg [8:0] CAR_USER_Y;
    wire [23:0] BGR_data, BGR_data_out;
    wire [9:0] car_user_x, car2_x, car3_x;
    wire [9:0] car2_y, car3_y;
    wire [2:0] SPEED;

    integer frame_counter = 0;
    integer pixel_file;
    integer pixel_count = 0;

    assign PISTA_MIN_X = 8'd128;
    assign PISTA_MAX_X = 10'd512;
    assign PISTA_WIDTH = PISTA_MAX_X - PISTA_MIN_X;
    assign SCREEN_HEIGHT = 10'd480;
    assign SCREEN_WIDTH = 11'd640;
    assign CAR_WIDTH = 6'd23;
    assign CAR_HEIGHT = 6'd36;
    assign CAR_SPEED = 6'd1;
    assign CAR_USER_Y = SCREEN_HEIGHT - CAR_HEIGHT;

    // Gera clock de 25MHz
    initial clk = 0;
    always #20 clk = ~clk;

	reg internal_reset;
	always @(posedge clk or negedge rst_n) begin
    		if (BEGINNING)
        		internal_reset <= 1'b1;
    		else
        		internal_reset <= 1'b0;
	end

    // movimentaçao do carro do jogador
    initial begin
        rst_n = 0;
        btn_left = 0;
        btn_right = 0;
	start = 0;
	restart = 0;
        #100;
        rst_n = 1;
	#160000000;
	start = 1;
	#100000;
	start = 0;
	btn_right = 1;
	#1600000000;
	btn_right = 0;
	btn_left = 1;
	#1600000000;
	btn_left = 0;
	btn_right = 1;
	#1600000000;
	btn_right = 0;
	btn_left = 1;
	#1600000000;
	btn_left = 0;
	btn_right = 1;
	#1600000000;
	btn_right = 0;
	btn_left = 1;
	#1600000000;
	btn_left = 0;
	btn_right = 1;
	#1600000000;
	btn_right = 0;
	btn_left = 1;
	#1600000000;
	btn_left = 0;
	btn_right = 1;
	#1600000000;
	btn_right = 0;
	btn_left = 1;
	#1600000000;
	btn_left = 0;
	#100000;
	restart = 1;
	#100000;
	restart = 0;
	#100000;
	start = 1;
	#100000;
	start = 0;
	#1600000000;
	btn_right = 1;
	#1600000000;
	btn_right = 0;
	btn_left = 1;
	#1600000000;
	btn_left = 0;
	//$finish;
    end
    // Gera sinais de sincronização para 640x480 a 60Hz
    assign rst = ~rst_n;
    video_sync_generator v_sync (
        .reset(rst),
        .vga_clk(clk),
        .blank_n(blank_n),
        .HS(sHs),
        .VS(sVS)
    );
    // divide o clock de 25MHz para 60Hz
    clock_divider clk_div_u0 (
	.clk(clk),         
	.rst_n(rst_n),
	.internal_reset(internal_reset),
	.clk_div(clk_div)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ADDR <= 19'd0;
            frame_counter <= 0;
            pixel_count <= 0;
        end else if (sHs == 1'b0 && sVS == 1'b0) begin
            ADDR <= 19'd0;
            if (pixel_count > 0) begin
                pixel_count <= 0;
                $fclose(pixel_file);
                $display("Frame %0d concluído", frame_counter);
                frame_counter <= frame_counter + 1;
            end
            if (frame_counter > 3000) begin
                $finish;
            end
        end else if (blank_n == 1'b1) begin
            ADDR <= ADDR + 1;
            if (frame_counter < 3000) begin
                if (pixel_count == 0) begin
                    pixel_file = $fopen($sformatf("frames/frame_%0d.txt", frame_counter), "w");
                    if (!pixel_file) $display("Erro ao abrir frame_%0d.txt", frame_counter);
                    $display("Frame %0d iniciado", frame_counter);
                end

                $fwrite(pixel_file, "%h\n", BGR_data_out);
                pixel_count <= pixel_count + 1;
            end else $finish;
        end
    end
    // Carrega pista como imagem de background
    mem_saida_seq background_mem (
        .endereco(ADDR),
        .data_out(BGR_data)
    );

    // Atualiza posição dos carros
    get_cars_pos cars_pos(
        .clk(clk),
	.clk_div(clk_div),
        .sVS(sVS),
        .rst_n(rst_n),
	.internal_reset(internal_reset),
        .PISTA_MIN_X(PISTA_MIN_X),
        .PISTA_MAX_X(PISTA_MAX_X),
        .PISTA_WIDTH(PISTA_WIDTH),
        .CAR_WIDTH(CAR_WIDTH),
        .CAR_SPEED(CAR_SPEED),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
	.SPEED(SPEED),
	.END(END),
	.btn_left(btn_left),
    	.btn_right(btn_right),
    	.car_user_x(car_user_x),
        .car2_x(car2_x),
        .car2_y(car2_y),
        .car3_x(car3_x),
        .car3_y(car3_y)
    );

    game_state gs_u0(
	.clk(clk),
	.rst_n(rst_n),
	.internal_reset(internal_reset),
	.start(start),
	.restart(restart),
	.clk_div(clk_div),
	.CAR_WIDTH(CAR_WIDTH),
	.CAR_HEIGHT(CAR_HEIGHT),
	.car_user_x(car_user_x),
	.car_user_y(CAR_USER_Y),
	.car2_x(car2_x),
	.car2_y(car2_y),
	.car3_x(car3_x),
	.car3_y(car3_y),
	.BEGINNING(BEGINNING),
	.SHOW_CARS(SHOW_CARS),
	.END(END),
	.SPEED(SPEED)
    );

    // Atualizada a cor do pixel para exibir carros
    draw_dynamic_cars draw_cars(
	.clk(clk),
        .addr(ADDR),
        .bgr_data_in(BGR_data),
        .bgr_data_out(BGR_data_out),
	.SHOW_CARS(SHOW_CARS),
        .CAR_WIDTH(CAR_WIDTH),
        .CAR_HEIGHT(CAR_HEIGHT),    
        .SCREEN_WIDTH(SCREEN_WIDTH),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
	.CAR_USER_Y(CAR_USER_Y),
        .car_user_x(car_user_x),
        .car2_x(car2_x),
        .car2_y(car2_y),
        .car3_x(car3_x),
        .car3_y(car3_y)
    );

    // Atraso para sincronizar sinais
    always @(negedge clk) begin
        Hs <= sHs;
        Vs <= sVS;
        blank <= blank_n;
    end

endmodule

