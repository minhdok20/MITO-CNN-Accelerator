`timescale 1ns / 1ps

module WGT_BUF#(parameter OUTPUT_WIDTH  = 8,
                          INPUT_WIDTH   = 32,
                          NUM_OF_OUTPUTS = 9)
                          
               (clk, rst_n, valid_read, wgt_input, wgt_output);
               
    input clk, rst_n, valid_read;
    input signed [INPUT_WIDTH-1:0] wgt_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] wgt_output [NUM_OF_OUTPUTS-1:0];
    
    reg [7:0] counter;
    reg [7:0] next_counter;
   
    integer i;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            counter <= next_counter;
        end
    end
   
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i=0; i<NUM_OF_OUTPUTS; i++) begin
                wgt_output[i] <= 0;
            end
        end else begin
            if(valid_read) begin
                if (counter <= 0) begin
                    next_counter <= counter + 1;
                    wgt_output[0] <= wgt_input[23:16];
                    wgt_output[3] <= wgt_input[15:8];
                    wgt_output[6] <= wgt_input[7:0];
                end else if (counter <= 1) begin
                    next_counter <= counter + 1;
                    wgt_output[1] <= wgt_input[23:16];
                    wgt_output[4] <= wgt_input[15:8];
                    wgt_output[7] <= wgt_input[7:0];
                end else if (counter <= 2) begin
                    next_counter <= 0;
                    wgt_output[2] <= wgt_input[23:16];
                    wgt_output[5] <= wgt_input[15:8];
                    wgt_output[8] <= wgt_input[7:0];
                end
            end else begin
                for (i=0; i<NUM_OF_OUTPUTS; i++) begin
                    wgt_output[i] <= wgt_output[i];
                end
            end
        end
    end
    
endmodule