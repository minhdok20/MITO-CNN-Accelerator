`timescale 1ns / 1ps

module MAX_POOLING_tb;

    parameter input_width  = 20,
              output_width = 20,
              pool_size    = 4;
              
    reg clk, rst_n;
    reg [input_width-1:0] ifm_input [pool_size-1:0];
    
    wire [output_width-1:0] ifm_output;
    
    MAX_POOLING #(.input_width (input_width),
             .output_width (output_width),
             .pool_size (pool_size))
    dut(
        .clk (clk),
        .rst_n (rst_n),
        .ifm_input (ifm_input),
        .ifm_output (ifm_output)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    integer i;
    
    initial begin
        rst_n = 1;
        #10;
        for (i=0; i<pool_size; i++) begin
            ifm_input[i] = $urandom_range($time*100);
        end
        #100 $finish;
    end
endmodule
