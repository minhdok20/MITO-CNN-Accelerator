`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 10:52:20 AM
// Design Name: 
// Module Name: QUANTIZATION
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

// ** MODULE QUANTIZATION AND RELU **
module  ACTIVATION 
    // --- Parameters ---    
  #(parameter               INPUT_WIDTH             = 32,
                            OUTPUT_WIDTH            = 8
   )
    // --- I/O ---
   (input logic                                     clk, 
    input logic                                     rst_n, 
    input logic                                     ready_activation,
    input logic signed     [INPUT_WIDTH-1:0]        act_input, 
    output logic signed    [OUTPUT_WIDTH-1:0]       act_output,
    output logic                                    ready_write
   );

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n) 
        begin
            act_output <= 'bx;
            ready_write <= 1'b0;
        end
        else
        begin
            if (ready_activation)
            begin
                if (act_input >= 32'h80000000 && act_input <= 32'hFFFFFFFF) 
                begin
                    act_output <= 8'h00;
                end
                else if (act_input >= 32'h00000000 && act_input <= 32'h7FFFFFFF)
                begin
                    act_output <= act_input[INPUT_WIDTH-1:INPUT_WIDTH-8];
                end
                else
                begin
                    act_output <= 'bx;
                end
                ready_write <= 1'b1;
            end
            else
            begin
                act_output <= act_output;
                ready_write <= 1'b0;                
            end
        end
    end       
   
endmodule
