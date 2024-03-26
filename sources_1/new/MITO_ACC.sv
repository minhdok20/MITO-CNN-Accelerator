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
    
    wire fully_convol_signal;
    wire pooling_signal;
    
    wire [INPUT_WIDTH-1:0] wire_in_max_pooling;
    wire [DATA_WIDTH-1:0] wire_out_max_pooling;
    
    wire signed [INPUT_WIDTH-1:0] wire_in_main_buf;    
    wire signed [DATA_WIDTH-1:0] wire_out_ifm [NUM_OF_OUTPUTS-1:0];
    wire signed [DATA_WIDTH-1:0] wire_out_wgt [NUM_OF_OUTPUTS-1:0];
    wire signed [DATA_WIDTH-1:0] wire_out_bias;
    
    wire signed [INPUT_WIDTH-1:0] wire_in_activation;
    wire [DATA_WIDTH-1:0] wire_out_activation;
    
    wire [DATA_WIDTH-1:0] wire_in_ofm;
    
    wire layer_signal;    
    
    wire ready_load;
    wire ready_activation;
    wire ready_write_from_activation;
    wire ready_write_from_pooling;
    wire write_signal;
    
    wire [1:0] mode;
    wire [1:0] sel;
    
    CONTROLLER controller   (.clk(clk), .rst_n(rst_n), .instruction_signal(instruction_signal), .layer_signal(layer_signal), .fully_convol_signal(fully_convol_signal), .pooling_signal(pooling_signal), .write_signal(write_signal));
    
    DEMUX_1_TO_2 demuxLayer (.sel(layer_signal), .demux_input(MITO_input), .demux_output_main_buf(wire_in_main_buf), .demux_output_max_pooling(wire_in_max_pooling));
    
    MAIN_BUF mainBuf        (.clk(clk), .rst_n(rst_n), .fully_convol_signal(fully_convol_signal), .ready_load(ready_load), .main_input(wire_in_main_buf), .main_output_ifm(wire_out_ifm), .main_output_wgt(wire_out_wgt), .main_output_bias(wire_out_bias));

    PE_ARR peArray          (.clk(clk), .rst_n(rst_n), .ready_load(ready_load), .ifm_input(wire_out_ifm), .wgt_input(wire_out_wgt), .bias_input(wire_out_bias), .ofm_output(wire_in_activation), .ready_activation(ready_activation));
    
    ACTIVATION activation   (.clk(clk), .rst_n(rst_n), .ready_activation(ready_activation), .ofm_input(wire_in_activation), .ofm_output(wire_out_activation), .ready_write(ready_write_from_activation));
    
    MAX_POOLING maxPooling  (.clk(clk), .rst_n(rst_n), .pooling_signal(pooling_signal), .ifm_input(wire_in_max_pooling), .ifm_output(wire_out_max_pooling), .ready_write(ready_write_from_pooling));
    
    MUX_2_TO_1 muxLayer     (.sel(layer_signal), .mux_input_activation(wire_out_activation), .mux_input_pooling(wire_out_max_pooling), .mux_output(wire_in_ofm));
    
    OFM_BUF ofmBuf          (.clk(clk), .rst_n(rst_n), .ready_write(write_signal), .ofm_input(wire_in_ofm), .ofm_output(MITO_output), .ready_finish(ready_finish));
    
endmodule
