// modulo deteccion de teclado
module keyboard_read (
    input wire rst,
    //input wire enb,
    input wire clk_lf,          // clk de baja freq
    input wire clk_hf,          // clk de alta freq
    input wire [0:3] cols,      // entrada del teclado
    input wire [4:7] rows,      // "
    output reg button_pressed,  // actua como un enb para no leer mas numeros
    output reg is_op,         // si la tecla es una operacion
    output reg is_num,        // si la tecla es un numero
    output reg [0:1] which_op,        // que operacion se toco 
    // 1=suma 2=resta 3=igual 0=nada          
    output reg [0:3] which_num // que num se toco
);

reg [0:3]which_key; // registro que guarda la tecla que se toco
parameter [0:13]LF_CLK_FREQ = 14'd3; // low freq clk

// mecanica anti rebote:
// si se preisono una tecla
wire pressed;
assign pressed = rows[4] | rows[5] | rows [6] | rows[7];

reg [0:13]cnt; // 14 bits para contar hasta 10e3, o sea un segundo

// mantener la entrada en high una vez que se presiono una tecla 
// durante 10e3 ciclos de clock, o sea un segundo 
always @(posedge(clk_lf))
begin
    if (rst)
    begin
        cnt <= 14'd0;
        button_pressed <= 0;
    end
    else 
    begin
        if (pressed)
            button_pressed <= 1;
        if (button_pressed)
            cnt <= cnt + 14'd1;
        if ((cnt > LF_CLK_FREQ) && (!pressed))
        begin
            button_pressed <= 0;
            cnt <= 14'd0;
        end
        else if (cnt > LF_CLK_FREQ)
            cnt <= 14'd0;
    end
end
// esta es una senyal con flanco ascendente cuando se presiona una tecla
// y dura 10 ciclos de clock

// ahora decodifico con una LUT que tecla se presiono
wire [0:3]instant_key; // el valor de cols&rows en todo momento
decode decode1 (rst, cols, rows, instant_key);

// quiero quedarme con el valor de instant_key solo cuando se presiona una tecla y la clockeo con la lf_clk
reg [0:3]which_key_lf;
// se mantiene el valor de which_key hasta que se toque de nuevo otra tecla
always @(posedge(clk_lf))
begin
    if (rst) 
        which_key_lf <= 4'd0;
    else if (pressed) 
        which_key_lf <= instant_key;
end

// sincronizo con el clk de hf con dos DFF
reg [0:3]which_key_lf_sync1; // First stage synchronization flip-flop
reg [0:3]which_key_lf_sync2; // Second stage synchronization flip-flop
always @(posedge (clk_hf)) 
begin
    if (rst) 
    begin
        which_key <= 4'd0;
        which_key_lf_sync1 <= 4'd0;
        which_key_lf_sync2 <= 4'd0;
    end
    else 
    begin
        // Synchronize the low frequency signal into the high frequency clock domain
        which_key_lf_sync1 <= which_key_lf; // First flip-flop synchronizer
        which_key_lf_sync2 <= which_key_lf_sync1; // Second flip-flop synchronizer
        
        // Now assign the synchronized signal to which_key
        which_key <= which_key_lf_sync2;
    end
end

always @(posedge (clk_hf)) 
begin
    if(rst)
    begin
        is_op <= 0;
        is_num <= 0;
        which_op <= 2'd0;
        which_num <= 4'd0;
    end
    else
        if (which_key < 4'd10) // si es un numero
        begin
            is_op <= 0;
            is_num <= 1;
            which_op <= 2'd0; // nidea lo pongo en cero
            which_num <= which_key;
        end
        else // si es una operacion
        begin
            is_op <= 1;
            is_num <= 0;
            which_num <= 4'd0;
            case (which_key)
                4'hA: which_op = 2'd1; // es una suma
                4'hB: which_op = 2'd2; // es una resta
                4'hC: which_op = 2'd3; // es un igual
            endcase
        end
end

endmodule