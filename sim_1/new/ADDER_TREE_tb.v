`timescale 1ns / 1ps

module ADDER_TREE_tb#(parameter input_width = 16,
                      parameter output_width = 20);

    reg clk;
    reg rst_n;
    reg bias_input;
    
    reg [input_width-1:0] product_input0;
    reg [input_width-1:0] product_input1;
    reg [input_width-1:0] product_input2;
    reg [input_width-1:0] product_input3;
    reg [input_width-1:0] product_input4;
    reg [input_width-1:0] product_input5;
    reg [input_width-1:0] product_input6;
    reg [input_width-1:0] product_input7;
    reg [input_width-1:0] product_input8;   
    
    wire [output_width-1:0] final_sum;
    
    ADDER_TREE dut(.clk(clk), .rst_n(rst_n), .bias_input(bias_input), .final_sum(final_sum),
                   .product_input0(product_input0), .product_input1(product_input1), .product_input2(product_input2),
                   .product_input3(product_input3), .product_input4(product_input4), .product_input5(product_input5), 
                   .product_input6(product_input6), .product_input7(product_input7), .product_input8(product_input8));
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        #1;
        rst_n = 1;
        bias_input = 1;
        product_input0 = 1;
        product_input1 = 2;
        product_input2 = 3;
        product_input3 = 4;
        product_input4 = 5;
        product_input5 = 6;
        product_input6 = 7;
        product_input7 = 8;
        product_input8 = 9;
        
        #10;
        product_input0 = 8'b11111111;
        product_input1 = 8'b11111111;
        
        #120 rst_n = 0;
        #20 $finish;
    end

endmodule
