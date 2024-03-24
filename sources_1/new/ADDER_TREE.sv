`timescale 1ns / 1ps

module ADDER_TREE #(parameter INPUT_WIDTH = 20,
                              OUTPUT_WIDTH = 20,
                              PE_arr_size = 9)
                              
                   (clk, rst_n, ready_adder, bias_input, ofm_output, product_input);

    input clk, rst_n, ready_adder; 
    
    input signed bias_input;      
    input signed [INPUT_WIDTH-1:0] product_input [PE_arr_size-1:0];
    
    output reg signed [OUTPUT_WIDTH-1:0] ofm_output;
    
    reg signed [OUTPUT_WIDTH-1:0] p_sum [PE_arr_size-2:0];
        
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ofm_output <= 0;
        end else begin
            if (ready_adder) begin
                p_sum[0] <= product_input[0] + product_input[1];
                p_sum[1] <= product_input[2] + product_input[3];
                p_sum[2] <= product_input[4] + product_input[5];
                p_sum[3] <= product_input[6] + product_input[7];
                p_sum[4] <= product_input[8] + bias_input;
                p_sum[5] <= p_sum[0] + p_sum[1];
                p_sum[6] <= p_sum[2] + p_sum[3];
                p_sum[7] <= p_sum[4] + p_sum[5];
                ofm_output <= p_sum[6] + p_sum[7];
            end else begin
                ofm_output <= ofm_output;
            end
        end      
    end
    
endmodule