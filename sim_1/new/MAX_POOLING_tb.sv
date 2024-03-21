`timescale 1ns / 1ps


// ** MODULE TESTBENCH JUST TEST MAX POOLING MODULE **

// `include "MAX_POOLING.sv"

module MAX_POOLING_tb;

    // Parameters
    parameter     INPUT_WIDTH           = 20;
    parameter     OUTPUT_WIDTH          = 20;
    parameter     POOL_SIZE             = 2*2;

    // I/O  
    reg                                 clk;
    reg                                 rst_n;
    reg signed   [INPUT_WIDTH-1:0]      ifm_input       [POOL_SIZE-1:0];
    wire signed  [OUTPUT_WIDTH-1:0]     ifm_output;
    
    // Addition variables
    integer                             i;

    // Connection
    MAX_POOLING #(.INPUT_WIDTH          (INPUT_WIDTH),
                  .OUTPUT_WIDTH         (OUTPUT_WIDTH),
                  .POOL_SIZE            (POOL_SIZE))
              dut(.clk                  (clk),
                  .rst_n                (rst_n),
                  .ifm_input            (ifm_input),
                  .ifm_output           (ifm_output)
                 );
    
    // Initial values
    initial begin
        clk = 0;
        rst_n = 1;
    end
    always #5 clk = ~clk;
    
    // Begin test
    initial begin
        #10;   
        repeat(50) begin
            $display("TESTCASE!");     
            for (i=0; i<POOL_SIZE; i++) begin
                ifm_input[i] = $random;
                $display("i = %0d: Input : %d", i, ifm_input[i]); 
            end
            #100 $display("Output:        %d", ifm_output);
        end
        #100 $finish;
    end

    // --- Dump file ---
    // initial 
    // begin
    //     $dumpfile("test.vcd");
	//     $dumpvars(0);
    // end
endmodule
