//Implementacion de una maquina de estados de Moore en Verilog
module es_operacion (clk, reset, que_operacion, operando_en);
    input wire clk, reset, operando_en, ingresar_numero_2_en;   // Clock, reset, sensor inputs (async) //operando_en viene desde el teclado
    output reg  contador, enable;               // Control output
    //output [2:1] y;         // State output (para debug)

    reg [1:0] curr_state, next_state;

    // Asignacion de estados
    parameter [1:0] Esperar = 2'b00;
    parameter [1:0] Operacion = 2'b01;
    parameter [1:0] Alu= 2'b10;
    parameter [1:0] IngreseNum_2= 2'b11;

    

    // Logica de proximo estado (combinacional)
    always @(in, curr_state)
        case (curr_state)
            Esperar: begin 
                    if (operando_en == 1) begin
                        next_state <= Operacion;
                    end   
                    else begin 
                        next_state <= Esperar;
                    end
                end
             Operacion: begin 
                    if(que_operacion == 1 || que_operacion_2==2)
                    next_state <= IngreseNum_2;
                    else if(que_operacion == 3 || igual_en==1 )
                    next_state <= Alu
                end
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
	//assign out = (curr_state == E1) || (curr_state == E2);
	
	always @(curr_state)
		begin
			if (curr_state == Operacion)
				begin
                    
                    igual_en=0;
                    ingresar_numero_1_en=>0;
                    ingresar_numero_2_en=>0;
                    
				end
			else if (curr_state == Alu)	
				begin
                    igual_en=>1;
                    ingresar_numero_1_en=>0;
                    ingresar_numero_2_en=>0;
				end
            else if (curr_state == IngreseNum_2)	
				begin
                    igual_en=>0;
                    ingresar_numero_1_en=>0;
                    ingresar_numero_2_en=>2;
				end
            else if (curr_state == Esperar)	
				begin
				end
		end
endmodule

//clk, reset, numero2_en, que_operacion, operando_en, igual_en
//que_operacion, operando_en, igual_en, ingresar_numero_1_en, ingresar_numero_2_en