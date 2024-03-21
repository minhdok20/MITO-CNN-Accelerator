`timescale 1ns / 1ps

module CONTROLLER_tb;

    parameter CONVOLUTION   = 2'b01,
              POOLING       = 2'b10,
              FULLY         = 2'b11,
              NONE          = 2'b00;
              
    reg clk, rst_n, start, ofm_valid;
    
    wire [1:0] layer_type;
    
    CONTROLLER dut(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .ofm_valid(ofm_valid),
        .layer_type(layer_type)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 1;
        start = 0;
        ofm_valid = 0;
        #10;   
        rst_n = 0;
        #5;
        start = 1;
        #7;
        start = 0;
        #20;
        rst_n = 1;
        #3;
        start = 1;
        #13;
        ofm_valid = 1;
        #100 $finish;
    end

endmodule
