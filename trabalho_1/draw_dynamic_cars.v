module draw_dynamic_cars(
input clk,
    input [18:0] addr,         
    input [23:0] bgr_data_in,
    input [5:0] CAR_WIDTH,
    input [5:0] CAR_HEIGHT,
    input [10:0] SCREEN_WIDTH,
    input [9:0] SCREEN_HEIGHT,
    input [9:0] car_user_x,
    input [8:0] CAR_USER_Y,            
    input [9:0] car2_x,               
    input [9:0] car2_y,               
    input [9:0] car3_x,               
    input [9:0] car3_y,
    input SHOW_CARS,
    output reg [23:0] bgr_data_out           
);

    // Coordenadas atuais baseadas no endere?o
    wire [9:0] pixel_x = addr % SCREEN_WIDTH;
    wire [8:0] pixel_y = addr / SCREEN_WIDTH;

    always @(posedge clk) begin
		if (SHOW_CARS) begin
        	// Desenha o carro do usuario (azul)
        	if (pixel_x >= car_user_x && pixel_x < car_user_x + CAR_WIDTH &&
            	    pixel_y >= CAR_USER_Y && pixel_y < CAR_USER_Y + CAR_HEIGHT) begin
			
			// desenha farois (branco)
			if (pixel_y <= (CAR_USER_Y + 1) && ((pixel_x <= (car_user_x + 4) &&
			    pixel_x >= (car_user_x + 3)) || (pixel_x <= (car_user_x + 19) && pixel_x >= (car_user_x + 18))))
				bgr_data_out = 24'hFFFFFF;
			// desenha o parabrisa dianteiro (branco)
			else if ((pixel_y <= CAR_USER_Y + 10) && (pixel_y >= CAR_USER_Y + 7) && 
				(pixel_x <= car_user_x + 17) && (pixel_x >= car_user_x + 5))
				bgr_data_out = 24'hFFFFFF;
			// desenha o parabrisa traseiro (branco)
			else if ((pixel_y <= CAR_USER_Y + 29) && (pixel_y >= CAR_USER_Y + 27) && 
				(pixel_x <= car_user_x + 16) && (pixel_x >= car_user_x + 6))
				bgr_data_out = 24'hFFFFFF;
			// desenha os vidros laterais (branco)
			else if (pixel_x == car_user_x + 2 || pixel_x == car_user_x + 3 ||
				 pixel_x == car_user_x + 19 || pixel_x == car_user_x + 20) begin
				if ((pixel_x == car_user_x + 2 || pixel_x == car_user_x + 20) && ((pixel_y <= CAR_USER_Y + 23)&&
				(pixel_y >= CAR_USER_Y + 13)))
				bgr_data_out = 24'hFFFFFF;
				else if ((pixel_x == car_user_x + 3 || pixel_x == car_user_x + 19) && ((pixel_y <= CAR_USER_Y + 24)&&
				(pixel_y >= CAR_USER_Y + 12)))
				bgr_data_out = 24'hFFFFFF;
				else bgr_data_out = 24'h007BFF;
			end
			// desenha pneus (cinza)
			else if (((pixel_y <= CAR_USER_Y + 6) && (pixel_y >= CAR_USER_Y + 3)) || 
				((pixel_y <= CAR_USER_Y + 32) && (pixel_y >= CAR_USER_Y + 29))) begin
				if (pixel_x == car_user_x || pixel_x == (car_user_x + CAR_WIDTH - 1)) 
					bgr_data_out = 24'h555555;
				else bgr_data_out = 24'h007BFF;
			end
			// Remove extremos (quinas) do carro (preto)
			else if (((pixel_y == CAR_USER_Y) || (pixel_y == (CAR_USER_Y + CAR_HEIGHT - 1))) &&
    			   ((pixel_x == car_user_x) || (pixel_x == (car_user_x + CAR_WIDTH - 1)))) begin
    				bgr_data_out = 24'h000000;
			end
			// desenha a carroceria 
			else bgr_data_out = 24'h007BFF;
        	end
		// desenha retrovisores do carro do jogador (azul)
		else if ((pixel_y == CAR_USER_Y + 8) && (pixel_x == (car_user_x - 1) || pixel_x == (car_user_x + CAR_WIDTH))) 
			bgr_data_out = 24'h007BFF;

        	// Desenha o carro 2 (vermelho)
        	else if (pixel_x >= car2_x && pixel_x < car2_x + CAR_WIDTH &&
                	pixel_y >= car2_y && pixel_y < car2_y + CAR_HEIGHT) begin
			if (car2_y > 0) begin
				// desenha farois (branco)
				if (pixel_y <= (car2_y + 1) && ((pixel_x <= (car2_x + 4) &&
			    	    pixel_x >= (car2_x + 3)) || (pixel_x <= (car2_x + 19) && pixel_x >= (car2_x + 18))))
					bgr_data_out = 24'hFFFFFF;
				// desenha o parabrisa dianteiro (branco)
				else if ((pixel_y <= car2_y + 10) && (pixel_y >= car2_y + 7) && 
				        (pixel_x <= car2_x + 17) && (pixel_x >= car2_x + 5))
					bgr_data_out = 24'hFFFFFF;
				// desenha o parabrisa traseiro (branco)
				else if ((pixel_y <= car2_y + 29) && (pixel_y >= car2_y + 27) && 
				        (pixel_x <= car2_x + 16) && (pixel_x >= car2_x + 6))
					bgr_data_out = 24'hFFFFFF;
				// desenha os vidros laterais (branco)
				else if (pixel_x == car2_x + 2 || pixel_x == car2_x + 3 ||
				 	pixel_x == car2_x + 19 || pixel_x == car2_x + 20) begin
					if ((pixel_x == car2_x + 2 || pixel_x == car2_x + 20) && ((pixel_y <= car2_y + 23)&&
				   	   (pixel_y >= car2_y + 13)))
						bgr_data_out = 24'hFFFFFF;
					else if ((pixel_x == car2_x + 3 || pixel_x == car2_x + 19) && ((pixel_y <= car2_y + 24)&&
				        	(pixel_y >= car2_y + 12)))
						bgr_data_out = 24'hFFFFFF;
					else bgr_data_out = 24'hFF4500;
				end
				// desenha pneus (cinza)
				else if (((pixel_y <= car2_y + 6) && (pixel_y >= car2_y + 3)) || 
					((pixel_y <= car2_y + 32) && (pixel_y >= car2_y + 29))) begin
					if (pixel_x == car2_x || pixel_x == (car2_x + CAR_WIDTH - 1)) 
						bgr_data_out = 24'h555555;
					else bgr_data_out = 24'hFF4500;
				end
				// Remove extremos (quinas) do carro
				else if (((pixel_y == car2_y) || (pixel_y == (car2_y + CAR_HEIGHT - 1))) &&
    			   		((pixel_x == car2_x) || (pixel_x == (car2_x + CAR_WIDTH - 1)))) begin
    					bgr_data_out = 24'h000000;
				end
				// desenha a carroceria 
				else bgr_data_out = 24'hFF4500;
			end
        	end
		// desenha retrovisores carro 2 (vermelho)
		else if ((pixel_y == car2_y + 8) && (pixel_x == (car2_x - 1) || pixel_x == (car2_x + CAR_WIDTH))) 
			bgr_data_out = 24'hFF4500;

        	// Desenha o carro 3 (vermelho)
        	else if (pixel_x >= car3_x && pixel_x < car3_x + CAR_WIDTH &&
                	pixel_y >= car3_y && pixel_y < car3_y + CAR_HEIGHT) begin
            		// desenha farois (branco)
			if (pixel_y <= (car3_y + 1) && ((pixel_x <= (car3_x + 4) &&
			   pixel_x >= (car3_x + 3)) || (pixel_x <= (car3_x + 19) && pixel_x >= (car3_x + 18))))
				bgr_data_out = 24'hFFFFFF;
			// desenha o parabrisa dianteiro (branco)
			else if ((pixel_y <= car3_y + 10) && (pixel_y >= car3_y + 7) && 
				(pixel_x <= car3_x + 17) && (pixel_x >= car3_x + 5))
				bgr_data_out = 24'hFFFFFF;
			// desenha o parabrisa traseiro (branco)
			else if ((pixel_y <= car3_y + 29) && (pixel_y >= car3_y + 27) && 
				(pixel_x <= car3_x + 16) && (pixel_x >= car3_x + 6))
				bgr_data_out = 24'hFFFFFF;
			// desenha os vidros laterais (branco)
			else if (pixel_x == car3_x + 2 || pixel_x == car3_x + 3 ||
				 pixel_x == car3_x + 19 || pixel_x == car3_x + 20) begin
				if ((pixel_x == car3_x + 2 || pixel_x == car3_x + 20) && ((pixel_y <= car3_y + 23)&&
				  (pixel_y >= car3_y + 13)))
					bgr_data_out = 24'hFFFFFF;
				else if ((pixel_x == car3_x + 3 || pixel_x == car3_x + 19) && ((pixel_y <= car3_y + 24)&&
				        (pixel_y >= car3_y + 12)))
					bgr_data_out = 24'hFFFFFF;
				else bgr_data_out = 24'hFF4500;
			end
			// desenha pneus (cinza)
			else if (((pixel_y <= car3_y + 6) && (pixel_y >= car3_y + 3)) || 
				((pixel_y <= car3_y + 32) && (pixel_y >= car3_y + 29))) begin
				if (pixel_x == car3_x || pixel_x == (car3_x + CAR_WIDTH - 1)) 
					bgr_data_out = 24'h555555;
				else bgr_data_out = 24'hFF4500;
			end
			// Remove extremos (quinas) do carro
			else if (((pixel_y == car3_y) || (pixel_y == (car3_y + CAR_HEIGHT - 1))) &&
    			   	((pixel_x == car3_x) || (pixel_x == (car3_x + CAR_WIDTH - 1)))) begin
    				bgr_data_out = 24'h000000;
			end
			// desenha a carroceria 
			else bgr_data_out = 24'hFF4500;
        	end
		// desenha retrovisores carro 3 (vermelho)
		else if ((pixel_y == car3_y + 8) && (pixel_x == (car3_x - 1) || pixel_x == (car3_x + CAR_WIDTH))) 
			bgr_data_out = 24'hFF4500;
		else bgr_data_out = bgr_data_in;
		end
    end
endmodule


