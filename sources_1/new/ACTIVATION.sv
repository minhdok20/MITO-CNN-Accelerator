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
module  ACTIVATION     #(parameter              INPUT_WIDTH         = 32,
                                                OUTPUT_WIDTH        = 8
                        )
                        (input logic                                clk, 
                         input logic                                rst_n, 
                         input logic signed    [INPUT_WIDTH-1:0]    ofm_input, 
                         output logic signed   [OUTPUT_WIDTH-1:0]   ofm_output
                        );

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            ofm_output <= 'bx;
        end
        else
        begin
            if (ofm_input >= 32'h80000000 && ofm_input <= 32'hFFFFFFFF) 
            begin
                ofm_output <= 8'h00;
            end
            else if (ofm_input >= 32'h00000000 && ofm_input <= 32'h7FFFFFFF)
            begin
                ofm_output <= ofm_input[INPUT_WIDTH-1:INPUT_WIDTH-8];
            end
            else
            begin
                ofm_output <= 'bx;
            end
        end
    end       
   
endmodule
