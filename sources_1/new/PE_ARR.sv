`timescale 1ns / 1ps

module PE_ARR #(parameter INPUT_WIDTH = 8,
                          OUTPUT_WIDTH = 20,
                          PE_arr_size = 9)
                          
               (clk, rst_n, ready_load, ifm_input, wgt_input, bias_input, ofm_output);
    
    input clk, rst_n, ready_load;
        
    input signed [INPUT_WIDTH-1:0] ifm_input [PE_arr_size-1:0];    
    input signed [INPUT_WIDTH-1:0] wgt_input [PE_arr_size-1:0];
    input signed bias_input;
    
    wire signed [OUTPUT_WIDTH-1:0] product_output [PE_arr_size-1:0];
    
    output reg signed [OUTPUT_WIDTH-1:0] ofm_output;
    
    wire ready_adder;   
    
    genvar i;
    
    generate    
        for (i=0; i<PE_arr_size; i=i+1) begin
            PE pe (.clk(clk), .rst_n(rst_n), .ready_load(ready_load), .ifm_input(ifm_input[i]), .wgt_input(wgt_input[i]), .product_output(product_output[i]), .ready_adder(ready_adder));
        end
    endgenerate
    
    ADDER_TREE adderTree(.clk(clk), .rst_n(rst_n), .ready_adder(ready_adder), .bias_input(bias_input), .ofm_output(ofm_output), .product_input(product_output));   
    
endmodule