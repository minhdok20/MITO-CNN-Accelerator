`timescale 1ns / 1ps

module QUANTIZATION #(parameter input_width     = 20,
                                output_width    = 8)

                     (clk, rst_n, ofm_input, ofm_output);
                     
    input clk, rst_n;
    input [input_width-1:0] ofm_input;
        
    output reg [output_width-1:0] ofm_output;
        
    wire [input_width-9:0] mantissa = ofm_input[input_width-9:0];
    wire [7:0] exponent = ofm_input[input_width-1:input_width-8];
    
    assign ofm_output = mantissa >> (exponent - 127);
    
endmodule