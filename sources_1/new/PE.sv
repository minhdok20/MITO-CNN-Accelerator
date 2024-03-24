`timescale 1ns / 1ps

module PE #(parameter INPUT_WIDTH   = 8, 
                      OUTPUT_WIDTH  = 20)
                      
           (clk, rst_n, ready_load, ifm_input, wgt_input, product_output, ready_adder);

    input clk, rst_n;
    
    input ready_load;
    input signed [INPUT_WIDTH-1:0] ifm_input;
    input signed [INPUT_WIDTH-1:0] wgt_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] product_output;
    output reg ready_adder;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            product_output <= 0;
            ready_adder <= 0;
        end else begin
            if (ready_load) begin
                product_output <= ifm_input * wgt_input;
                ready_adder <= 1;
            end else begin
                product_output <= product_output;
                ready_adder <= 0;
            end
        end
    end
    
endmodule