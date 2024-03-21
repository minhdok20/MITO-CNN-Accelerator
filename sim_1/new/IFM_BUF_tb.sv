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

// ** MODULE TESTBENCH JUST TEST INPUT FEATURE MAP DESIGN MODULE ** 

// `include "IFM_BUF.sv"

module IFM_BUF_tb;

    // Parameters
    parameter       INPUT_WIDTH             = 32;
    parameter       OUTPUT_WIDTH            = 8;       
    parameter       INPUT_IFM_REG           = 3;           
    parameter       PE_ARR_SIZE             = 9;

    // I/O
    reg                                     clk;                                       
    reg                                     rst_n;                                     
    reg signed      [2:0]                   ifm_read; 
    reg signed      [1:0]                   mode;                    
    reg signed      [INPUT_WIDTH-1:0]       ifm_input       [INPUT_IFM_REG-1:0]; 
    wire signed     [OUTPUT_WIDTH-1:0]      ifm_output      [PE_ARR_SIZE-1:0];
    
    // Connection
    IFM_BUF       #(.INPUT_WIDTH            (INPUT_WIDTH),
                    .OUTPUT_WIDTH           (OUTPUT_WIDTH),
                    .INPUT_IFM_REG          (INPUT_IFM_REG),
                    .PE_ARR_SIZE            (PE_ARR_SIZE)
                   )
                dut(.clk                    (clk), 
                    .rst_n                  (rst_n), 
                    .ifm_read               (ifm_read), 
                    .mode                   (mode),
                    .ifm_input              (ifm_input),
                    .ifm_output             (ifm_output)
                   );

    // Initial values            
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Begin test
    initial begin
        rst_n = 0;
        #15;
        rst_n = 1;
        mode         = 'b 01;
        ifm_read     = 'b 111;
        ifm_input[0] = 'h 00010203;
        ifm_input[1] = 'h 00040506;
        ifm_input[2] = 'h 00070809;
        
        #10;
        ifm_read     = 'b 001;
        ifm_input[0] = 'h 000A0B0C;
        ifm_input[1] = 'h 000F0F0F;
        ifm_input[2] = 'h 000F0F0F;
        
        #10;
        ifm_read     = 'b 010;
        ifm_input[0] = 'h 000F0F0F;
        ifm_input[1] = 'h 000D0E0F;
        ifm_input[2] = 'h 000F0F0F;
        
        #10;
        ifm_read     = 'b 100;
        ifm_input[0] = 'h 000F0F0F;
        ifm_input[1] = 'h 000F0F0F;
        ifm_input[2] = 'h 000A0A0A;
        
        #10 $finish;
    end

    // --- Dump file ---
    // initial 
    // begin
    //     $dumpfile("test.vcd");
	//     $dumpvars(0);
    // end
endmodule
