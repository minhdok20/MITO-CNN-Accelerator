`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2024 11:34:51 PM
// Design Name: 
// Module Name: IFM_BUF_tb
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


module IFM_BUF_tb #(parameter input_width = 32, 
                              output_width = 8,
                              ALL          = 3'b000,
                              RIGHT        = 3'b001,
                              DOWN         = 3'b010,
                              LEFT         = 3'b100,
                              KEEP         = 3'b111);
    reg clk;                                       
    reg rst_n;                                     
    reg signed [2:0] ifm_read;                     
    reg signed [input_width-1:0] ifm_input0;       
    reg signed [input_width-1:0] ifm_input1;       
    reg signed [input_width-1:0] ifm_input2;       
                                                     
    wire signed [output_width-1:0] ifm_output0;
    wire signed [output_width-1:0] ifm_output1;
    wire signed [output_width-1:0] ifm_output2;
    wire signed [output_width-1:0] ifm_output3;
    wire signed [output_width-1:0] ifm_output4;
    wire signed [output_width-1:0] ifm_output5;
    wire signed [output_width-1:0] ifm_output6;
    wire signed [output_width-1:0] ifm_output7;
    wire signed [output_width-1:0] ifm_output8;
    
    IFM_BUF dut(.clk(clk), .rst_n(rst_n), .ifm_read(ifm_read), 
                .ifm_input0(ifm_input0), .ifm_input1(ifm_input1), .ifm_input2(ifm_input2),
                .ifm_output0(ifm_output0), .ifm_output1(ifm_output1), .ifm_output2(ifm_output2),
                .ifm_output3(ifm_output3), .ifm_output4(ifm_output4), .ifm_output5(ifm_output5),
                .ifm_output6(ifm_output6), .ifm_output7(ifm_output7), .ifm_output8(ifm_output8));
                
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        #15;
        rst_n = 1;
        ifm_read = ALL;
        ifm_input0 = 'h 00010203;
        ifm_input1 = 'h 00040506;
        ifm_input2 = 'h 00070809;
        
        #10;
        ifm_read = RIGHT;
        ifm_input0 = 'h 0000000A;
        ifm_input1 = 'h 0000000B;
        ifm_input2 = 'h 0000000C;
        
        #10;
        ifm_read = DOWN;
        ifm_input0 = 'h 00000000;
        ifm_input1 = 'h 00000000;
        ifm_input2 = 'h 000D0E0F;
        
        #10;
        ifm_read = LEFT;
        ifm_input0 = 'h 000A0000;
        ifm_input1 = 'h 000A0000;
        ifm_input2 = 'h 000A0000;
        
        #10 $finish;
    end
endmodule
