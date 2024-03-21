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

// ** FILE TESTBENCH JUST TEST FUNCTION OF PE BLOCK **

// `include "PE.sv"

module PE_tb   #(parameter              INPUT_IFM_WIDTH     = 8,
                                        INPUT_WGT_WIDTH     = 8,
                                        OUTPUT_WIDTH        = 16
                );

    // --- I/O ---          
    reg                                 clk;
    reg                                 rst_n;
    reg signed  [INPUT_IFM_WIDTH-1:0]   ifm_input;
    reg signed  [INPUT_WGT_WIDTH-1:0]   wgt_input;
    wire signed [OUTPUT_WIDTH-1:0]      product_output;

    // --- Additional variables ---
    reg signed  [OUTPUT_WIDTH-1:0]      predict_output;
    int                                 counter;
    
    // --- Connect to design module PE ---
    PE         #(.INPUT_IFM_WIDTH       (INPUT_IFM_WIDTH),
                 .INPUT_WGT_WIDTH       (INPUT_WGT_WIDTH),
                 .OUTPUT_WIDTH          (OUTPUT_WIDTH)
                )
            dut (.clk                   (clk), 
                 .rst_n                 (rst_n), 
                 .ifm_input             (ifm_input), 
                 .wgt_input             (wgt_input), 
                 .product_output        (product_output)
                );

    // --- Task: Display on monitor ---
    task    display_test();
        counter++;
        $display("[TESTCASE: %0d] [Time: %t] Input fearure map -     %d, Weight input -      %d", counter, $realtime, ifm_input, wgt_input);
        #10;
        predict_output = ifm_input * wgt_input;
        $display("[TESTCASE: %0d] [Time: %t] Expected output   -   %d, Actual output -   %d", counter, $realtime, predict_output, product_output);
        if (product_output === predict_output)
            $display("PASSED!");
        else
        begin
            $display("FAILED!");
            $finish;
        end
    endtask    

    // --- Initial signals ---
    initial 
    begin
        clk = 1;
        rst_n = 0;
    end
    always #5 clk = ~clk;

    // --- Begin test ---
    initial 
    begin
        // Reset time
        #5;
        rst_n = 1;
        // Testcases: Sanity 0 -> 10
        for (int i = 0; i <= 10; i++) 
        begin
            ifm_input = i;
            wgt_input = i;
            display_test();
        end
        // Testcases: Random unsigned values
        repeat (20) 
        begin
            ifm_input = $urandom();
            wgt_input = $urandom();
            display_test();
        end
        // Testcases: Random signed values
        repeat (100) 
        begin
            ifm_input = $random();
            wgt_input = $random();
            display_test();
        end
        // Testcases: X or Z values
            ifm_input = 'bx;
            wgt_input = $random();
            display_test();            
            ifm_input = 'bz;
            wgt_input = $random();
            display_test();            
            ifm_input = $random();
            wgt_input = 'bx;
            display_test(); 
            ifm_input = $random();
            wgt_input = 'bz;
            display_test();            
            ifm_input = 'bx;
            wgt_input = 'bz;
            display_test();   
        // End test         
        #20 $finish;
    end
    
    // --- Dump file ---
    // initial 
    // begin
    //     $dumpfile("test.vcd");
	//     $dumpvars(0);
    // end
endmodule