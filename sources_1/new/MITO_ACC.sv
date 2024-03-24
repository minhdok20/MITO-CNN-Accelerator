`timescale 1ns / 1ps

module MITO_ACC #(parameter INPUT_WIDTH         = 32,
                            OUTPUT_WIDTH        = 32,
                            
                            ifm_output_width    = 8,
                            wgt_output_width    = 8,
                            bias_width          = 8,
                            ofm_output_width    = 8,
                            
                            PE_array_size       = 9,
                            pool_size           = 2*2,
                            
                            CONVOL              = 2'b01,
                            FULLY               = 2'b10,
                            POOL                = 2'b11)
                            
                 (clk, rst_n, MITO_input, MITO_output);

    input clk, rst_n;    
    input signed [INPUT_WIDTH-1:0] MITO_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] MITO_output;
    
    wire signed [INPUT_WIDTH-1:0] ifm_input_wire;
    wire signed [INPUT_WIDTH-1:0] wgt_input_wire;
    wire signed [INPUT_WIDTH-1:0] bias_input_wire;
    
        
    wire wgt_read;
    wire bias_read;
    wire [1:0] mode;
    wire [1:0] layer_type;
    wire [1:0] sel;
    
//    CONTROLLER controller   (.clk(clk), .rst_n(rst_n), .start(start), .ifm_read(ifm_read), .wgt_read(wgt_read), .bias_read(bias_read), .layer_type());
    
//    DEMUX_1_TO_3 demux1     (.clk(clk), .rst_n(rst_n), .sel(sel), .main_input(MITO_input), .main_output({bias_input_wire, wgt_input_wire, ifm_input_wire}))
    
    IFM_BUF ifm_buffer      (.clk(clk), .rst_n(rst_n), .ifm_read(ifm_read), .ifm_input(ifm_input), .ifm_output(ifm_wire));
    WGT_BUF wgt_buffer      (.clk(clk), .rst_n(rst_n), .wgt_input(wgt_input), .wgt_output(wgt_wire));
    BIAS_BUF bias_buffer    (.clk(clk), .rst_n(rst_n), .bias_read(bias_read), .bias_input(bias_input), .bias_output(bias_wire));
    
    PE_ARR pe_array         (.clk(clk), .rst_n(rst_n), .bias_input(bias_wire), .ifm_input(ifm_wire), .wgt_input(wgt_wire), .ofm_output(ofm_wire_relu_in));
    
    RELU relu               (.clk(clk), .rst_n(rst_n), .input_relu(ofm_wire_relu_in), .output_relu(ofm_wire_relu_out));
    
//    MAX_POOLING max_pooling (.clk(clk), .rst_n(rst_n), .ifm_input(ifm_wire[pool_size-1:0]), .ifm_output(ofm_wire_pool_out));
    
//    assign ofm_wire_buf = (mode == POOL) ? ofm_wire_pool_out : ofm_wire_relu_out;   
    
    OFM_BUF ofm_buffer      (.clk(clk), .rst_n(rst_n), .ofm_input(ofm_wire_buf), .ofm_output(ofm_output));
    
endmodule
