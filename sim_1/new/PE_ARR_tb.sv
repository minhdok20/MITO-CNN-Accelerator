`timescale 1ns / 1ps

module PE_ARR_tb;

    parameter input_width = 8,
              output_width = 20,
              PE_arr_size = 9;

    reg clk, rst_n, bias_input;
    reg signed [input_width-1:0] ifm_input [PE_arr_size-1:0];
    reg signed [input_width-1:0] wgt_input [PE_arr_size-1:0];
    
    wire signed [output_width-1:0] ofm_output;
    
    PE_ARR #(.input_width (input_width),
             .output_width (output_width),
             .PE_arr_size (PE_arr_size))
    dut(
        .clk (clk),
        .rst_n (rst_n),
        .bias_input (bias_input),
        .ifm_input (ifm_input),
        .wgt_input (wgt_input),
        .ofm_output (ofm_output)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    integer i;
    
    initial begin
        rst_n = 1;
        bias_input = 1;
        #10;
        for (i=0; i<PE_arr_size; i++) begin
            ifm_input[i] = i+1;
            wgt_input[i] = i+1;
        end
        #100 $finish;
    end

endmodule
