`timescale 1ns / 1ps

module RELU #(parameter data_width = 20)

             (clk, rst_n, input_relu, output_relu);
    
    input clk, rst_n;
    input signed [data_width-1:0] input_relu;
    output reg signed [data_width-1:0] output_relu;
    
    reg [data_width-1:0] buf_relu;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_relu <= 0;
        end else begin
            output_relu <= buf_relu;
        end
    end
    
    always_comb begin
        if (input_relu === 1'bz || input_relu === 1'bx) begin
            buf_relu = 0;
        end else begin
            buf_relu = (input_relu[data_width-1] == 0) ? input_relu : 0;
        end
    end
            
endmodule
