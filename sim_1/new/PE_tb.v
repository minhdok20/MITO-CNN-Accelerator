`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2024 02:11:08 PM
// Design Name: 
// Module Name: PE_tb
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


module PE_tb #(parameter input_width    = 8,
                         output_width   = 16);
              
    reg clk;
    reg rst_n;
    
    reg [input_width-1:0] ifm_input;
    reg [input_width-1:0] wgt_input;
    
    wire [output_width-1:0] product_output;
    
    PE dut (.clk(clk), .rst_n(rst_n), .ifm_input(ifm_input), .wgt_input(wgt_input), .product_output(product_output));
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        
        #6;
        rst_n = 1;
        ifm_input = 1;
        wgt_input = 2;
        #10;
        ifm_input = 2;
        wgt_input = 3;
        #10;
        ifm_input = 3;
        wgt_input = 4;
        #10;
        ifm_input = 4;
        wgt_input = 5;
        #10;
        ifm_input = 5;
        wgt_input = 6;
        #10;
        ifm_input = 6;
        wgt_input = 7;
        #10;
        ifm_input = 7;
        wgt_input = 8;
        #10;
        ifm_input = 8;
        wgt_input = 9;
        
        #20 $finish;
    end
    
endmodule
