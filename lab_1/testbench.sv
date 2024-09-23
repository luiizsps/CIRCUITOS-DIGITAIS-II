module teste();
  reg [2:0] A;
  reg [2:0] B;
  reg [1:0] seletor;
  wire [5:0] result;
  wire [3:0] unidade, dezena;
  wire [6:0] display_unidades, display_dezenas;

  calculadora calc_u1(
    .A(A),
    .B(B),
    .sel(seletor),
    .result(result)
  );

  separa_digitos sep_dig_u1(
    .result(result),
    .sel(seletor),
    .unidade(unidade),
    .dezena(dezena)
  );

  bcd_p_7seg display_7seg_unidades(
    .bcd(unidade),
    .seg(display_unidades)
  );

  bcd_p_7seg display_7seg_dezenas(
    .bcd(dezena),
    .seg(display_dezenas)
  );

  initial begin
    
    A = 3'd7; 
    B = 3'd2; 

    seletor = 2'b00;
    #10; 
    $display("Soma: A=%d, B=%d, Resultado=%d", A, B, result);

    seletor = 2'b01;
    #10;
    $display("Subtração: A=%d, B=%d, Resultado=%d", A, B, result);

    seletor = 2'b10;
    #10;
    $display("Produto: A=%d, B=%d, Resultado=%d", A, B, result);

    seletor = 2'b11;
    #10;
    $display("Divisão: A=%d, B=%d, quociente=%d, resto=%d", A, B, result[2:0], result[5:3]);

    $stop;
  end

endmodule
