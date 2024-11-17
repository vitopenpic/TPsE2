module keyb_iface(
        input clk,
        input reset,
        output reg [3:0] cols, 
        input wire [3:0] rows,
        output reg is_number,
        output reg is_op,
        output reg is_eq,
        output wire any_btn,
        output reg [4:0] num_val,
        output reg [1:0] op_val);


    //Ring counter para seleccionar columnas
    always @(posedge clk) begin
        if (reset)
            cols <= 4'b0000;
        else begin
            if (cols == 4'b0000)
                cols <= 4'b0001;
            else
                cols <= cols << 1;
        end
    end

    //Armo el valor que recibo, combino col y fila
    wire [3:0] btn_id;

    assign btn_id[3] = cols[1];
    assign btn_id[2] = cols[0];
    assign btn_id[1] = rows[1];
    assign btn_id[0] = rows[0];
 
    //reg para 'guardar' el valor
    reg [3:0] btn_store;

    //indica que se presiono un boton
    assign any_btn = rows[0] || rows [1] || rows [2] || rows[3];

    //guardo el valor que leo de fila y col
    always @(posedge clk) begin
        if (reset) begin
            btn_id = 4'd0;
        end
        else begin
            if (any_btn)
                btn_store = btn_id;
            else            
                btn_sotre = 4'd0;
        end
        
    end

    //decodifico los valores posibles
    parameter [15:0] BTN_0 =    4'b0111    //0000 0000 0000 0100;
    parameter [15:0] BTN_1 =    4'b0000    //1000 0000 0000 0000;
    parameter [15:0] BTN_2 =    4'b0100    //0100 0000 0000 0000;
    parameter [15:0] BTN_3 =    4'b1000    //0010 0000 0000 0000;
    parameter [15:0] BTN_4 =    4'b0001    //0000 1000 0000 0000;
    parameter [15:0] BTN_5 =    4'b0101    //0000 0100 0000 0000;
    parameter [15:0] BTN_6 =    4'b1001    //0000 0010 0000 0000;
    parameter [15:0] BTN_7 =    4'b0010    //0000 0000 1000 0000;
    parameter [15:0] BTN_8 =    4'b0110    //0000 0000 0100 0000;
    parameter [15:0] BTN_9 =    4'b1010    //0000 0000 0010 0000;
    parameter [15:0] BTN_PLUS = 4'b1100    //0001 0000 0000 0000;
    parameter [15:0] BTN_MIN =  4'b1101    //0000 0001 0000 0000;
    parameter [15:0] BTN_EQ =   4'b1111    //0000 0000 0000 0001;

    //genero las salidas en base a los botones
    always @(btn_store)
    begin
        case (btn_store)
            BTN_0: begin 
                is_number <= 1;
                is_eq <= 0;
                is_op <= 0;
                num_val = 4'd0;
                op_val = 2'd0;
            end
            BTN_1: begin 
                is_number <= 1;
                is_eq <= 0;
                is_op <= 0;
                num_val = 4'd1;
                op_val = 2'd0;
            end
            BTN_2: begin 
                is_number <= 1;
                is_eq <= 0;
                is_op <= 0;
                num_val = 4'd2;
                op_val = 2'd0;
            end
            BTN_3: begin 
                is_number <= 1;
                is_eq <= 0;
                is_op <= 0;
                num_val = 4'd3;
                op_val = 2'd0;
            end
            BTN_4: begin 
                is_number <= 1;
                is_eq <= 0;
                is_op <= 0;
                num_val = 4'd4;
                op_val = 2'd0;
            end

            //.... etc.

            BTN_PLUS: begin 
                is_number <= 0;
                is_eq <= 0;
                is_op <= 1;
                num_val = 4'd0;
                op_val = 2'd1;
            end
            BTN_MIN: begin 
                is_number <= 0;
                is_eq <= 0;
                is_op <= 1;
                num_val = 4'd0;
                op_val = 2'd2;
            end


            BTN_EQ: begin 
                is_number <= 0;
                is_eq <= 1;
                is_op <= 0;
                num_val = 4'd0;
                op_val = 2'd0;
            end

        endcase
    end

endmodule
 