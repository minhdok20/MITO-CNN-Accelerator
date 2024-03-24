`timescale 1ns / 1ps

module BIAS_BUF #(parameter INPUT_WIDTH = 32,
                            OUTPUT_WIDTH = 32)
                            
                 (clk, rst_n, valid_read, bias_input, bias_output);

    input clk, rst_n, valid_read;
    input signed [INPUT_WIDTH-1:0] bias_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] bias_output;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bias_output <= 0;
        end else begin
            if (valid_read) begin
                bias_output <= bias_output;
            end else begin
                bias_output <= bias_input;
            end
        end
    end
    
endmodule
