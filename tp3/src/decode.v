module decode (
    input wire rst,
    input wire [0:3] cols,
    input wire [4:7] rows,
    output reg [0:3] key
);

// 8'b(cols)_(rows)
parameter [7:0] BTN_0 = 8'b0010_1000;       // col2 & row4
parameter [7:0] BTN_1 = 8'b0001_0001;       // col1 & row1  
parameter [7:0] BTN_2 = 8'b0010_0001;       // col2 & row1  
parameter [7:0] BTN_3 = 8'b0100_0001;       // col3 & row1  
parameter [7:0] BTN_4 = 8'b0001_0010;       // col1 & row2  
parameter [7:0] BTN_5 = 8'b0010_0010;       // col2 & row2  
parameter [7:0] BTN_6 = 8'b0100_0010;       // col3 & row2  
parameter [7:0] BTN_7 = 8'b0001_0100;       // col1 & row3
parameter [7:0] BTN_8 = 8'b0010_0100;       // col2 & row3
parameter [7:0] BTN_9 = 8'b0100_0100;       // col3 & row3
parameter [7:0] BTN_PLUS = 8'b1000_0001;    // col4 & row1 (TECLA A)
parameter [7:0] BTN_MINUS = 8'b1000_0010;   // col4 & row2 (TECLA B)
parameter [7:0] BTN_EQ = 8'b0100_0000;      // col4 & row3 (TECLA C)

// Decoding logic for button presses
always @(*) begin
    if (rst) begin
        key = 4'b0000; // Default value when reset
    end else begin
        case ({cols, rows}) 
            // First row (rows[0])
            BTN_1: key = 4'd1;  
            BTN_2: key = 4'd2;  
            BTN_3: key = 4'd3;  
            BTN_PLUS: key = 4'd10;  // hexa A

            // Second row (rows[1])
            BTN_4: key = 4'd4;  
            BTN_5: key = 4'd5;  
            BTN_6: key = 4'd6;  
            BTN_MINUS: key = 4'd11;  

            // Third row (rows[2])
            BTN_7: key = 4'd7;  
            BTN_8: key = 4'd8;  
            BTN_9: key = 4'd9;  
            BTN_EQ: key = 4'd12; 

            // Fourth row (rows[3])
            BTN_0: key = 4'd0;  
            default: key = 4'b0000;    
        endcase
    end
end

endmodule
