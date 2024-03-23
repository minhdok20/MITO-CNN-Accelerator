`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2024 11:25:01 PM
// Design Name: 
// Module Name: MITO_ACC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "common/common_define.svh"
`timescale 1ns / 1ps

//-------------------------------------------------------------------------------------
//-------------                MODULE TOP: MITO ACCELERATOR               -------------
//-------------------------------------------------------------------------------------

module  MITO_ACC    
    // --- I/O ---     
    (
    input logic                                  clk, 
    input logic                                  rst_n, 
    input logic                                  start,
    input logic signed   [BIAS_INPUT_WIDTH-1:0]  bias_input,
    input logic signed   [IFM_INPUT_WIDTH-1:0]   ifm_input           [INPUT_IFM_REG-1:0],
    input logic signed   [WGT_INPUT_WIDTH-1:0]   wgt_input           [INPUT_WGT_REG-1:0],
    output logic signed   [OFM_OUTPUT_WIDTH-1:0]  ofm_output
    );

    // --- Additional declarations ---    
    logic signed         [BIAS_OUTPUT_WIDTH-1:0] bias_wire;    
    logic signed         [IFM_OUTPUT_WIDTH-1:0]  ifm_wire            [PE_ARR_SIZE-1:0];    
    logic signed         [WGT_OUTPUT_WIDTH-1:0]  wgt_wire            [PE_ARR_SIZE-1:0];
    logic signed         [OUTPUT_PE_WIDTH-1:0]   ofm_wire_relu_in;
    logic signed         [8-1:0]                 ofm_wire_relu_out;      
    logic signed         [OFM_OUTPUT_WIDTH-1:0]  ofm_wire_pool_out;
    logic signed         [OFM_OUTPUT_WIDTH-1:0]  ofm_wire_buf;
        
    logic                [2:0]                   ifm_read;
    logic                                        wgt_read;
    logic                                        bias_read;
    logic                [1:0]                   mode;
    logic                                        ofm_valid;
    logic                [1:0]                   layer_type;
    
    // --- Connections in MITO accelerator ---

    // Controller
    CONTROLLER        #()
            controller (.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .start                  (start), 
                        // .ifm_read               (ifm_read), 
                        // .wgt_read               (wgt_read), 
                        // .bias_read              (bias_read),
                        .ofm_valid              (ofm_valid), 
                        .layer_type             (layer_type)
                       );

    // Input buffers
    IFM_BUF           #(.INPUT_WIDTH            (IFM_INPUT_WIDTH),
                        .OUTPUT_WIDTH           (IFM_OUTPUT_WIDTH),
                        .INPUT_IFM_REG          (INPUT_IFM_REG),
                        .PE_ARR_SIZE            (PE_ARR_SIZE)
                       )
            ifm_buffer (.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        // .ifm_read               (ifm_read), 
                        // .mode                   (mode),
                        .layer_type             (layer_type),
                        .ifm_input              (ifm_input), 
                        .ifm_output             (ifm_wire)
                       );

    WGT_BUF           #(.INPUT_WIDTH            (WGT_INPUT_WIDTH),
                        .OUTPUT_WIDTH           (WGT_OUTPUT_WIDTH),
                        .INPUT_WGT_REG          (INPUT_WGT_REG),
                        .PE_ARR_SIZE            (PE_ARR_SIZE)
                       ) 
            wgt_buffer (.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .wgt_read               (wgt_read), 
                        .wgt_input              (wgt_input), 
                        .wgt_output             (wgt_wire)
                       );

    BIAS_BUF          #(.INPUT_WIDTH            (BIAS_INPUT_WIDTH),
                        .OUTPUT_WIDTH           (BIAS_OUTPUT_WIDTH)                     
                       ) 
            bias_buffer(.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .bias_read              (bias_read), 
                        .bias_input             (bias_input), 
                        .bias_output            (bias_wire)
                       );
    
    // PE array
    PE_ARR            #(.INPUT_IFM_WIDTH        (IFM_OUTPUT_WIDTH),
                        .INPUT_WGT_WIDTH        (WGT_OUTPUT_WIDTH),
                        .PAR_WIDTH              (INPUT_PAR_WIDTH),   
                        .INPUT_BIAS_WIDTH       (BIAS_OUTPUT_WIDTH),  
                        .OUTPUT_WIDTH           (OUTPUT_PE_WIDTH),
                        .PE_ARR_SIZE            (PE_ARR_SIZE)   
                       )            
            pe_array   (.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .bias_input             (bias_wire), 
                        .ifm_input              (ifm_wire), 
                        .wgt_input              (wgt_wire), 
                        .ofm_output             (ofm_wire_relu_in)
                       );
    
    // Quantization and activation function RELU
    ACTIVATION        #(.INPUT_WIDTH            (OUTPUT_PE_WIDTH),
                        .OUTPUT_WIDTH           (8)
                       )
            activation (.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .input_relu             (ofm_input), 
                        .output_relu            (ofm_output)
                       );
    
    // Max pooling layer

    MAX_POOLING       #(.INPUT_WIDTH            (OFM_OUTPUT_WIDTH),
                        .OUTPUT_WIDTH           (OFM_OUTPUT_WIDTH),
                        .POOL_SIZE              (POOL_SIZE)
                       )
            max_pooling(.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .ifm_input              (ifm_wire[POOL_SIZE-1:0]), 
                        .ifm_output             (ofm_wire_pool_out));
        
    // Output buffer
    assign ofm_wire_buf = (mode == POOLING) ? ofm_wire_pool_out : ofm_wire_relu_out;  

    OFM_BUF           #(.INPUT_WIDTH            (OFM_OUTPUT_WIDTH),
                        .OUTPUT_WIDTH           (OFM_OUTPUT_WIDTH)
                       ) 
            ofm_buffer (.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .ofm_input              (ofm_wire_buf), 
                        .ofm_output             (ofm_output)
                       );
    
endmodule
