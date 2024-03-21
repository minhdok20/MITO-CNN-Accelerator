`timescale 1ns / 1ps

// ** MODULE DESIGN PE BLOCK **

module PE  #(parameter          INPUT_IFM_WIDTH         = 8,                // Input feature map 
                                INPUT_WGT_WIDTH         = 8,                // Input weight width
                                OUTPUT_WIDTH            = 16                // Output width
            )
            (input wire                                 clk,                // Input clock
             input wire                                 rst_n,              // Input inactive reset 
             input wire signed  [INPUT_IFM_WIDTH-1:0]   ifm_input,          // Input feature map
             input wire signed  [INPUT_WGT_WIDTH-1:0]   wgt_input,          // Input weight 
             output reg signed  [OUTPUT_WIDTH-1:0]      product_output      // Output partial product
            );
    
    // Flip flop calculate partial product (if clk signal) 
    //        or reset output to 0         (if rst_n signal)
    always_ff @(posedge clk or negedge rst_n) 
    begin
        if (~rst_n) 
        begin
            product_output <= 'bx;
        end 
        else 
        begin
            product_output <= ifm_input * wgt_input;
        end
    end
    
endmodule