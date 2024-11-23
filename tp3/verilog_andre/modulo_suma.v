module es_operacion (
    input wire clk, 
    input wire reset, 
    input wire suma_resta,         // operación: 1 para suma, 2 para resta
    input wire operando_en,  
    input wire igual_en,           // Indica cuándo se puede realizar la operación
    input wire [15:0] numero_1,    
    input wire [15:0] numero_2,    
    output reg [15:0] resultado // Resultado de la operación
);
    reg [16:0] resultado_temp; // Resultado extendido para detectar overflow/underflow
    reg operacion_valida;       // Bandera interna para indicar resultado válido

    // Lógica combinacional para realizar la operación
    always @(*) begin
        if (igual_en) begin
            // Dependiendo de `suma_resta`, realiza suma o resta
            if (suma_resta == 1) begin
                resultado_temp = numero_1 + numero_2;
            end else if (suma_resta == 2) begin
                resultado_temp = numero_1 - numero_2;
            end else begin
                resultado_temp = 17'b0; // Default en caso de operación inválida
            end

            // Verificar overflow/underflow
            if (resultado_temp[16]) begin
                resultado = 16'hFFFF; // Indicador de overflow o underflow
                operacion_valida = 0;
            end else begin
                resultado_en = resultado_temp[15:0]; // Resultado válido
                operacion_valida = 1;
            end
        end else begin
            // Si igual_en no está activo, mantener valores por defecto
            resultado = 0;
            operacion_valida = 0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            resultado <= 0;
        end
    end

endmodule
