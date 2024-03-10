`timescale 1ns / 1ps

module OFM_BUF#(parameter input_width   = 8, 
                          output_width  = 8)
                          
               (clk, rst_n, ofm_input, ofm_output);

    input clk, rst_n;
    input [7:0] ofm_input;
    
    output [7:0] ofm_output;
    
    reg [7:0] ofm_buf;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ofm_buf <= 0;
        end else begin
            ofm_buf <= ofm_input;
        end
    end
    
    assign ofm_output = ofm_buf;

endmodule