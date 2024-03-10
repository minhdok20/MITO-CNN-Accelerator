`timescale 1ns / 1ps

module PE_ARR #(parameter input_width   = 8,
                          output_width  = 20,
                          PE_arr_size   = 9)
                          
               (clk, rst_n, bias_input, ofm_output, ifm_input, wgt_input);
    
    input clk, rst_n, bias_input;
    
    input signed [input_width-1:0] ifm_input [PE_arr_size-1:0];    
    input signed [input_width-1:0] wgt_input [PE_arr_size-1:0];
    
    wire signed [output_width-1:0] product_output [PE_arr_size-1:0];
    
    output reg signed [output_width-1:0] ofm_output;
    
    genvar i;
    
    generate    
        for (i=0; i<PE_arr_size; i=i+1) begin
            PE pe (.clk(clk), .rst_n(rst_n), .ifm_input(ifm_input[i]), .wgt_input(wgt_input[i]), .product_output(product_output[i]));
        end
    endgenerate
    
    ADDER_TREE adderTree(.clk(clk), .rst_n(rst_n), .bias_input(bias_input), .ofm_output(ofm_output), .product_input(product_output));   
    
endmodule