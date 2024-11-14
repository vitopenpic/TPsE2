//Implementacion de una maquina de estados de Moore en Verilog
module fsm_ringcounter4 (clk, reset, enable_in, out);
    input clk, reset, enable_in;   // Clock, reset, enable in
    output reg [3:0] out;          // Output
    //output [2:1] y;              // State output (para debug)

    reg [2:1] curr_y, next_Y;

    // Asignacion de estados
    parameter [2:1] E1 = 2'b00;
    parameter [2:1] E2 = 2'b01;
    parameter [2:1] E3 = 2'b10;
    parameter [2:1] E4 = 2'b11;

    // Logica de proximo estado (combinacional)
    always @(enable_in, curr_y)
        case (curr_y)
          E1:  if (enable_in == 1) 
					next_Y = E2;   
				 else 
					next_Y = E1; 
          
          E2:  if (enable_in == 1) 
					next_Y = E3;   
				 else 
					next_Y = E2; 
          
          E3:  if (enable_in == 1) 
					next_Y = E4;   
				 else 
					next_Y = E3; 
          
          E4:  if (enable_in == 1) 
					next_Y = E1;   
				 else 
					next_Y = E4; 

          
          default: next_Y = 2'bxx;
        endcase

    // Transicion al proximo estado (secuencial)
    always @(posedge reset, posedge clk)
        if (reset == 1) curr_y <= E1;
        else curr_y <= next_Y;

    // Salida (con assign)
    assign out[3] = (curr_y == E1);
    assign out[2] = (curr_y == E2);
    assign out[1] = (curr_y == E3);
    assign out[0] = (curr_y == E4);
    
	// Salida (con always)
    /*
	always @(curr_y)
		begin 
          if (curr_y == E1)
		      out = 4'b1000;
          else if (curr_y == E2)	
		      out = 4'b0100;
          else if (curr_y == E3)	
		      out = 4'b0010;
          else if (curr_y == E4)	
		      out = 4'b0001;
		end
     */
endmodule