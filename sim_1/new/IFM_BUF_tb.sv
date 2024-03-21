`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2024 11:34:51 PM
// Design Name: 
// Module Name: IFM_BUF_tb
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


module IFM_BUF_tb #(parameter input_width  = 32,
                           output_width = 8,
                           
                           input_reg    = 3,                           
                           PE_arr_size  = 9,
                           POOL_SIZE    = 2*2,
                           
                           ALL          = 3'b111,
                           RIGHT        = 3'b001,
                           DOWN         = 3'b010,
                           LEFT         = 3'b100,
                           NO_CHANGE    = 3'b101,
                           
                           CONVOLUTION  = 2'b01,
                           POOLING      = 2'b10,
                           FULLY        = 2'b11,
                           NONE         = 2'b00);
    reg clk, rst_n;
    reg [1:0] layer_type;                    
    reg signed [input_width-1:0] ifm_input [input_reg-1:0];
                                                     
    wire signed [output_width-1:0] ifm_output [PE_arr_size-1:0];
    
    IFM_BUF dut(.clk(clk), .rst_n(rst_n), .layer_type(layer_type), .ifm_input(ifm_input), .ifm_output(ifm_output));
                
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        #15;
        rst_n = 1;        
        #10;
        
        #10;        
        
        #10;        
        
        #10 $finish;
    end
endmodule
