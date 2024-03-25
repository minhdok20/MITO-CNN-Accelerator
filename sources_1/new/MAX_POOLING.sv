`timescale 1ns / 1ps

module MAX_POOLING #(parameter INPUT_WIDTH  = 32,
                               OUTPUT_WIDTH = 8,
                               POOL_SIZE    = 2*2)
                               
                    (clk, rst_n, ifm_input, ifm_output);
                    
    input clk, rst_n;
    input signed [INPUT_WIDTH-1:0] ifm_input;
    
    reg signed [OUTPUT_WIDTH-1:0] buffer [POOL_SIZE-1:0];
    
    output reg signed [OUTPUT_WIDTH-1:0] ifm_output;
    
    genvar i;
    
    for (i=0; i<POOL_SIZE-1; i++) begin
        if (i==0) begin
            COLLATIONER compare (.clk(clk), .rst_n(rst_n), .ifm_input0(ifm_input[0]), .ifm_input1(ifm_input[1]), .ifm_output(buffer[0]));
        end else begin
            COLLATIONER compare (.clk(clk), .rst_n(rst_n), .ifm_input0(buffer[i-1]), .ifm_input1(ifm_input[i+1]), .ifm_output(buffer[i]));
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ifm_output <= 0;
        end else begin
            ifm_output <= buffer[POOL_SIZE-2];
        end
    end   
    
endmodule