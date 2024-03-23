`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 01:20:23 PM
// Design Name: 
// Module Name: ACTIVATION_tb
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

// ** MODULE TESTBENCH JUST TEST QUANTIZATION AND RELU **
module ACTIVATION_tb;

    // Parameters
    parameter        INPUT_WIDTH        = 32;
    parameter        OUTPUT_WIDTH       = 8;

    // I/O
    logic                               clk;
    logic                               rst_n;
    logic signed    [INPUT_WIDTH-1:0]   ofm_input;
    logic signed    [OUTPUT_WIDTH-1:0]  ofm_output;

    // Additional variables
    int                                 counter;

    // Connection
    ACTIVATION     #(.INPUT_WIDTH       (INPUT_WIDTH),
                     .OUTPUT_WIDTH      (OUTPUT_WIDTH)
                    )
            activate(.clk               (clk),
                     .rst_n             (rst_n),
                     .ofm_input         (ofm_input),
                     .ofm_output        (ofm_output)
                    );

    // Initial values
    initial 
    begin
        clk = 1;
        rst_n = 0;
    end
    always clk = #5 ~clk;

    // Begin test
    initial begin
        #5 rst_n = 1;
        repeat (100) begin
            $display("TESTCASE %0d!", counter++);
            ofm_input = $random;
            #10;
            $display("Input:  %d - %h", ofm_input, ofm_input);
            $display("Output:        %d - %h", ofm_output, ofm_output);
        end

        $display("TESTCASE %0d!", counter++);
        ofm_input = 32'h8000x000;
        #10;
        $display("Input:  %d - %h", ofm_input, ofm_input);
        $display("Output:        %d - %h", ofm_output, ofm_output);


        $display("TESTCASE %0d!", counter++);
        ofm_input = 32'h0FFz0ABC;
        #10;
        $display("Input:  %d - %h", ofm_input, ofm_input);
        $display("Output:        %d - %h", ofm_output, ofm_output);

        #10 $finish;
    end

endmodule
