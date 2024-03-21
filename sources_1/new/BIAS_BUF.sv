`timescale 1ns / 1ps

// ** MODULE BIAS BUFFER **
module BIAS_BUF #(parameter             INPUT_WIDTH             = 8,
                                        OUTPUT_WIDTH            = 8
                 )        
                 (input                                         clk, 
                  input                                         rst_n, 
                  input                                         bias_read, 
                  input signed          [INPUT_WIDTH-1:0]       bias_input, 
                  output reg signed     [OUTPUT_WIDTH-1:0]      bias_output);
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            bias_output <= 'bx;
        end 
        else 
        begin
            if (bias_read) 
            begin
                bias_output <= bias_input;
            end 
            else 
            begin
                bias_output <= bias_output;
            end
        end
    end
    
endmodule
