`timescale 1ns / 1ps

module DEMUX_1_TO_3_tb;

    parameter INPUT_WIDTH   = 32,
              OUTPUT_WIDTH  = 32,
                      
              IFM           = 2'b01,
              WGT           = 2'b10,
              BIAS          = 2'b11;

    reg clk, rst_n;
    reg [1:0] sel;
    reg [INPUT_WIDTH-1:0] main_input;
    
    wire [OUTPUT_WIDTH-1:0] main_output [2:0];
    
    DEMUX_1_TO_3 dut(.clk(clk), .rst_n(rst_n), .sel(sel), .main_input(main_input), .main_output(main_output));
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        #15;
        
        rst_n = 1;
        #10;
        
        main_input = 15;
        sel = 1;
        #10;
        
        sel = 3;
        #10;
        
        sel = 2;
        #10;
        
        main_input = 90;
        sel = 3;
        #10;
        
        sel = 1;
        #10;
        
        main_input = 40;
        sel = 2;
        #10;
        
        sel = 1;
        #10; $finish; 
    end
endmodule
