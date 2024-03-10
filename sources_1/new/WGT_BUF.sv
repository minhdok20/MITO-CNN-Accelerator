`timescale 1ns / 1ps

module WGT_BUF#(parameter output_width  = 8,
                          input_width   = 32,
                          PE_array_size = 9)
                          
               (clk, rst_n, wgt_read, wgt_input, wgt_output);
               
    input clk, rst_n, wgt_read;
    input signed [input_width-1:0] wgt_input [2:0];
    
    output reg signed [output_width-1:0] wgt_output [PE_array_size-1:0];
   
    integer i;
   
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i=0; i<PE_array_size; i++) begin
                wgt_output[i] <= 0;
            end
        end else begin
            if(wgt_read) begin
                for (i=0; i<PE_array_size/3; i++) begin
                    wgt_output[i*3]     <= wgt_input[i][23:16];
                    wgt_output[i*3+1]   <= wgt_input[i][15:8];
                    wgt_output[i*3+2]   <= wgt_input[i][7:0];
                end
            end else begin
                for (i=0; i<PE_array_size; i++) begin
                    wgt_output[i] <= wgt_output[i];
                end
            end
        end
    end
    
endmodule