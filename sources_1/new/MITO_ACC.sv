`timescale 1ns / 1ps

module MITO_ACC #(parameter INPUT_WIDTH         = 32,
                            OUTPUT_WIDTH        = 32,
                            
                            DATA_WIDTH          = 8,
                            
                            ifm_output_width    = 8,
                            wgt_output_width    = 8,
                            bias_width          = 8,
                            ofm_output_width    = 8,
                            
                            PE_array_size       = 9,
                            NUM_OF_OUTPUTS      = 9,
                            pool_size           = 2*2,
                            
                            CONVOL              = 2'b01,
                            FULLY               = 2'b10,
                            POOL                = 2'b11)
                            
                 (clk, rst_n, instruction_signal, MITO_input, MITO_output, ready_finish);

    input clk, rst_n;
    input [INPUT_WIDTH-1:0] instruction_signal;    
    input signed [INPUT_WIDTH-1:0] MITO_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] MITO_output;
    output reg ready_finish;
    
    wire signed [INPUT_WIDTH-1:0] wire_in_main_buf;
    wire [INPUT_WIDTH-1:0] wire_in_max_pooling;
    
    wire signed [DATA_WIDTH-1:0] wire_out_ifm [NUM_OF_OUTPUTS-1:0];
    wire signed [DATA_WIDTH-1:0] wire_out_wgt [NUM_OF_OUTPUTS-1:0];
    wire signed [DATA_WIDTH-1:0] wire_out_bias;
    
    wire signed [INPUT_WIDTH-1:0] wire_in_activation;
    wire [DATA_WIDTH-1:0] wire_out_activation;
    
    wire layer_signal;
    
    wire ready_load;
    wire ready_activation;
    wire ready_write;
    
    wire [1:0] mode;
    wire [1:0] sel;
    
    CONTROLLER controller   (.clk(clk), .rst_n(rst_n), .instruction_signal(instruction_signal), .layer_signal(layer_signal));
    
    DEMUX_1_TO_2 demuxLayer (.clk(clk), .rst_n(rst_n), .demux_input(MITO_input), .demux_output_main_buf(wire_in_main_buf), .demux_output_max_pooling(wire_in_max_pooling));
    
    MAIN_BUF mainBuf        (.clk(clk), .rst_n(rst_n), .start_signal(start_signal), .ready_load(ready_load), .main_input(wire_in_main_buf), .main_output_ifm(wire_out_ifm), .main_output_wgt(wire_out_wgt), .main_output_bias(wire_out_bias));

    PE_ARR peArray          (.clk(clk), .rst_n(rst_n), .ready_load(ready_load), .ifm_input(wire_out_ifm), .wgt_input(wire_out_wgt), .bias_input(wire_out_bias), .ofm_output(wire_in_activation), .ready_activation(ready_activation));
    
    ACTIVATION activation   (.clk(clk), .rst_n(rst_n), .ready_activation(ready_activation), .ofm_input(wire_in_activation), .ofm_output(wire_out_activation), .ready_write(ready_write));
    
//    MAX_POOLING maxPooling  (.clk(clk), .rst_n(rst_n), .ifm_input(ifm_wire[pool_size-1:0]), .ifm_output(ofm_wire_pool_out));
    
       
    
    OFM_BUF ofmBuf          (.clk(clk), .rst_n(rst_n), .ready_write(ready_write), .ofm_input(ofm_wire_buf), .ofm_output(ofm_output), .ready_finish(ready_finish));
    
endmodule
