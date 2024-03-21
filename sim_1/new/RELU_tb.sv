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

// `include "RELU.sv"

// ** MODULE TESTBENCH JUST CHECK RELU ACTIVATION **
module RELU_tb;

    // Parameters
    parameter       INPUT_WIDTH         = 20;
    parameter       OUTPUT_WIDTH        = 20;


    // I/O
    logic                               clk;
    logic                               rst_n;
    logic signed    [INPUT_WIDTH-1:0]   input_relu;
    logic           [OUTPUT_WIDTH-1:0]  output_relu;

    // Connection
    RELU           #(.INPUT_WIDTH       (INPUT_WIDTH),
                     .OUTPUT_WIDTH      (OUTPUT_WIDTH)
                    )
                 dut(.clk               (clk),
                     .rst_n             (rst_n),
                     .input_relu        (input_relu),
                     .output_relu       (output_relu)
                    );
    
    // Initial values
    initial clk = 0;
    always #5 clk = ~clk;
    
    integer i;
    
    // Begin test
    initial begin
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
        // Test random
        repeat(100) begin
            input_relu = $random;
            rst_n = $random;
            #20 $display("Input: %b, Rst_n: %b, Output: %b", input_relu, rst_n, output_relu);
            rst_n = 1;
        end   
        // Test x or z
            input_relu = 20'bxxxx1xxxxxxxx1x10010;
            rst_n = 1;
            #20 $display("Input: %b, Rst_n: %b, Output: %b", input_relu, rst_n, output_relu);   
            input_relu = 20'bz1011x1z01z01zx10010;
            rst_n = 1;
            #20 $display("Input: %b, Rst_n: %b, Output: %b", input_relu, rst_n, output_relu);         
        #10 $finish;
    end


    // --- Dump file ---
    // initial 
    // begin
    //     $dumpfile("test.vcd");
	//     $dumpvars(0);
    // end
    
endmodule
