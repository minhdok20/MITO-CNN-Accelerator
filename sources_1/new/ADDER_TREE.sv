`timescale 1ns / 1ps

// ** MODULE ADDER TREE **
module ADDER_TREE  #(parameter          INPUT_WIDTH             = 16,                               // Input width
                                        INPUT_BIAS_WIDTH        = 8,                                // Input bias width
                                        OUTPUT_WIDTH            = 20,                               // Output width
                                        PE_ARR_SIZE             = 9                                 // Number of PE blocks   
                    )           
                    (input wire                                 clk,                                // Input clock
                     input wire                                 rst_n,                              // Input reset (negative)
                     input wire signed  [INPUT_BIAS_WIDTH-1:0]  bias_input,                         // Input bias
                     input wire signed  [INPUT_WIDTH-1:0]       product_input   [PE_ARR_SIZE-1:0],  // Input partial products
                     output reg signed  [OUTPUT_WIDTH-1:0]      ofm_output                          // Output feature map 
                    );
    
    // Additional temporary reg 
    reg signed                          [OUTPUT_WIDTH-1:0]      p_sum           [PE_ARR_SIZE-2:0];

    // Flip flop calculate sum of all partial products (look like binary tree)    
    //  0    1    2    3    4    5    6    7    8   bias
    //   \  /      \  /      \  /      \  /      \  /
    //    p0        p1        p2        p3        p4
    //     \        /          \        /         |
    //      \      /            \      /          |
    //       \    /              \    /           |
    //        \  /                \  /            |
    //         p5                  p6             |
    //         |                    |             |
    //         |---------  ---------|             |
    //                  |  |                      |
    //                   p7                       |
    //                   |----------    ----------|
    //                              | |
    //                            ofm_output
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            ofm_output <= 'bx;
            p_sum[0] <= 'bx;
            p_sum[1] <= 'bx;
            p_sum[2] <= 'bx;
            p_sum[3] <= 'bx;
            p_sum[4] <= 'bx;
            p_sum[5] <= 'bx;
            p_sum[6] <= 'bx;
            p_sum[7] <= 'bx;
        end 
        else 
        begin
            p_sum[0]    <= product_input[0] + product_input[1];
            p_sum[1]    <= product_input[2] + product_input[3];
            p_sum[2]    <= product_input[4] + product_input[5];
            p_sum[3]    <= product_input[6] + product_input[7];
            p_sum[4]    <= product_input[8] + bias_input;
            p_sum[5]    <= p_sum[0] + p_sum[1];
            p_sum[6]    <= p_sum[2] + p_sum[3];
            p_sum[7]    <= p_sum[5] + p_sum[6];
            ofm_output  <= p_sum[4] + p_sum[7];
        end      
    end
    
endmodule