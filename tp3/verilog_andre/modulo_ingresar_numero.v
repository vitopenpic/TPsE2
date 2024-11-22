//Implementacion de una maquina de estados de Moore en Verilog
module modulo_ingresar_numero (clk, reset, ingresar_numero_1_en, contador, operando_en, enable, nuevo_numero, numero_en); //numero en viene del teclaro si toco un numero
    input wire clk, reset, ingresar_numero_en, nuevo_numero, numero2_en, numero_en; //ingresar_num_en es del teclado    // Clock, reset, sensor inputs (async)
    output reg  operando_en, enable, ingresar_numero_1_en;               // Control output
    //output [2:1] y;         // State output (para debug)
    output reg[1:0] contador;
    reg [1:0] curr_state, next_state;
    reg [15:0] numero;
    reg in_prev;
    reg detector;
    // Asignacion de estados
    parameter [1:0] Esperar = 2'b00;
    parameter [1:0] Mostrar_numero = 2'b01;
    parameter [1:0] Operando = 2'b10;
    parameter [1:0] Enable= 2'b11;

    // Logica de proximo estado (combinacional)
    always @(in, curr_state)
        case (curr_state)
            Esperar: begin 
                    if (ingresar_numero_1_en == 1 && ingresar_numero_en == 1 && detect==1) begin
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
                    if(dectector==1) ;//solamente hacelo si sigue la entrada de clock activa
                    begin
                    numero<=numero<<4; //corro el numero 4 veces
                    numero[3:0]<=nuevo_numero;
                    if (ingresar_numero_1_en == 0 && contador == 4) next_state <= Operando;
                    else if (ingresar_numero_1_en == 0 && contador < 4) next_state <= Esperar;
                    else next_state <= Mostrar_numero;
                    end
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
        if(reset==1);begin
            in_prev<=0;
            dectector<=0;
            curr_state <= Esperar;
        end
        else begin 
            curr_state <= next_state;
			if(numero_en && !in_prev) //se fija el anterior y el nuevo a ver si cambio si si, detecta el flanco entonces podes ir a la logica
                begin //sino, no detecta y no hace nada
                    detect<=1;  
                end
            else detect<=0;
        end

    // Salida (combinacional)
	//assign out = (curr_state == E1) || (curr_state == E2);
	
	always @(curr_state)
		begin
			if (curr_state == Enable)
				begin
                    enable <= 1;
                    operando_en<=0;
                    contador <= contador + 1;
				end
			else if (curr_state == Mostrar_numero)	
				begin
                    enable <= 0;
                    operando_en<=0;
				end
            else if (curr_state == Operando)	
				begin
                    contador<=0;
                    enable<=0;
                    ingresar_numero_1_en<=0;
				end
            else if (curr_state == Esperar)	

                    enable<=0;
				end
		end
endmodule