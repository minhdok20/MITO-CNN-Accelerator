`timescale 1ns / 1ps

`include "PE.sv"
`include "ADDER_TREE.sv"

// ** MODULE PE ARRAY (2 DIMENSIONS) **
module PE_ARR #(parameter           INPUT_IFM_WIDTH         = 8,
                                    INPUT_WGT_WIDTH         = 8,
                                    INPUT_BIAS_WIDTH        = 8,
                                    PAR_WIDTH               = 16,
                                    OUTPUT_WIDTH            = 20,
                                    PE_ARR_SIZE             = 9
               )   
               (input wire                                  clk, 
                input wire                                  rst_n, 
                input wire signed   [INPUT_BIAS_WIDTH-1:0]  bias_input, 
                input wire signed   [INPUT_IFM_WIDTH-1:0]   ifm_input       [PE_ARR_SIZE-1:0],
                input wire signed   [INPUT_WGT_WIDTH-1:0]   wgt_input       [PE_ARR_SIZE-1:0],
                output reg signed   [OUTPUT_WIDTH-1:0]      ofm_output
               );

    // Additional partial output of PE blocks
    wire signed                     [PAR_WIDTH-1:0]         product_output  [PE_ARR_SIZE-1:0];
    
    // Connection
    genvar i;
    
    generate    
        for (i = 0; i < PE_ARR_SIZE; i++) begin
            PE                     #(.INPUT_IFM_WIDTH       (INPUT_IFM_WIDTH),
                                     .INPUT_WGT_WIDTH       (INPUT_WGT_WIDTH),
                                     .OUTPUT_WIDTH          (PAR_WIDTH)
                                    )                
                pe                  (.clk                   (clk), 
                                     .rst_n                 (rst_n), 
                                     .ifm_input             (ifm_input[i]), 
                                     .wgt_input             (wgt_input[i]), 
                                     .product_output        (product_output[i])
                                    );
        end
    endgenerate
    
    ADDER_TREE                     #(.INPUT_WIDTH           (PAR_WIDTH),
                                     .INPUT_BIAS_WIDTH      (INPUT_BIAS_WIDTH),
                                     .OUTPUT_WIDTH          (OUTPUT_WIDTH),
                                     .PE_ARR_SIZE           (PE_ARR_SIZE)
                                    )
                adderTree           (.clk(clk), 
                                     .rst_n(rst_n), 
                                     .bias_input(bias_input), 
                                     .product_input(product_output),
                                     .ofm_output(ofm_output)
                                    );   
    
endmodule