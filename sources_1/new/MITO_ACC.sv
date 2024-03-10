`timescale 1ns / 1ps

module MITO_ACC #(parameter ifm_input_width     = 32,
                            wgt_input_width     = 32,
                            ifm_output_width    = 8,
                            wgt_output_width    = 8,
                            bias_width          = 8,
                            ofm_output_width    = 8,
                            input_reg           = 3,
                            PE_array_size       = 9)
                            
                 (clk, rst_n, bias_input, ofm_output, ifm_input, wgt_input);

    input clk, rst_n;
    
    input signed [bias_width-1:0] bias_input;    
    input signed [ifm_input_width-1:0]  ifm_input [input_reg-1:0];    
    input signed [wgt_input_width-1:0]  wgt_input [input_reg-1:0];    
    
    output reg signed [ofm_output_width-1:0] ofm_output;
    
    wire signed [bias_width-1:0]        bias_wire;    
    wire signed [ifm_output_width-1:0]  ifm_wire [PE_array_size-1:0];    
    wire signed [wgt_output_width-1:0]  wgt_wire [PE_array_size-1:0];
    wire signed [ofm_output_width-1:0]  ofm_wire_PE_array_to_relu;
    wire signed [ofm_output_width-1:0]  ofm_wire_relu_to_ofm_buf;      
        
    wire [2:0] ifm_read;
    wire wgt_read;
    wire bias_read; 
    
    IFM_BUF ifm_buffer      (.clk(clk), .rst_n(rst_n), .ifm_read(ifm_read), .ifm_input(ifm_input), .ifm_output(ifm_wire));
    WGT_BUF wgt_buffer      (.clk(clk), .rst_n(rst_n), .wgt_read(wgt_read), .wgt_input(wgt_input), .wgt_output(wgt_wire));
    BIAS_BUF bias_buffer    (.clk(clk), .rst_n(rst_n), .bias_read(bias_read), .bias_input(bias_input), .bias_output(bias_wire));
    
    PE_ARR pe_array         (.clk(clk), .rst_n(rst_n), .bias_input(bias_wire), .ifm_input(ifm_wire), .wgt_input(wgt_wire), .ofm_output(ofm_wire_PE_array_to_relu));
    RELU relu               (.clk(clk), .rst_n(rst_n), .input_relu(ofm_wire_PE_array_to_relu), .output_relu(ofm_wire_relu_to_ofm_buf));
    
    OFM_BUF ofm_buffer      (.clk(clk), .rst_n(rst_n), .ofm_input(ofm_wire_relu_to_ofm_buf), .ofm_output(ofm_output));    
    
endmodule
