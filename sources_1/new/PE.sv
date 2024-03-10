`timescale 1ns / 1ps

module PE #(parameter input_width   = 8, 
                      output_width  = 20)
                      
           (clk, rst_n, ifm_input, wgt_input, product_output);

    input clk, rst_n;
    
    input signed [input_width-1:0] ifm_input;
    input signed [input_width-1:0] wgt_input;
    
    output reg signed [output_width-1:0] product_output;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            product_output <= 0;
        end else begin
            product_output <= ifm_input * wgt_input;
        end
    end
    
endmodule