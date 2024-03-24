`timescale 1ns / 1ps

module DEMUX_1_TO_3 #(parameter INPUT_WIDTH   = 32,
                                OUTPUT_WIDTH  = 32,
                      
                                IFM           = 2'b01,
                                WGT           = 2'b10,
                                BIAS          = 2'b11)
    
                     (clk, rst_n, sel, demux_input, demux_output_ifm, demux_output_wgt, demux_output_bias);
                     
    input clk, rst_n;
    input [1:0] sel;
    input [INPUT_WIDTH-1:0] demux_input;
    
    output reg [OUTPUT_WIDTH-1:0] demux_output_ifm;
    output reg [OUTPUT_WIDTH-1:0] demux_output_wgt;
    output reg [OUTPUT_WIDTH-1:0] demux_output_bias;
    
    integer i;
    
    always_comb begin
        case (sel)
            IFM: begin
                demux_output_ifm = demux_input;
                demux_output_wgt = 0;
                demux_output_bias = 0;
            end
            
            WGT: begin
                demux_output_ifm = 0;
                demux_output_wgt = demux_input;
                demux_output_bias = 0;
            end
            
            BIAS: begin
                demux_output_ifm = 0;
                demux_output_wgt = 0;
                demux_output_bias = demux_input;
            end
            
            default: begin
                demux_output_ifm = 0;
                demux_output_wgt = 0;
                demux_output_bias = 0;
            end
        endcase
    end
endmodule
