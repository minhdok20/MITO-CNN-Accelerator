`timescale 1ns / 1ps

module MAIN_BUF #(parameter INPUT_WIDTH = 32,
                            OUTPUT_WIDTH = 8,
                            
                            NUM_OF_OUTPUTS = 9)

                 (clk, rst_n, signal, respond, main_input, main_output_ifm, main_output_wgt, main_output_bias);

    input clk, rst_n, signal, respond;
    input signed [INPUT_WIDTH-1:0] main_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] main_output_ifm [NUM_OF_OUTPUTS-1:0];
    output reg signed [OUTPUT_WIDTH-1:0] main_output_wgt [NUM_OF_OUTPUTS-1:0];
    output reg signed [OUTPUT_WIDTH-1:0] main_output_bias;
    
    
    wire [INPUT_WIDTH-1:0] wire_ifm;
    wire [INPUT_WIDTH-1:0] wire_wgt;
    wire [INPUT_WIDTH-1:0] wire_bias;
            
    DEMUX_1_TO_3 demux1 (.clk(clk), .rst_n(rst_n), .sel(signal), .demux_input(ifm_input), .demux_output_ifm(wire_ifm), .demux_output_wgt(wire_wgt), .demux_output_bias(wire_bias));

    IFM_BUF ifmBuf (.clk(clk), .rst_n(rst_n), .valid_read(valid_read), .ifm_input(wire_ifm), .ifm_output(main_output_ifm));
    WGT_BUF wgtBuf (.clk(clk), .rst_n(rst_n), .valid_read(valid_read), .wgt_input(wire_wgt), .wgt_output(main_output_wgt));
    BIAS_BUF biasBuf (.clk(clk), .rst_n(rst_n), .valid_read(valid_read), .bias_input(wire_bias), .bias_output(main_output_bias));
endmodule