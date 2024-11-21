//Implementacion de una maquina de estados de Moore en Verilog
module fsm_mealy (clk, reset, ingresar_numero, contador, operando_en, enable);
    input wire clk, reset, ingresar_numero,;   // Clock, reset, sensor inputs (async)
    output reg  operando_en, contador, enable;               // Control output
    //output [2:1] y;         // State output (para debug)

    reg [1:0] curr_state, next_state;

    // Asignacion de estados
    parameter [1:0] Esperar = 2'b00;
    parameter [1:0] Mostrar_numero = 2'b01;
    parameter [1:0] Operando = 2'b10;
    parameter [1:0] Enable= 2'b11;

    // Logica de proximo estado (combinacional)
    always @(in, curr_state)
        case (curr_state)
            Esperar: begin 
                    if (ingresar_numero == 1) begin
                        next_state <= Enable;
                    end   
                    else begin 
                        next_state <= Esperar;
                    end
                end
             Enable: begin 
                    next_state <= Mostrar_numero;
                end
            Mostrar_numero: begin 
                    if (ingresar_numero == 0 && contador == 4) next_state <= Operando;
                    else if (ingresar_numero == 0 && contador < 4) next_state <= Esperar;
                    else next_state <= Mostrar_numero;
                end
            Operando: begin
                 next_state <= Esperar;
                end
            default: begin
                    next_state <= Esperar;
                end
        endcase

    // Transicion al proximo estado (secuencial)
    always @(posedge clk)
        if (reset == 1) curr_state <= Esperar;
        else curr_state <= next_state;

    // Salida (combinacional)
	//assign out = (curr_state == E1) || (curr_state == E2);
	
	always @(curr_state)
		begin
			if (curr_state == Enable)
				begin
                    enable = 1;
                    operando_en=0;
                    contador = contador + 1;
				end
			else if (curr_state == Mostrar_numero)	
				begin
                    enable = 0;
                    operando_en=0;
				end
            else if (curr_state == Operando)	
				begin
					operando_en=1;
                    contador=0;
                    enable=0;
				end
            else if (curr_state == Esperar)	
				begin
					operando_en=0;
                    enable=0;
				end
		end
endmodule