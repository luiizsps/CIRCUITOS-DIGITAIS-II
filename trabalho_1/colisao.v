module collision_checker (
    input clk,
    input rst_n,
    input internal_reset,
    input wire [5:0] CAR_WIDTH,
    input wire [5:0] CAR_HEIGHT,
    input wire [9:0] car_user_x,
    input wire [8:0] car_user_y,
    input wire [9:0] car2_x,
    input wire [9:0] car2_y,
    input wire [9:0] car3_x,
    input wire [9:0] car3_y,
    output reg collision_detected
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            collision_detected <= 1'b0;
	end else if (internal_reset) begin
	    collision_detected <= 1'b0;
        end else begin
            // verifica colisao com car2 ou car3
            collision_detected <= ((car_user_x < car2_x + CAR_WIDTH) && 
                                   (car_user_x + CAR_WIDTH > car2_x) && 
                                   (car_user_y < car2_y + CAR_HEIGHT) && 
                                   (car_user_y + CAR_HEIGHT > car2_y)) ||
                                  ((car_user_x < car3_x + CAR_WIDTH) && 
                                   (car_user_x + CAR_WIDTH > car3_x) && 
                                   (car_user_y < car3_y + CAR_HEIGHT) && 
                                   (car_user_y + CAR_HEIGHT > car3_y));
        end
    end

endmodule

