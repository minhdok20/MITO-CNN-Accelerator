`timescale 1ns / 1ps

// ** MODULE ACTIVATION FUNCTION: RELU **
// If data unknown, result is 0
module RELU    #(parameter           INPUT_WIDTH         = 20,
                 parameter           OUTPUT_WIDTH        = 20
                )

                (input wire                             clk, 
                 input wire                             rst_n, 
                 input wire signed  [INPUT_WIDTH-1:0]   input_relu,
                 output bit signed  [OUTPUT_WIDTH-1:0]  output_relu
                );
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            output_relu <= 0;
        end 
        else 
        begin
            output_relu <= ($isunknown(input_relu)) ? 0 : input_relu;
        end
    end
            
endmodule
