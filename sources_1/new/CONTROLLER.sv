`timescale 1ns / 1ps

module CONTROLLER #() 
                              
                   (clk, rst_n, start, start_signal);
                   
    input clk, rst_n, start;  
    output reg start_signal;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_signal <= 0;
        end else begin
            if (start)
                start_signal <= 1;
            else
                start_signal <= start_signal;
        end
    end
    
    
    
endmodule