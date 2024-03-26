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
`include "CONTROLLER.sv"
`include "DEMUX_1_TO_2.sv"
`include "MAIN_BUF.sv"
`include "PE_ARR.sv"
`include "ACTIVATION.sv"
`include "MAX_POOLING.sv"
`include "OFM_BUF.sv"

//-------------------------------------------------------------------------------------
//-------------                MODULE TOP: MITO ACCELERATOR               -------------
//-------------------------------------------------------------------------------------

module  MITO_ACC    
    // --- I/O ---     
    (
    input logic                                     clk, 
    input logic                                     rst_n, 
    input logic         [INSTRUCTION_WIDTH-1:0]     instruction_input,
    input logic         [REGISTER_WIDTH-1:0]        data_input,
    output logic signed [REGISTER_WIDTH-1:0]        ofm_output,
    output logic                                    finish,
    output logic                                    flag_full_data_reg_output
    );

    // --- Additional declarations ---    
        // Driven signals
    logic                                           layer_signal;
    logic                                           fully_convol_signal;
    logic                                           pooling_signal;
    logic                                           write_signal;

    logic                                           sel;

    logic                                           ready_load;
    logic                                           ready_activation;
    logic                                           ready_write_from_act;
    logic                                           ready_write_from_pooling;
    
        // Memory driver
    logic signed        [IFM_DATA_WIDTH-1:0]        ifm_data                    [PE_ARR_SIZE-1:0];    
    logic signed        [WGT_DATA_WIDTH-1:0]        wgt_data                    [PE_ARR_SIZE-1:0];
    logic signed        [BIAS_DATA_WIDTH-1:0]       bias_data;

    logic               [REGISTER_WIDTH-1:0]        data_in_fully_convol;
    logic               [REGISTER_WIDTH-1:0]        data_in_max_pooling;   

    logic signed        [PE_OUTPUT_WIDTH-1:0]       ofm_data_from_pe_to_act;
    logic signed        [OUTPUT_OFM_WIDTH-1:0]      ofm_data_act_buf;
    logic signed        [OUTPUT_OFM_WIDTH-1:0]      ofm_data_pool_buf;
    
    // --- Connections in MITO accelerator ---

    // Controller
    CONTROLLER         #(.INSTRUCTION_WIDTH         (INSTRUCTION_WIDTH)
                        )
            controller  (.clk                       (clk), 
                         .rst_n                     (rst_n), 
                         .instruction_signal        (instruction_input), 
                         .ready_write_from_act      (ready_write_from_act),
                         .ready_write_from_pooling  (ready_write_from_pooling),
                         .layer_signal              (layer_signal), 
                         .fully_convol_signal       (fully_convol_signal), 
                         .pooling_signal            (pooling_signal), 
                         .write_signal              (write_signal)
                        );
    // Demux layer
    DEMUX_1_TO_2       #(.INPUT_WIDTH               (REGISTER_WIDTH),
                         .OUTPUT_WIDTH              (REGISTER_WIDTH) 
                        )
            demuxlayer  (.sel                       (layer_signal), 
                         .demux_input               (data_input), 
                         .demux_output_main_buf     (data_in_fully_convol), 
                         .demux_output_max_pooling  (data_in_max_pooling)
                        );
    // Main buffer 
    MAIN_BUF          #(.REGISTER_WIDTH             (REGISTER_WIDTH),
                        .OUTPUT_IFM_WIDTH           (IFM_DATA_WIDTH),
                        .OUTPUT_WGT_WIDTH           (WGT_DATA_WIDTH),
                        .OUTPUT_BIAS_WIDTH          (BIAS_DATA_WIDTH),
                        .NUM_OF_PE_BLKS             (PE_ARR_SIZE)
                       )
            mainbuf    (.clk                        (clk), 
                        .rst_n                      (rst_n), 
                        .fully_convol_signal        (fully_convol_signal), 
                        .main_input                 (data_in_fully_convol), 
                        .ready_load                 (ready_load), 
                        .main_output_ifm            (ifm_data), 
                        .main_output_wgt            (wgt_data), 
                        .main_output_bias           (bias_data));
    // PE array
    PE_ARR            #(.INPUT_IFM_WIDTH            (IFM_DATA_WIDTH),
                        .INPUT_WGT_WIDTH            (WGT_DATA_WIDTH),
                        .INPUT_BIAS_WIDTH           (BIAS_DATA_WIDTH), 
                        .PAR_WIDTH                  (PARTIAL_WIDTH),   
                        .OUTPUT_WIDTH               (PE_OUTPUT_WIDTH),
                        .PE_ARR_SIZE                (PE_ARR_SIZE)   
                       )            
            pe_array   (.clk                        (clk), 
                        .rst_n                      (rst_n), 
                        .ready_load                 (ready_load),
                        .bias_input                 (bias_data), 
                        .ifm_input                  (ifm_data), 
                        .wgt_input                  (wgt_data), 
                        .ofm_output                 (ofm_data_from_pe_to_act),
                        .ready_activation           (ready_activation)
                       );   
    // Quantization and activation function RELU
    ACTIVATION        #(.INPUT_WIDTH                (PE_OUTPUT_WIDTH),
                        .OUTPUT_WIDTH               (OUTPUT_OFM_WIDTH)
                       )
            activation (.clk                        (clk), 
                        .rst_n                      (rst_n), 
                        .ready_activation           (ready_activation),
                        .act_input                  (ofm_data_from_pe_to_act), 
                        .act_output                 (ofm_data_act_buf),
                        .ready_write                (ready_write_from_act)
                       );  
    // Max pooling layer
    MAX_POOLING       #(.INPUT_WIDTH                (REGISTER_WIDTH),
                        .OUTPUT_WIDTH               (OUTPUT_OFM_WIDTH),
                        .POOL_SIZE                  (POOL_SIZE)
                       )
            max_pooling(.clk                        (clk), 
                        .rst_n                      (rst_n), 
                        .pooling_signal             (pooling_signal),
                        .ifm_input                  (data_in_max_pooling), 
                        .ifm_output                 (ofm_data_pool_buf),
                        .ready_write                (ready_write_from_pooling)
                       );        
    // Output buffer

    OFM_BUF           #(.INPUT_WIDTH                (OUTPUT_OFM_WIDTH),
                        .OUTPUT_WIDTH               (REGISTER_WIDTH)
                       ) 
            ofm_buffer (.clk                        (clk), 
                        .rst_n                      (rst_n), 
                        .sel                        (layer_signal),
                        .ready_write                (write_signal),
                        .input_activation           (ofm_data_act_buf),
                        .input_pooling              (ofm_data_pool_buf), 
                        .ofm_output                 (ofm_output),
                        .finish                     (finish),
                        .flag_full_data_reg_output  (flag_full_data_reg_output)
                       );
    
endmodule
