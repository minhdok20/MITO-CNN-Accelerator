`timescale 1ns / 1ps

`include "CONTROLLER.sv"
`include "IFM_BUF.sv"
`include "WGT_BUF.sv"
`include "BIAS_BUF.sv"
`include "PE_ARR.sv"
`include "RELU.sv"
`include "MAX_POOLING.sv"
`include "OFM_BUF.sv"

//-------------------------------------------------------------------------------------
//-------------                MODULE TOP: MITO ACCELERATOR               -------------
//-------------------------------------------------------------------------------------

module  MITO_ACC    
    // --- Parameters ---                  
    #(
    parameter                                   IFM_INPUT_WIDTH     = 32,   
    parameter                                   WGT_INPUT_WIDTH     = 32,
    parameter                                   BIAS_INPUT_WIDTH    = 8,
                            
    parameter                                   IFM_OUTPUT_WIDTH    = 8,
    parameter                                   WGT_OUTPUT_WIDTH    = 8,
    parameter                                   BIAS_OUTPUT_WIDTH   = 8,
    parameter                                   OFM_OUTPUT_WIDTH    = 8,

    parameter                                   INPUT_PAR_WIDTH     = 8*2, 
    parameter                                   OUTPUT_PE_WIDTH     = 20,                       
    parameter                                   INPUT_IFM_REG       = 3,
    parameter                                   INPUT_WGT_REG       = 3,
    parameter                                   PE_ARR_SIZE         = 9,
    parameter                                   POOL_SIZE           = 2*2,

    parameter                                   CONVOLUTIONAL       = 2'b01,
    parameter                                   FULLY               = 2'b10,
    parameter                                   POOLING             = 2'b11
    )
    // --- I/O ---     
    (
    input wire                                  clk, 
    input wire                                  rst_n, 
    input wire                                  start,
    input wire signed   [BIAS_INPUT_WIDTH-1:0]  bias_input,
    input wire signed   [IFM_INPUT_WIDTH-1:0]   ifm_input           [INPUT_IFM_REG-1:0],
    input wire signed   [WGT_INPUT_WIDTH-1:0]   wgt_input           [INPUT_WGT_REG-1:0],
    output reg signed   [OFM_OUTPUT_WIDTH-1:0]  ofm_output
    );

    // --- Additional declarations ---    
    wire signed         [BIAS_OUTPUT_WIDTH-1:0] bias_wire;    
    wire signed         [IFM_OUTPUT_WIDTH-1:0]  ifm_wire            [PE_ARR_SIZE-1:0];    
    wire signed         [WGT_OUTPUT_WIDTH-1:0]  wgt_wire            [PE_ARR_SIZE-1:0];
    wire signed         [OUTPUT_PE_WIDTH-1:0]   ofm_wire_relu_in;
    wire signed         [OUTPUT_PE_WIDTH-1:0]   ofm_wire_relu_out;      
    wire signed         [OFM_OUTPUT_WIDTH-1:0]  ofm_wire_pool_out;
    wire signed         [OFM_OUTPUT_WIDTH-1:0]  ofm_wire_buf;
        
    wire                [2:0]                   ifm_read;
    wire                                        wgt_read;
    wire                                        bias_read;
    wire                [1:0]                   mode;
    wire                                        ofm_valid;
    wire                [1:0]                   layer_type;
    
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
    
    // Activation function RELU
    RELU              #(.INPUT_WIDTH            (OUTPUT_PE_WIDTH),
                        .OUTPUT_WIDTH           (OUTPUT_PE_WIDTH)
                       )
            relu       (.clk                    (clk), 
                        .rst_n                  (rst_n), 
                        .input_relu             (ofm_wire_relu_in), 
                        .output_relu            (ofm_wire_relu_out)
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
