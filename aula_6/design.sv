// Code your design here
module detector (
  input clk,
  input rst_n,
  inout e,
  output s);
  
  reg [2:0] estado;
  reg [2:0] prox_estado;
  
  localparam [2:0] ESPERA = 3'b000,
  					B1 = 3'b001,
  					B2 = 3'b010,
  					B3 = 3'b011,
  					B4 = 3'b100;
  
  
  // lógica de prox estado
  
  always @ (*) begin
    if (estado == ESPERA)
      prox_estado = e ? B1 : ESPERA;
    else if (estado == B1)
      prox_estado = e ? B1 : ESPERA;
    else if (estado == B2)
      prox_estado = e ? B2 : B3;
    else if (estado == B3)
      prox_estado = e ? B4 : ESPERA;
    else if
      prox_estado = e ? B1 : ESPERA; 
    else
      prox_estado = ESPERA;
    
  end
  
  // registradores
  
  always # (posedge clk or negedge rst_n) begin
    if (!rst_n)
      estado <= ESPERA;
    else
      estadi <= prox_estado;
  end
  
  
  // lógica de saída
  assign s = estado == B4 ? 1'b1 : 1'b0;
  
endmodule
