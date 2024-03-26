`timescale 1ns / 1ps

// *******************************************************************************************
// ** MODULE PE ARRAY (2 DIMENSIONS) **
module PE_ARR 
    // --- Parameters ---
  #(parameter                                   INPUT_IFM_WIDTH     = 8,
                                                INPUT_WGT_WIDTH     = 8,
                                                INPUT_BIAS_WIDTH    = 32,
                                                PAR_WIDTH           = 16,
                                                OUTPUT_WIDTH        = 32,
                                                PE_ARR_SIZE         = 9
   )
    // --- I/O ---   
   (input logic                                 clk, 
    input logic                                 rst_n, 
    input logic                                 ready_load,
    input signed        [INPUT_BIAS_WIDTH-1:0]  bias_input, 
    input signed        [INPUT_IFM_WIDTH-1:0]   ifm_input           [PE_ARR_SIZE-1:0],
    input signed        [INPUT_WGT_WIDTH-1:0]   wgt_input           [PE_ARR_SIZE-1:0],
    output logic signed [OUTPUT_WIDTH-1:0]      ofm_output,
    output logic                                ready_activation
   );

    // Additional partial output of PE blocks
    logic signed        [PAR_WIDTH-1:0]         product_output      [PE_ARR_SIZE-1:0];
    wire                                        adder_ready;  
      
    // Connection
    genvar                                      i;
    
    generate    
        for (i = 0; i < PE_ARR_SIZE; i++) begin
            PE        #(.INPUT_IFM_WIDTH        (INPUT_IFM_WIDTH),
                        .INPUT_WGT_WIDTH        (INPUT_WGT_WIDTH),
                        .OUTPUT_WIDTH           (PAR_WIDTH)
                       )                
                pe     (.clk                    (clk), 
                        .rst_n                  (rst_n),
                        .ready_load             (ready_load),
                        .ifm_input              (ifm_input[i]), 
                        .wgt_input              (wgt_input[i]), 
                        .adder_ready            (adder_ready), 
                        .product_output         (product_output[i])
                       );
                        
        end
    endgenerate
    
    ADDER_TREE        #(.INPUT_WIDTH            (PAR_WIDTH),
                        .INPUT_BIAS_WIDTH       (INPUT_BIAS_WIDTH),
                        .OUTPUT_WIDTH           (OUTPUT_WIDTH),
                        .PE_ARR_SIZE            (PE_ARR_SIZE)
                       )
            adderTree  (.clk                    (clk), 
                        .rst_n                  (rst_n),
                        .adder_ready            (adder_ready), 
                        .bias_input             (bias_input), 
                        .product_input          (product_output),
                        .ofm_output             (ofm_output),
                        .ready_activation       (ready_activation)
                       );   
    
endmodule
// *******************************************************************************************



// *******************************************************************************************
// ** SUBMODULES **
// -------------------------------------------------------------------------------------------
// PE BLOCK
module PE  
  #(parameter                                   INPUT_IFM_WIDTH         = 8,              
                                                INPUT_WGT_WIDTH         = 8,         
                                                OUTPUT_WIDTH            = 16            
   )
   (input logic                                 clk,                            
    input logic                                 rst_n,                             
    input logic                                 ready_load,          
    input logic signed  [INPUT_IFM_WIDTH-1:0]   ifm_input,      
    input logic signed  [INPUT_WGT_WIDTH-1:0]   wgt_input,  
    output logic                                adder_ready,    
    output logic signed [OUTPUT_WIDTH-1:0]      product_output      
   ); 

    // Flip flop calculate partial product (if clk signal) 
    //        or reset output to 0         (if rst_n signal)
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            product_output <= 1'bx;
            adder_ready <= 1'b0;
        end 
        else 
        begin
            if (ready_load)
            begin
                product_output <= ifm_input * wgt_input;
                adder_ready <= 1'b1;
            end
            else
            begin
                product_output <= product_output;
                adder_ready <= 1'b0;
            end
        end
    end
    
endmodule
// -------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------
// MODULE ADDER TREE
module ADDER_TREE  
    // --- Parameters ---
  #(parameter                                   INPUT_WIDTH             = 16,                           
                                                INPUT_BIAS_WIDTH        = 32,                         
                                                OUTPUT_WIDTH            = 32,                     
                                                PE_ARR_SIZE             = 9                             
   )
    // --- I/O ---             
   (input logic                                 clk,                         
    input logic                                 rst_n,                   
    input logic                                 adder_ready,                   
    input logic signed  [INPUT_BIAS_WIDTH-1:0]  bias_input,                
    input signed        [INPUT_WIDTH-1:0]       product_input           [PE_ARR_SIZE-1:0],  
    output logic signed [OUTPUT_WIDTH-1:0]      ofm_output,
    output logic                                ready_activation                          
   );
    
    // Additional temporary reg 
    logic signed        [OUTPUT_WIDTH:0]        p_sum                   [PE_ARR_SIZE-1:0];

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
    //                               p8
    //                              | |    
    //                            ofm_output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            p_sum[0] <= 'bx;
            p_sum[1] <= 'bx;
            p_sum[2] <= 'bx;
            p_sum[3] <= 'bx;
            p_sum[4] <= 'bx;
            p_sum[5] <= 'bx;
            p_sum[6] <= 'bx;
            p_sum[7] <= 'bx;
            p_sum[8] <= 'bx;
        end 
        else 
        begin
            if (adder_ready)
            begin
                p_sum[0]    <= product_input[0] + product_input[1];
                p_sum[1]    <= product_input[2] + product_input[3];
                p_sum[2]    <= product_input[4] + product_input[5];
                p_sum[3]    <= product_input[6] + product_input[7];
                p_sum[4]    <= product_input[8] + bias_input;
                p_sum[5]    <= p_sum[0] + p_sum[1];
                p_sum[6]    <= p_sum[2] + p_sum[3];
                p_sum[7]    <= p_sum[5] + p_sum[6];
                p_sum[8]    <= p_sum[4] + p_sum[7];
                ready_activation <= 1;
            end
            else
            begin
                p_sum[8]    <= p_sum[8];
                ready_activation <= 0;
            end
        end      
    end
    
    // Handle overflow
    assign ofm_output = (p_sum[8][32] == 1'b0 && p_sum[8][31] == 1'b1) ? 32'h7FFFFFFF :
                        (p_sum[8][32] == 1'b1 && p_sum[8][31] == 1'b0) ? 32'h80000000 : p_sum[8][31:0]; 

endmodule
// -------------------------------------------------------------------------------------------
// *******************************************************************************************