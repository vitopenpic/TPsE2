//
module modulo_ingresar_numero (clk, reset, ingresar_numero_1_en, contador, operando_en, enable, nuevo_numero, numero_en); //numero en viene del teclaro si toco un numero
    input wire clk, reset, ingresar_numero_en, nuevo_numero, numero2_en, numero_en; //ingresar_num_en es del teclado    // Clock, reset, sensor inputs (async)
    output reg  operando_en, enable, ingresar_numero_1_en;               // Control output
    //output [2:1] y;         // State output (para debug)
    output reg[1:0] contador; //de 2 bits, cuenta hasta 4


    reg [1:0] curr_state, next_state; 
    reg [15:0] numero_1; ///guarda el numero que llega
    reg in_prev; //es para guardar el valor anterior y compararlo con el acitual
    reg detector; //un flag
    // Asignacion de estados


    parameter [1:0] Esperar = 2'b00;
    parameter [1:0] Mostrar_numero = 2'b01;
    parameter [1:0] Operando = 2'b10;
    parameter [1:0] Enable= 2'b11;

    // Logica de proximo estado (combinacional)
    always @(posedge clk, ingresar_numero_en)
        case (curr_state)
            Esperar: begin 
                    if (ingresar_numero_1_en == 1 && ingresar_numero_en == 1 && detector==1) begin
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
                    if(detector==1) ;//solamente hacelo si sigue la entrada de clock activa
                    begin
                    numero_1<=numero_1<<4; //corro el numero 4 veces
                    numero_1[3:0]<=nuevo_numero;
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
    always @(reset)
        if(reset==1)begin
            in_prev<=0; //valores iniciales de reseteo
            detector<=0; 
            curr_state <= Esperar;
            contador<=0;
        end
        else begin 
            curr_state <= next_state;
			if(numero_en && !in_prev) //se fija el anterior y el nuevo a ver si cambio si si, detecta el flanco entonces podes ir a la logica
                begin //sino, no detecta y no hace nada, o sea si no se estaba ingresando un numero y ahora si, detector se activa
                    detector<=1;  
                end
            else detector<=0;
        end

    // Salida (combinacional)
	//assign out = (curr_state == E1) || (curr_state == E2);
	
	always @(curr_state)
		begin
			if (curr_state == Enable) //estado bobo pero necesario para que el contador no cuente con el clk 
				begin
                    enable <= 1;
                    operando_en<=0; //desabilito operando por las dudas
                    contador <= contador + 1;
				end
			else if (curr_state == Mostrar_numero)	
				begin
                    enable <= 0;
                    operando_en<=0;
                    numero<=numero<<4; //corro mi numero
                    numero<=numero[3:0]; //guardo solo ultimos 4 bits
				end
            else if (curr_state == Operando)	
				begin
                    contador<=0;
                    enable<=0;
                    ingresar_numero_1_en<=0;// deshabilito el ingreso de numeros
				end
            else if (curr_state == Esperar)	

                    enable<=0;
				end
		
endmodule