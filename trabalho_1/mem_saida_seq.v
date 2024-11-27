module mem_saida_seq(
    input [18:0] endereco,
    output [23:0] data_out);
    
reg [2:0] memoria [0:640*480-1];    

assign data_out[23:16] = {8{memoria[endereco][2]}}; // Vermelho
assign data_out[15:8]  = {8{memoria[endereco][1]}}; // Verde
assign data_out[7:0]   = {8{memoria[endereco][0]}}; // Azul

initial  $readmemb("mario_n.txt", memoria);

endmodule
