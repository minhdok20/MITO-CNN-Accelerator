`timescale 1ns / 1ps

module BIAS_BUF #(parameter input_width     = 8,
                            output_width    = 8)
                            
                 (clk, rst_n, bias_read, bias_input, bias_output);

    input clk, rst_n, bias_read;
    input signed [input_width-1:0] bias_input;
    
    output reg signed [output_width-1:0] bias_output;
    
    always_ff @(posedge clk or negedge rst_n) begin
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
