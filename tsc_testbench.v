`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2025 15:31:46
// Design Name: 
// Module Name: tsc_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tsc_testbench;
reg clk, reset, i;
wire NORTH_RED, EAST_GREEN, NORTH_YELLOW, EAST_YELLOW;
wire NORTH_GREEN, EAST_RED, WALK_RED, WALK_GREEN;

// Instantiate the traffic signal controller
tsc a(
    .clk(clk), 
    .reset(reset),
    .i(i),
    .NORTH_RED(NORTH_RED),
    .EAST_GREEN(EAST_GREEN),
    .NORTH_YELLOW(NORTH_YELLOW),
    .EAST_YELLOW(EAST_YELLOW),
    .NORTH_GREEN(NORTH_GREEN),
    .EAST_RED(EAST_RED),
    .WALK_RED(WALK_RED),
    .WALK_GREEN(WALK_GREEN)
);

// Clock generation
always #10 clk = ~clk; // 50 MHz clock -> 20 time units per cycle

initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    i = 0;

    // Hold reset for a few cycles
    #20 reset = 0;

    // Simulate pedestrian pressing the button
    #100 i = 1;
    #20  i = 0;

    // Again simulate later to test multiple press behavior
    #300 i = 1;
    #20  i = 0;

    // Run long enough to see full cycle
    #2000 $finish;
end

// Display signal changes
initial begin
    $display("Time\t\tState");
    $monitor(
        "%0t | N_G=%b N_R=%b N_Y=%b | E_G=%b E_R=%b E_Y=%b | WALK_G=%b WALK_R=%b | i=%b",
        $time, NORTH_GREEN, NORTH_RED, NORTH_YELLOW,
        EAST_GREEN, EAST_RED, EAST_YELLOW,
        WALK_GREEN, WALK_RED, i
    );
end

endmodule

