`timescale 1ns / 1ps

module CONTROLLER #(parameter INSTRUCTION_WIDTH = 32,

//                              START_FULLY_CONVOL = 2'b01,
//                              START_POOLING = 2'b10,
//                              FINISH = 2'b11,
                              
                              FULLY_CONVOL = 1'b0,
                              POOLING = 1'b1) 
                              
                   (clk, rst_n, instruction_signal, ready_write_from_activation, ready_write_from_pooling, layer_signal, fully_convol_signal, pooling_signal, write_signal);
                   
    input clk, rst_n;
    input ready_write_from_activation; 
    input ready_write_from_pooling;
    input [INSTRUCTION_WIDTH-1:0] instruction_signal;  
    
    output reg layer_signal;
    output reg fully_convol_signal;
    output reg pooling_signal;
    output reg write_signal;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            layer_signal <= FULLY_CONVOL;
            fully_convol_signal <= 1;
            pooling_signal <= 0;
        end else begin
            if (instruction_signal) begin
                layer_signal <= POOLING;
                fully_convol_signal <= 0;
                pooling_signal <= 1;                
            end else begin
                layer_signal <= FULLY_CONVOL;
                fully_convol_signal <= 1;
                pooling_signal <= 0;
            end
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_signal <= 0;
        end else begin
            if (ready_write_from_activation || ready_write_from_pooling) begin
                write_signal <= 1;
            end else begin
                write_signal <= 0;
            end
        end
    end
    
endmodule