`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 10:02:01 AM
// Design Name: 
// Module Name: BIAS_BUF
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


module BIAS_BUF #(parameter input_width = 8,
                  parameter output_width = input_width)
                 (clk, rst_n, bias_read, bias_input, bias_output);

    input clk;
    input rst_n;
    input signed [input_width-1:0] bias_input;
    input bias_read;
    
    output reg signed [output_width-1:0] bias_output;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bias_output <= 0;
        end else begin
            if (bias_read) begin
                bias_output <= bias_output;
            end else begin
                bias_output <= bias_input;
            end
        end
    end
    
endmodule
