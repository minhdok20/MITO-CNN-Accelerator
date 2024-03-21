`timescale 1ns / 1ps

// ** MODULE TESTBENCH JUST TEST ADDER TREE DESIGN MODULE **
// `include "ADDER_TREE.sv"

module ADDER_TREE_tb;
    parameter                           INPUT_WIDTH         = 16;
    parameter                           INPUT_BIAS_WIDTH    = 8;
    parameter                           OUTPUT_WIDTH        = 20;
    parameter                           PE_ARR_SIZE         = 9;


    // --- I/O ---
    reg                                 clk;
    reg                                 rst_n;
    reg signed  [INPUT_BIAS_WIDTH-1:0]  bias_input;
    reg signed  [INPUT_WIDTH-1:0]       product_input       [PE_ARR_SIZE-1:0];
    wire signed [OUTPUT_WIDTH-1:0]      ofm_output;
    
    // --- Additional variables ---
    int                                 counter;

    // --- Connect to design module ADDER_TREE ---
    ADDER_TREE     #(.INPUT_WIDTH       (INPUT_WIDTH),
                     .INPUT_BIAS_WIDTH  (INPUT_BIAS_WIDTH),
                     .OUTPUT_WIDTH      (OUTPUT_WIDTH),
                     .PE_ARR_SIZE       (PE_ARR_SIZE)
                    )
                dut (.clk               (clk), 
                     .rst_n             (rst_n), 
                     .bias_input        (bias_input), 
                     .product_input     (product_input),
                     .ofm_output        (ofm_output)
                    );

    // --- Task: Display on monitor ---
    task    display_test();
        counter++;
        $display("[TESTCASE: %d]", counter);
        $display("[Time: %t] Bias input        -     %d", $realtime, bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
            $display("[Time: %t] Product input [%0d] -   %d", $realtime, i, product_input[i]);
        #40;
        $display("[Time: %t] Output            - %d", $realtime, ofm_output);
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
        #1 rst_n = 1;

        // Testcase: Sanity test - Expect value: 46 
        bias_input = 1;
            $display("Bias input       : -     %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            product_input[i] = i+1;
            $display("Product input [%0d]: - %d", i, product_input[i]);
        end
        #44;
        $display("Result of testcase: %d", ofm_output);
        if (ofm_output != 46)
        begin
            $display("SANITY TEST FAILED!");
            $finish;
        end
        else
            $display("SANITY TEST PASSED!");

        // Testcases: Random unsigned values       
        #10;
        repeat(20) 
        begin
            bias_input = $urandom();
            for (int i = 0; i < PE_ARR_SIZE; i++) 
                product_input[i] = $urandom();
            display_test();
        end

        // Testcases: Random signed values       
        #10;
        repeat(50) 
        begin
            bias_input = $random();
            for (int i = 0; i < PE_ARR_SIZE; i++) 
                product_input[i] = $random();
            display_test();
        end

        // Testcases: Random reset       
        #10;
        repeat(10) 
        begin
            bias_input = $random();
            rst_n = $random;
            for (int i = 0; i < PE_ARR_SIZE; i++) 
                product_input[i] = $random();
            display_test();
        end

        // Testcases: X or Z values - Expected value: Don't care   
        rst_n = 1;
        #10;
        bias_input = 'bx;
        for (int i = 0; i < PE_ARR_SIZE; i++) 
            product_input[i] = $random();
        display_test();
        if (ofm_output !== 'bx)
        begin
            $display("FAILED!");
            $finish;
        end
        else
            $display("PASSED!");
        bias_input = 'bz;
        for (int i = 0; i < PE_ARR_SIZE; i++) 
            product_input[i] = $random();
        display_test();
        if (ofm_output !== 'bx)
        begin
            $display("FAILED!");
            $finish;
        end
        else
            $display("PASSED!");
        bias_input = $random;
        for (int i = 0; i < PE_ARR_SIZE; i++) 
            product_input[i] = 'bx;
        display_test();
        if (ofm_output !== 'bx)
        begin
            $display("FAILED!");
            $finish;
        end
        else
            $display("PASSED!");
        bias_input = $random;
        for (int i = 0; i < PE_ARR_SIZE; i++) 
            product_input[i] = 'bz;
        display_test();
        if (ofm_output !== 'bx)
        begin
            $display("FAILED!");
            $finish;
        end
        else
            $display("PASSED!");

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
