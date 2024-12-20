// debouncer para botao com saida continua
module debouncer_continuo (
    input clk,
    input botao,
    input rst_n,
input internal_reset,
    output reg sinal_btn   // Sinal cont?nuo enquanto o bot?o est? pressionado
);
    reg registrador_1, registrador_2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            registrador_1 <= 0;
            registrador_2 <= 0;
            sinal_btn <= 0;
	end else if (internal_reset) begin
				registrador_1 <= 0;
            registrador_2 <= 0;
            sinal_btn <= 0;
        end else begin
            registrador_1 <= botao;
            registrador_2 <= registrador_1;
            sinal_btn <= registrador_2;
        end
    end
endmodule

// debouncer para botao com pulso sincronizado com clock na saida (botoes left e right)
module debouncer_pulso (
  input clk,
  input rst_n,
  input botao,
  output reg sinc_botao
);
  reg registrador_1, registrador_2;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      begin
    	sinc_botao <= 0;
	registrador_1 <= 0;
    	registrador_2 <= 0;
      end
    else
      begin
	registrador_1 <= botao;
    	registrador_2 <= registrador_1;
    	sinc_botao <= registrador_1 & ~registrador_2;
      end
  end
  
endmodule

