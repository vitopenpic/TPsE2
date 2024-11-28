module es_operacion_bcd (
    input wire clk, 
    input wire reset, 
    input wire suma_resta,         // operación: 1 para suma, 2 para resta
    input wire igual_en,           // Indica cuándo se puede realizar la operación
    input wire [15:0] numero_1,    // Número 1 en formato BCD
    input wire [15:0] numero_2,    // Número 2 en formato BCD
    output reg [15:0] resultado,   // Resultado de la operación en BCD
    output reg operacion_valida    // Bandera para indicar si el resultado es válido
);

    reg [19:0] resultado_temp;     // Resultado extendido para evitar overflow en BCD
    integer i;                     // Variable para iterar por los dígitos BCD

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            resultado <= 16'b0;
            operacion_valida <= 1'b0;
        end else if (igual_en) begin
            // Inicializar resultado temporal
            resultado_temp = 20'b0;

            // Realizar suma o resta binaria directa
            if (suma_resta == 1) begin
                resultado_temp = numero_1 + numero_2;  // Suma
            end else if (suma_resta == 2) begin
                resultado_temp = numero_1 - numero_2;  // Resta
            end else begin
                resultado_temp = 20'b0;
            end

            // Corregir cada dígito BCD si es necesario
            for (i = 0; i < 16; i = i + 4) begin
                // Extraer el dígito actual
                if (resultado_temp[i +: 4] > 4'd9) begin
                    // Si el dígito excede 9, corregir sumando 6
                    resultado_temp[i +: 4] = resultado_temp[i +: 4] + 4'd6;
                end
            end

            // Verificar si el resultado cabe en 16 bits (4 dígitos en BCD)
            if (resultado_temp > 16'h9999) begin
                resultado <= 16'hFFFF; // Overflow en BCD
                operacion_valida <= 1'b0;
            end else begin
                resultado <= resultado_temp[15:0]; // Resultado corregido
                operacion_valida <= 1'b1;
            end
        end else begin
            resultado <= 16'b0;
            operacion_valida <= 1'b0;
        end
    end

endmodule
