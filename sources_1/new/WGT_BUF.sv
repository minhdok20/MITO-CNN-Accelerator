`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2024 08:41:21 AM
// Design Name: module Accelerator
// Module Name: WGT_BUF
// Project Name: CNN Accelerator
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


module WGT_BUF#(parameter output_width = 8,
                          input_width = 32)
               (clk, rst_n, wgt_read,
                wgt_input0, wgt_input1, wgt_input2,  
                wgt_output0, wgt_output1, wgt_output2, 
                wgt_output3, wgt_output4, wgt_output5, 
                wgt_output6, wgt_output7, wgt_output8);
    input clk;
    input rst_n;
    input wgt_read;
    input signed [input_width-1:0] wgt_input0;
    input signed [input_width-1:0] wgt_input1;
    input signed [input_width-1:0] wgt_input2;
    
    output reg signed [output_width-1:0] wgt_output0;
    output reg signed [output_width-1:0] wgt_output1;
    output reg signed [output_width-1:0] wgt_output2;
    output reg signed [output_width-1:0] wgt_output3;
    output reg signed [output_width-1:0] wgt_output4;
    output reg signed [output_width-1:0] wgt_output5;
    output reg signed [output_width-1:0] wgt_output6;
    output reg signed [output_width-1:0] wgt_output7;
    output reg signed [output_width-1:0] wgt_output8;
   
    always @(posedge clk or negedge rst_n)
        if (~rst_n) begin
            wgt_output0 <= 0;
            wgt_output1 <= 0;
            wgt_output2 <= 0;
            wgt_output3 <= 0;
            wgt_output4 <= 0;
            wgt_output5 <= 0;
            wgt_output6 <= 0;
            wgt_output7 <= 0;
            wgt_output8 <= 0;
        end else begin
            if(wgt_read) begin
                wgt_output0 <= wgt_input0[input_width-1:16];
                wgt_output1 <= wgt_input0[15:8];
                wgt_output2 <= wgt_input0[7:0];
                wgt_output3 <= wgt_input1[input_width-1:16];
                wgt_output4 <= wgt_input1[15:8];
                wgt_output5 <= wgt_input1[7:0];
                wgt_output6 <= wgt_input2[input_width-1:16];
                wgt_output7 <= wgt_input2[15:8];
                wgt_output8 <= wgt_input2[7:0];
            end else begin
                wgt_output0 <= wgt_output0;
                wgt_output1 <= wgt_output1;
                wgt_output2 <= wgt_output2;
                wgt_output3 <= wgt_output3;
                wgt_output4 <= wgt_output4;
                wgt_output5 <= wgt_output5;
                wgt_output6 <= wgt_output6;
                wgt_output7 <= wgt_output7;
                wgt_output8 <= wgt_output8;
            end
        end
endmodule