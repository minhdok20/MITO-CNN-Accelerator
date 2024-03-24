`timescale 1ns / 1ps

module MITO_ACC #(parameter INPUT_WIDTH         = 32,
                            OUTPUT_WIDTH        = 32,
                            
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
                            
                 (clk, rst_n, start, MITO_input, MITO_output);

    input clk, rst_n, start;    
    input signed [INPUT_WIDTH-1:0] MITO_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] MITO_output;
    
    wire signed [INPUT_WIDTH-1:0] wire_out_ifm [NUM_OF_OUTPUTS-1:0];
    wire signed [INPUT_WIDTH-1:0] wire_out_wgt [NUM_OF_OUTPUTS-1:0];
    wire signed [INPUT_WIDTH-1:0] wire_out_bias;
    
    wire start_signal;
    wire ready_load;
    
    wire [1:0] mode;
    wire [1:0] sel;
    
    CONTROLLER controller   (.clk(clk), .rst_n(rst_n), .start(start), .start_signal(start_signal));
    
    MAIN_BUF mainBuf       (.clk(clk), .rst_n(rst_n), .start_signal(start_signal), .ready_load(ready_load), .main_input(MITO_input), .main_output_ifm(wire_out_ifm), .main_output_wgt(wire_out_wgt), .main_output_bias(wire_out_bias));
    
    
    
    PE_ARR pe_array         (.clk(clk), .rst_n(rst_n), .bias_input(bias_wire), .ifm_input(ifm_wire), .wgt_input(wgt_wire), .ofm_output(ofm_wire_relu_in));
    
    RELU relu               (.clk(clk), .rst_n(rst_n), .input_relu(ofm_wire_relu_in), .output_relu(ofm_wire_relu_out));
    
//    MAX_POOLING max_pooling (.clk(clk), .rst_n(rst_n), .ifm_input(ifm_wire[pool_size-1:0]), .ifm_output(ofm_wire_pool_out));
    
//    assign ofm_wire_buf = (mode == POOL) ? ofm_wire_pool_out : ofm_wire_relu_out;   
    
    OFM_BUF ofm_buffer      (.clk(clk), .rst_n(rst_n), .ofm_input(ofm_wire_buf), .ofm_output(ofm_output));
    
endmodule
