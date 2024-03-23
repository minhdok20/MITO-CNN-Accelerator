`timescale 1ns / 1ps

module test_tb; 
    reg clk, rst_n;
    reg read, load;                    
                                                     
    wire [7:0] counter;
    wire reset_counter;
    
    test dut(.clk(clk), .rst_n(rst_n), .read(read), .load(load), .counter(counter), .reset_counter(reset_counter));
                
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        #15;
        
        rst_n = 1;
        #10;
        
        read = 1;
        load = 0;
        #30;
        
        read = 0;
        load = 1;
        #10;
        
        read = 1;
        load = 0;
        #10;
        
        read = 0;
        load = 1;
        #10;
        
        read = 1;
        load = 0;
        #10;
        
        read = 0;
        load = 1;
        #10;
        
                read = 1;
        load = 0;
        #10;
        
        read = 0;
        load = 1;
        #10;
        
        read = 1;
        load = 0;
        #10 $finish;
    end
endmodule
