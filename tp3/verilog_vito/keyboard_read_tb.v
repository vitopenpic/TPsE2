`timescale 1ns/10ps

// Testbench for keyboard_read connected to fsm_ringcounter4
module keyboard_read_tb;

// Declare testbench signals
reg reset;
reg clk_lf; // low-frequency clock
reg clk_hf; // high-frequency clock
reg [3:0] rows;  // Rows for simulating key press
wire [3:0] cols; // Columns coming from fsm_ringcounter4
wire button_pressed;
wire is_op;
wire is_num;
wire [0:1] which_op;
wire [3:0] which_num; 

// Instantiate the fsm_ringcounter4 module
fsm_ringcounter4 ring_counter (
    .clk(clk_lf),  // Use low-frequency clock for the ring counter
    .reset(reset),
    .enable_in(1'b1), // Always enabled for the test
    .out(cols)  // Connect output to cols input of keyboard_read
);

// Instantiate the keyboard_read module
keyboard_read keyboard (
    .rst(reset),
    .clk_lf(clk_lf),
    .clk_hf(clk_hf),
    .cols(cols),
    .rows(rows),
    .button_pressed(button_pressed),
    .is_op(is_op),
    .is_num(is_num),
    .which_op(which_op),
    .which_num(which_num)
);

// Clock generation for both clk_lf (low-frequency) and clk_hf (high-frequency)
always begin
    #5 clk_lf = ~clk_lf; // Low-frequency clock (200 MHz)
end

always begin
    #1 clk_hf = ~clk_hf; // High-frequency clock (12 MHz)
end

// Test stimulus
initial begin
    // Initialize signals
    clk_lf = 0;
    clk_hf = 0;
    reset = 1;
    rows = 4'b0000;

    // Generate a VCD dump file for waveform visualization
    $dumpfile("keyboard_read_tb.vcd");
    $dumpvars(3);  // Set depth for signal tracing

    // Apply reset for a few clock cycles
    #10 reset = 0;  // Deassert reset after 10 ns

    // Simulate key press and release events for the rows

    // Simulate a press of key "1" (row 1)
    #10 rows = 4'b0001;  // Assert the first row (key press simulation)
    #6  rows = 4'b0000;  // Deassert rows to simulate key release
    #20 rows = 4'b0010;  // Assert second row
    #6  rows = 4'b0000;  // Deassert rows
    #30 rows = 4'b0100;  // Assert third row (another key press)
    #6  rows = 4'b0000;  // Deassert rows
    #50 rows = 4'b1000;  // Assert fourth row (yet another key press)
    #6  rows = 4'b0000;  // Deassert rows

    // Monitor the outputs
    // This part will help you track the values of the outputs during the simulation.
    #10;
    $display("At time %t:", $time);
    $display("button_pressed = %b, is_op = %b, is_num = %b, which_op = %b, which_num = %d",
             button_pressed, is_op, is_num, which_op, which_num);

    // Run the simulation for a few more cycles to observe behavior
    #200;

    // Finish the simulation
    $finish;
end

endmodule
