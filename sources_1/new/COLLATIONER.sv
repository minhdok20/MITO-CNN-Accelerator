`timescale 1ns / 1ps

// ** MODULE COLLATIONER **
module COLLATIONER #(parameter          INPUT_WIDTH         = 8,
                                        OUTPUT_WIDTH        = 8
                    )           
                    (input                                  clk, 
                     input                                  rst_n, 
                     input signed       [INPUT_WIDTH-1:0]   ifm_input0,
                     input signed       [INPUT_WIDTH-1:0]   ifm_input1, 
                     output reg signed  [OUTPUT_WIDTH-1:0]  ifm_output
                    );
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            ifm_output <= 'bx;
        end 
        else 
        begin
            ifm_output <= (ifm_input0 > ifm_input1) ? ifm_input0 : ifm_input1;
        end        
    end
    
endmodule
