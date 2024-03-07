`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 09:29:39 PM
// Design Name: 
// Module Name: RELU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RELU_tb;

    parameter data_width = 20;
              
    reg clk, rst_n;
    reg signed [data_width-1:0] input_relu;
    
    wire [data_width-1:0] output_relu;
    
    RELU #(.data_width(data_width))
    dut(
        .clk (clk),
        .rst_n (rst_n),
        .input_relu (input_relu),
        .output_relu (output_relu)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    integer i;
    
    initial begin
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
        for (i=0; i<100; i++) begin
            input_relu = $urandom_range($time*100);
        end
        #100 $finish;
    end
endmodule
