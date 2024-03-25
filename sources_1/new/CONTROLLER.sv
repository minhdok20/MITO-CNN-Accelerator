`timescale 1ns / 1ps

module CONTROLLER #(parameter INSTRUCTION_WIDTH = 32) 
                              
                   (clk, rst_n, instruction_signal, layer_signal);
                   
    input clk, rst_n;
    input [INSTRUCTION_WIDTH-1:0] instruction_signal;  
    output reg layer_signal; //0 = fully/convol and 1 = pooling
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            layer_signal <= 0;
        end else begin
            // tạm thời coi như instruction khác 0 thì là pooling
            if (instruction_signal)
                layer_signal <= 1;
            else
                layer_signal <= 0;
        end
    end
    
endmodule