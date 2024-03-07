`timescale 1ns / 1ps

module COLLATIONER #(parameter input_width  = 20,
                               output_width = 20)
                    (clk, rst_n, ifm_input0, ifm_input1, ifm_output);
    input logic clk, rst_n;
    input logic [input_width-1:0] ifm_input0;
    input logic [input_width-1:0] ifm_input1;
    
    output reg [output_width-1:0] ifm_output;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ifm_output <= 0;
        end else begin
            ifm_output <= (ifm_input0 > ifm_input1) ? ifm_input0 : ifm_input1;
        end        
    end
endmodule
