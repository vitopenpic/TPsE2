// modulo deteccion de teclado

module keyboard_read (
    input wire rst,
    input wire clk,
    //input wire enb,
    input wire [0:3] cols,
    input wire [4:7] rows,
    output wire [0:7] key_coord,
    output wire button_pressed
);
wire pressed;
wire pressed_posedge;
wire pressed_delay;

parameter CLK_FREQ = 12_000_000;
// mecanica anti rebote:
// si se preisono una tecla
assign pressed = rows[4] | rows[5] | rows [6] | rows[7];
// detector de flancos ascendentes de pressed
pos_edge_det pos_edge_det1 (pressed, clk, pressed_posedge); 
// quiero una senyal que prolongue pressed_posedge con delay de 1 s 
// suponiendo un clk de 12 Mhz --> que espere 12 millones de ciclos de clk
reg [0:23]cnt; // 24 bits para contar hasta 12e6

always @(posedge(clk))
begin
    if (rst)
    begin
        cnt <= 24'd0;
        pressed_delay <= 0;
    end
    else
    begin
        if (cnt < (CLK_FREQ - 1))
        begin
            cnt <= cnt + 24'd1;
            pressed_delay <= 1;
        end
        else
        begin
            cnt <= 24'd0;
            pressed_delay <= 0;
        end 
    end
end

assign button_pressed = pressed_posedge & ~pressed_delay;

endmodule