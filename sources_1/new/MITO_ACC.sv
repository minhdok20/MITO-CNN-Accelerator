`timescale 1ns / 1ps

module MITO_ACC #(parameter ifm_input_width = 32,
                            wgt_input_width = 32,
                            bias_ipnut_width = 8,
                            output_width = 8)
                 (clk, rst_n, bias_input, ofm_output,
                  ifm_input0, ifm_input1, ifm_input2, 
                  wgt_input0, wgt_input1, wgt_input2);

    input clk;
    input rst_n;
    input signed [bias_ipnut_width-1:0] bias_input;
    
    input signed [ifm_input_width-1:0] ifm_input0;
    input signed [ifm_input_width-1:0] ifm_input1;
    input signed [ifm_input_width-1:0] ifm_input2;
    
    input signed [wgt_input_width-1:0] wgt_input0;
    input signed [wgt_input_width-1:0] wgt_input1;
    input signed [wgt_input_width-1:0] wgt_input2;    
    
    output reg signed [output_width-1:0] ofm_output;
    
    wire signed [bias_ipnut_width-1:0] bias_wire;
    
    wire signed [ifm_input_width-1:0] ifm_wire0;
    wire signed [ifm_input_width-1:0] ifm_wire1;
    wire signed [ifm_input_width-1:0] ifm_wire2;
    wire signed [ifm_input_width-1:0] ifm_wire3;
    wire signed [ifm_input_width-1:0] ifm_wire4;
    wire signed [ifm_input_width-1:0] ifm_wire5;
    wire signed [ifm_input_width-1:0] ifm_wire6;
    wire signed [ifm_input_width-1:0] ifm_wire7;
    wire signed [ifm_input_width-1:0] ifm_wire8;
    
    wire signed [wgt_input_width-1:0] wgt_wire0;
    wire signed [wgt_input_width-1:0] wgt_wire1;
    wire signed [wgt_input_width-1:0] wgt_wire2;
    wire signed [wgt_input_width-1:0] wgt_wire3;
    wire signed [wgt_input_width-1:0] wgt_wire4;
    wire signed [wgt_input_width-1:0] wgt_wire5;
    wire signed [wgt_input_width-1:0] wgt_wire6;
    wire signed [wgt_input_width-1:0] wgt_wire7;
    wire signed [wgt_input_width-1:0] wgt_wire8;
    
    wire [2:0] ifm_read;
    wire wgt_read;
    wire bias_read; 
    
    IFM_BUF ifm_buffer (.clk(clk), .rst_n(rst_n), .ifm_read(ifm_read),
                        .ifm_input0(ifm_input0), .ifm_input1(ifm_input1), .ifm_input2(ifm_input2), 
                        .ifm_output0(ifm_wire0), .ifm_output1(ifm_wire1), .ifm_output2(ifm_wire2),
                        .ifm_output3(ifm_wire3), .ifm_output4(ifm_wire4), .ifm_output5(ifm_wire5),
                        .ifm_output6(ifm_wire6), .ifm_output7(ifm_wire7), .ifm_output8(ifm_wire8));
                        
    WGT_BUF wgt_buffer (.clk(clk), .rst_n(rst_n), .wgt_read(wgt_read),
                        .wgt_input0(wgt_input0), .wgt_input1(wgt_input1), .wgt_input2(wgt_ipnut2),  
                        .wgt_output0(wgt_wire0), .wgt_output1(wgt_wire1), .wgt_output2(wgt_wire2), 
                        .wgt_output3(wgt_wire3), .wgt_output4(wgt_wire4), .wgt_output5(wgt_wire5), 
                        .wgt_output6(wgt_wire6), .wgt_output7(wgt_wire7), .wgt_output8(wgt_wire8));
                        
    BIAS_BUF bias_buffer (.clk(clk), .rst_n(rst_n), .bias_read(bias_read), .bias_input(bias_input), .bias_output(bias_wire));
    
    
    
endmodule
