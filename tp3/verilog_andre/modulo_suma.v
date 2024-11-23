module es_operacion (clk, reset, que_operacion, operando_en, igual_en, resultado_en); //si operando es en este modulo empieza a funcionar
    input wire clk, reset, operando_en,ingresar_numero_1_en, ingresar_numero_2_en resultado_en;   // Clock, reset, sensor inputs (async) //operando_en viene desde el teclado
    output reg  contador, enable, igual_en;               // Control output
    //output [2:1] y;         // State output (para debug)
    output reg ingresar_numero_1_en, ingresar_numero_2_en; //flags
    reg [1:0] curr_state, next_state; 

    // Asignacion de estados
    parameter [1:0] Esperar = 2'b00;
    parameter [1:0] Operacion = 2'b01;
    parameter [1:0] Alu= 2'b10;
    parameter [1:0] IngreseNum_2= 2'b11;

    

    // Logica de proximo estado (combinacional)
    always @(curr_state)
        case (curr_state)
            Esperar: begin 
                    if (operando_en != 0) begin //espera a 
                        next_state <= Operacion;
                    end   
                    else begin 
                        next_state <= Esperar;
                    end
                end
             Operacion: begin 
                    if(que_operacion == 1 || que_operacion ==2) //si es suma o resta
                    next_state <= IngreseNum_2;
                end
                else if(que_operacion == 3 && igual_en==1) //si es igual
                    next_state <= Alu;
                else 
                    next_state <= Esperar;
            Alu: begin 
                next_state <= Esperar;
                end
            IngreseNum_2: begin
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

	
	always @(curr_state)
		begin
			if (curr_state == Operacion)
				begin
                    
                    ingresar_numero_1_en<=0;
                    ingresar_numero_2_en<=0; //nada habilitado
				end
			else if (curr_state == Alu)	
				begin
                    ingresar_numero_1_en<=1; //rehabilito ingresar primer numero porque ya paso el igual
                    ingresar_numero_2_en<=0;
				end
            else if (curr_state == IngreseNum_2)	
				begin
                    ingresar_numero_1_en<=0; //no habilito ingresar el primer numero
                    ingresar_numero_2_en<=1; //solo el segundo 
				end
            else if (curr_state == Esperar)	
				begin
				end
		end
endmodule

//clk, reset, numero2_en, que_operacion, operando_en, igual_en
//que_operacion, operando_en, igual_en, ingresar_numero_1_en, ingresar_numero_2_en