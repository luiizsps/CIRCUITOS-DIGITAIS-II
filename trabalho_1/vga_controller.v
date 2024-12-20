module enduro(iRST_n,
                      iVGA_CLK,
							 btn_left,
							 btn_right,
							 start,
							 restart,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data);
input iRST_n;
input iVGA_CLK;
input btn_left;
input btn_right;
input start;
input restart;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
wire rst, blank_n, sHs, sVS, clk_div, show_cars, beginning, end_game, VGA_CLK_n;
reg internal_reset;
reg [18:0] ADDR;
wire [7:0] PISTA_MIN_X;
wire [9:0] PISTA_MAX_X, PISTA_WIDTH, SCREEN_HEIGHT;
wire [10:0] SCREEN_WIDTH;
wire [5:0] CAR_WIDTH, CAR_HEIGHT, CAR_SPEED;
wire [8:0] CAR_USER_Y;
reg [23:0] bgr_data;
wire [23:0] BGR_data;
wire [23:0] BGR_data_out;
wire [9:0] car_user_x, car2_x, car3_x;
wire [9:0] car2_y, car3_y;
wire [2:0] SPEED;


assign PISTA_MIN_X = 8'd128;
assign PISTA_MAX_X = 10'd512;
assign PISTA_WIDTH = PISTA_MAX_X - PISTA_MIN_X;
assign SCREEN_HEIGHT = 10'd480;
assign SCREEN_WIDTH = 11'd640;
assign CAR_WIDTH = 6'd23;
assign CAR_HEIGHT = 6'd36;
assign CAR_SPEED = 6'd1;
assign CAR_USER_Y = SCREEN_HEIGHT - CAR_HEIGHT;
                   
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////Addresss generator
always@(posedge iVGA_CLK, negedge iRST_n)
begin
  if (!iRST_n)
     internal_reset<=0;
  else if (beginning)
     internal_reset<=1;
  else
     internal_reset<=0;
end

always@(posedge iVGA_CLK, negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end

// divide o clock de 25MHz para 60Hz
clock_divider clk_div_u0 (
	.clk(iVGA_CLK),         
	.rst_n(iRST_n),
	.internal_reset(internal_reset),
	.clk_div(clk_div)
);

get_cars_pos cars_pos(
       .clk(iVGA_CLK),
		 .clk_div(clk_div),
       .sVS(cVS),
       .rst_n(iRST_n),
		 .internal_reset(internal_reset),
       .PISTA_MIN_X(PISTA_MIN_X),
       .PISTA_MAX_X(PISTA_MAX_X),
       .PISTA_WIDTH(PISTA_WIDTH),
       .CAR_WIDTH(CAR_WIDTH),
       .CAR_SPEED(CAR_SPEED),
       .SCREEN_HEIGHT(SCREEN_HEIGHT),
		 .SPEED(SPEED),
		 .END(end_game),
		 .btn_left(btn_left),
    	 .btn_right(btn_right),
    	 .car_user_x(car_user_x),
       .car2_x(car2_x),
       .car2_y(car2_y),
       .car3_x(car3_x),
       .car3_y(car3_y)
    );
	 
    game_state gs_u0(
		.clk(iVGA_CLK),
		.rst_n(iRST_n),
		.internal_reset(internal_reset),
		.start(start),
		.restart(restart),
		.BEGINNING(beginning),
		.clk_div(clk_div),
		.CAR_WIDTH(CAR_WIDTH),
		.CAR_HEIGHT(CAR_HEIGHT),
		.car_user_x(car_user_x),
		.car_user_y(CAR_USER_Y),
		.car2_x(car2_x),
		.car2_y(car2_y),
		.car3_x(car3_x),
		.car3_y(car3_y),
		.SHOW_CARS(show_cars),
		.END(end_game),
		.SPEED(SPEED)
    );

    // Atualizada a cor do pixel para exibir carros
    draw_dynamic_cars draw_cars(
			.clk(iVGA_CLK),
        .addr(ADDR),
        .bgr_data_in(bgr_data_raw),
        .bgr_data_out(BGR_data_out),
			.SHOW_CARS(show_cars),
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

//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
//img_data	img_data_inst (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( index )
//	);
////////Color table output
//img_index	img_index_inst (
//	.address ( index ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_raw)
//	);	
//////

mem_saida_seq memu0 (
    //.clk(iVGA_CLK),    
    //.rst_n(1'b1),
    .endereco(ADDR),
	.data_out(bgr_data_raw)
    //.leitura(1'b1)
);

//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= BGR_data_out;
assign b_data = bgr_data[7:0];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[23:16];
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule