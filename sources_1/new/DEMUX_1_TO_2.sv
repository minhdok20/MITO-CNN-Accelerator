`timescale 1ns / 1ps

module DEMUX_1_TO_2 #(parameter INPUT_WIDTH   = 32,
                                OUTPUT_WIDTH  = 32,
                      
                                FULLY_CONVOL    = 1'b0,
                                MAX_POOLING     = 1'b1)
    
                     (clk, rst_n, sel, demux_input, demux_output_main_buf, demux_output_max_pooling);
                     
    input clk, rst_n;
    input sel;
    input [INPUT_WIDTH-1:0] demux_input;
    
    output reg [OUTPUT_WIDTH-1:0] demux_output_main_buf;
    output reg [OUTPUT_WIDTH-1:0] demux_output_max_pooling;
    
    integer i;
    
    always_comb begin
        case (sel)
            FULLY_CONVOL: begin
                demux_output_main_buf = demux_input;
                demux_output_max_pooling = 0;
            end
            
            MAX_POOLING: begin
                demux_output_main_buf = 0;
                demux_output_max_pooling = demux_input;
            end
            
            default: begin
                demux_output_main_buf = 0;
                demux_output_max_pooling = 0;
            end
        endcase
    end
endmodule
