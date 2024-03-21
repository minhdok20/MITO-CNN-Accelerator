`timescale 1ns / 1ps

// `include "PE_ARR.sv"

// ** MODULE TESTBENCH TEST PE ARRAY (2 DIMENSIONS) **
module PE_ARR_tb;

    // --- Parameters ---
    parameter                           INPUT_IFM_WIDTH         = 8 ;
    parameter                           INPUT_WGT_WIDTH         = 8 ;
    parameter                           INPUT_BIAS_WIDTH        = 8 ;
    parameter                           PAR_WIDTH               = 16;
    parameter                           OUTPUT_WIDTH            = 20;
    parameter                           PE_ARR_SIZE             = 9 ;
    localparam                          CLOCK_TIMER             = 10;
    localparam                          PREDICT_CLOCK           = 5 ; 
    localparam                          RAND_UNSIGNED_TEST      = 25;   
    localparam                          RAND_SIGNED_TEST        = 50;   
    localparam                          RAND_RESET_TEST         = 10;   
           
    // --- I/O --- 
    reg                                 clk;
    reg                                 rst_n;
    reg signed  [INPUT_BIAS_WIDTH-1:0]  bias_input;
    reg signed  [INPUT_IFM_WIDTH-1:0]   ifm_input               [PE_ARR_SIZE-1:0];
    reg signed  [INPUT_WGT_WIDTH-1:0]   wgt_input               [PE_ARR_SIZE-1:0];   
    wire signed [OUTPUT_WIDTH-1:0]      ofm_output;
    
    // --- Additional variables ---
    int                                 counter;
    int                                 rand_int;
    int                                 flag_rst;
    reg signed  [OUTPUT_WIDTH-1:0]      predict_output;

    // --- Connection ---
    PE_ARR     #(.INPUT_IFM_WIDTH       (INPUT_IFM_WIDTH),
                 .INPUT_WGT_WIDTH       (INPUT_WGT_WIDTH),
                 .INPUT_BIAS_WIDTH      (INPUT_BIAS_WIDTH),
                 .PAR_WIDTH             (PAR_WIDTH),
                 .OUTPUT_WIDTH          (OUTPUT_WIDTH),
                 .PE_ARR_SIZE           (PE_ARR_SIZE)
                )
             dut(.clk                   (clk),
                 .rst_n                 (rst_n),
                 .bias_input            (bias_input),
                 .ifm_input             (ifm_input),
                 .wgt_input             (wgt_input),
                 .ofm_output            (ofm_output)
                );

    // --- Task: Display and predict value ---
    task    display_and_predict();
        counter++;
        predict_output = 0;
        $display("[TESTCASE: %0d] [Time: %t]", counter, $realtime);
        $display("Bias input:      %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            $display("PE Block %0d: Input feature map - %d, Weight input - %d", i, ifm_input[i], wgt_input[i]);
            predict_output += ifm_input[i] * wgt_input[i]; 
        end
        #(PREDICT_CLOCK * CLOCK_TIMER) predict_output = (flag_rst) ? 'bx : predict_output + bias_input;
        $display("Result:     Expected value: %d, Actual value: %d", predict_output, ofm_output);
        if (predict_output !== ofm_output) 
        begin
            $display("FAILED!");
            $finish;
        end
        else 
        begin
            $display("PASSED!");
        end
    endtask    

    // --- Initial values ---
    initial 
    begin
        clk = 0;
        rst_n = 1;
    end
    always #(CLOCK_TIMER/2) clk = ~clk;
    
    
    // --- Test begin --- 
    initial 
    begin
        $display(" ---------------------------------- ");
        $display(" --- PE ARRAY: START SIMULATION --- ");
        $display(" ---------------------------------- ");
        // Testcase 1: Sanity test
        $display(" --- SANITY TEST --- ");
        bias_input = 1;
        #CLOCK_TIMER;
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            ifm_input[i] = i+1;
            wgt_input[i] = i+1;
        end
        display_and_predict();
        
        // Testcases: Random unsigned value
        $display(" --- RANDOM UNSIGNED VALUES --- ");
        repeat (RAND_UNSIGNED_TEST) 
        begin
            bias_input = $urandom;
            for (int i = 0; i < PE_ARR_SIZE; i++) 
            begin
                ifm_input[i] = $urandom;
                wgt_input[i] = $urandom;
            end
            display_and_predict(); 
        end

        // Testcases: Random signed value
        $display(" --- RANDOM SIGNED VALUES --- ");
        repeat (RAND_SIGNED_TEST) 
        begin
            bias_input = $random;
            for (int i = 0; i < PE_ARR_SIZE; i++) 
            begin
                ifm_input[i] = $random;
                wgt_input[i] = $random;
            end
            display_and_predict(); 
        end

        // Testcases: Check x or z
        $display(" --- RANDOM X OR Z --- ");
        bias_input = $random;
        $display("Bias - %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
                ifm_input[i] = $random;
                wgt_input[i] = $random;
        end
        rand_int = $urandom_range(0,PE_ARR_SIZE-1); 
        ifm_input[rand_int] = 'bx;
        display_and_predict();
            
        bias_input = $random;
        $display("Bias - %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            ifm_input[i] = $random;
            wgt_input[i] = $random;
        end  
        rand_int = $urandom_range(0,PE_ARR_SIZE-1); 
        wgt_input[rand_int] = 'bx;
        display_and_predict();

        bias_input = $random;
        $display("Bias - %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            ifm_input[i] = $random;
            wgt_input[i] = $random;
        end  
        rand_int = $urandom_range(0,PE_ARR_SIZE-1); 
        ifm_input[rand_int] = 'bz;
        display_and_predict();

        bias_input = $random;
        $display("Bias - %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            ifm_input[i] = $random;
            wgt_input[i] = $random;
        end  
        rand_int = $urandom_range(0,PE_ARR_SIZE-1); 
        wgt_input[rand_int] = 'bz;
        display_and_predict();

        bias_input = 'bx;
        $display("Bias - %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            ifm_input[i] = $random;
            wgt_input[i] = $random;
        end  
        display_and_predict();

        bias_input = 'bz;
        $display("Bias - %d", bias_input);
        for (int i = 0; i < PE_ARR_SIZE; i++) 
        begin
            ifm_input[i] = $random;
            wgt_input[i] = $random;
        end  
        display_and_predict();

        // Testcases: Random reset
        $display(" --- RANDOM RESET SIGNAL --- ");
        repeat (RAND_SIGNED_TEST) 
        begin
            rst_n = $random; 
            flag_rst = (rst_n) ? 0 : 1;
            bias_input = $random;
            for (int i = 0; i < PE_ARR_SIZE; i++) 
            begin
                ifm_input[i] = $random;
                wgt_input[i] = $random;
            end
            display_and_predict(); 
        end
        #(5*CLOCK_TIMER);
        $display(" ---------------------------------- ");
        $display(" ------------ END TEST ------------ ");
        $display(" ---------------------------------- ");
        #5 $finish;
    end

    // --- Dump file ---
    // initial 
    // begin
    //     $dumpfile("test.vcd");
	//     $dumpvars(0);
    // end
endmodule
