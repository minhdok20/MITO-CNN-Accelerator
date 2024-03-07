`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2024 10:22:42 AM
// Design Name: module Accelerator
// Module Name: IFM_BUF
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


module IFM_BUF #(parameter input_width  = 32,
                           output_width = 8,
                           ALL          = 3'b111,
                           RIGHT        = 3'b001,
                           DOWN         = 3'b010,
                           LEFT         = 3'b100,
                           KEEP         = 3'b000) 
                (clk, rst_n, ifm_read,
                ifm_input0, ifm_input1, ifm_input2,  
                ifm_output0, ifm_output1, ifm_output2,
                ifm_output3, ifm_output4, ifm_output5, 
                ifm_output6, ifm_output7, ifm_output8);
    
    input clk;
    input rst_n;
    input [2:0] ifm_read;
    input signed [input_width-1:0] ifm_input0;
    input signed [input_width-1:0] ifm_input1;
    input signed [input_width-1:0] ifm_input2;   
    
    output reg signed [output_width-1:0] ifm_output0;
    output reg signed [output_width-1:0] ifm_output1;
    output reg signed [output_width-1:0] ifm_output2;
    output reg signed [output_width-1:0] ifm_output3;
    output reg signed [output_width-1:0] ifm_output4;
    output reg signed [output_width-1:0] ifm_output5;
    output reg signed [output_width-1:0] ifm_output6;
    output reg signed [output_width-1:0] ifm_output7;
    output reg signed [output_width-1:0] ifm_output8;
    
    integer i;
    
    always @(posedge clk or negedge rst_n)
        if (~rst_n) begin //declare all ifm_output with a value of 0
            ifm_output0 <= 0;
            ifm_output1 <= 0;
            ifm_output2 <= 0;
            ifm_output3 <= 0;
            ifm_output4 <= 0;
            ifm_output5 <= 0;
            ifm_output6 <= 0;
            ifm_output7 <= 0;
            ifm_output8 <= 0;            
        end else begin
            case (ifm_read)
                ALL: //load all ifm data into 3x3 PE
                begin   
                    ifm_output0 <= ifm_input0[23:16];
                    ifm_output1 <= ifm_input0[15:8];
                    ifm_output2 <= ifm_input0[7:0];
                    ifm_output3 <= ifm_input1[23:16];
                    ifm_output4 <= ifm_input1[15:8];
                    ifm_output5 <= ifm_input1[7:0];
                    ifm_output6 <= ifm_input2[23:16];
                    ifm_output7 <= ifm_input2[15:8];
                    ifm_output8 <= ifm_input2[7:0];
                end
            
                RIGHT: //shift right
                begin
                    //shift the value of 3 PE in the middle column to 3 PE in the left column
                    ifm_output0 <= ifm_output1;
                    ifm_output3 <= ifm_output4;
                    ifm_output6 <= ifm_output7;
                    
                    //shift the value of 3 PE in the right column to 3 PE in the middle column
                    ifm_output1 <= ifm_output2;
                    ifm_output4 <= ifm_output5;
                    ifm_output7 <= ifm_output8;
                
                    //update the value of 3 PE in the right column
                    ifm_output2 <= ifm_input0[7:0];
                    ifm_output5 <= ifm_input1[7:0];
                    ifm_output8 <= ifm_input2[7:0];
                end
                
                DOWN: //shift down
                begin
                    //shift the value of 3 PE in the middle row to 3 PE in the top row
                    ifm_output0 <= ifm_output3;
                    ifm_output1 <= ifm_output4;
                    ifm_output2 <= ifm_output5;
                    
                    //shift the value of 3 PE in the bottom row to 3 PE in the middle row
                    ifm_output3 <= ifm_output6;
                    ifm_output4 <= ifm_output7;
                    ifm_output5 <= ifm_output8;
                    
                    //update the value of 3 PE in the bottom row
                    ifm_output6 <= ifm_input2[23:16];
                    ifm_output7 <= ifm_input2[15:8];
                    ifm_output8 <= ifm_input2[7:0];
                end
                
                LEFT: //shift left
                begin
                    //shift the value of 3 PE in the middle column to 3 PE in the right column
                    ifm_output2 <= ifm_output1;
                    ifm_output5 <= ifm_output4;
                    ifm_output8 <= ifm_output7;
                    
                    //shift the value of 3 PE in the left column to 3 PE in the middle column
                    ifm_output1 <= ifm_output0;
                    ifm_output4 <= ifm_output3;
                    ifm_output7 <= ifm_output6;
                
                    //update the value of 3 PE in the left column
                    ifm_output0 <= ifm_input0[23:16];
                    ifm_output3 <= ifm_input1[23:16];
                    ifm_output6 <= ifm_input2[23:16];
                end
                
                KEEP: //no shifting 
                begin                
                    ifm_output0 <= ifm_output0;
                    ifm_output1 <= ifm_output1;
                    ifm_output2 <= ifm_output2;
                    ifm_output3 <= ifm_output3;
                    ifm_output4 <= ifm_output4;
                    ifm_output5 <= ifm_output5;
                    ifm_output6 <= ifm_output6;
                    ifm_output7 <= ifm_output7;
                    ifm_output8 <= ifm_output8;
                end                  
                
                default: //no shifting 
                begin
                    ifm_output0 <= 0;
                    ifm_output1 <= 0;
                    ifm_output2 <= 0;
                    ifm_output3 <= 0;
                    ifm_output4 <= 0;
                    ifm_output5 <= 0;
                    ifm_output6 <= 0;
                    ifm_output7 <= 0;
                    ifm_output8 <= 0;
                end                 
            endcase         
        end    
endmodule