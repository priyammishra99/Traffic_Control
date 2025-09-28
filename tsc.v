`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2025 09:34:48
// Design Name: 
// Module Name: tsc
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


module tsc(
    input clk, reset, i,
    output reg NORTH_GREEN, EAST_RED, WALK_RED, WALK_GREEN,
    output reg NORTH_RED, EAST_GREEN, NORTH_YELLOW, EAST_YELLOW
);

parameter T_GREEN = 30, T_YELLOW = 10;

reg [1:0] st, nx_st;
parameter RG = 2'b00, YY = 2'b01, GR = 2'b10;

reg [31:0] timer;

// Sequential Block
always @(posedge clk or posedge reset) begin
    if (reset) begin
        st <= RG;
        timer <= T_GREEN;
    end else if (timer == 0) begin
        st <= nx_st;
        // timer will be updated in combinational logic below
    end else begin
        timer <= timer - 1;
    end
end

// Next-State and Timer Logic
always @(*) begin
    // Default next state and timer
    nx_st = st;
    
    case (st)
        RG: begin
            if (i) begin
                nx_st = RG; // Pedestrian request does not change state
            end else begin
                nx_st = YY;
            end
        end
        YY: begin
            nx_st = GR;
        end
        GR: begin
            nx_st = RG;
        end
    endcase

    // Timer logic based on next state
    case (nx_st)
        RG: timer = T_GREEN;
        YY: timer = T_YELLOW;
        GR: timer = T_GREEN;
    endcase
end

// Output Logic
always @(*) begin
    // Default all outputs to 0
    NORTH_RED = 0; NORTH_GREEN = 0;
    EAST_RED = 0; EAST_GREEN = 0;
    WALK_RED = 1; WALK_GREEN = 0; // default: walk signal is red
    NORTH_YELLOW = 0; EAST_YELLOW = 0;

    case (st)
        RG: begin
            NORTH_RED = 1;
            EAST_GREEN = 1;
            EAST_RED = 0;
            WALK_RED = 1; WALK_GREEN = 0;
        end
        YY: begin
            NORTH_YELLOW = 1; EAST_YELLOW = 1;
        end
        GR: begin
            NORTH_GREEN = 1;
            EAST_RED = 1;
        end
    endcase

    // Pedestrian request: if active, show walk green only in RG
    if (i ) begin
        WALK_RED = 0;
        WALK_GREEN = 1;
        NORTH_RED = 1;
        EAST_GREEN =0;
        EAST_RED =1;
        NORTH_YELLOW =0;
        EAST_YELLOW =0;
        NORTH_GREEN =0;
    end
end

endmodule

