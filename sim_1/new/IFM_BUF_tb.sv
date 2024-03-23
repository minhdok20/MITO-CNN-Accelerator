`timescale 1ns / 1ps

module IFM_BUF_tb #(parameter input_width  = 32,
                           output_width = 8,
                           
                           input_reg    = 3,                           
                           PE_arr_size  = 9,
                           POOL_SIZE    = 2*2,
                           
                           ALL          = 3'b111,
                           RIGHT        = 3'b001,
                           DOWN         = 3'b010,
                           LEFT         = 3'b100,
                           NO_CHANGE    = 3'b101,
                           
                           CONVOLUTION  = 2'b01,
                           POOLING      = 2'b10,
                           FULLY        = 2'b11,
                           NONE         = 2'b00);
    reg clk, rst_n;
    reg [1:0] layer_type;
    reg [2:0] shift_mode;
    reg ifm_read, ifm_load;                    
    reg signed [input_width-1:0] ifm_input [input_reg-1:0];
                                                     
    wire signed [output_width-1:0] ifm_output [PE_arr_size-1:0];
    wire [7:0] counter_var;
    
    IFM_BUF dut(.clk(clk), .rst_n(rst_n), .layer_type(layer_type), .shift_mode(shift_mode), .ifm_read(ifm_read), .ifm_load(imf_load), .ifm_input(ifm_input), .ifm_output(ifm_output), .counter_var(counter_var));
                
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        
        #15;
        rst_n = 1;
        layer_type = CONVOLUTION;        
        ifm_input[0] = 'h 00010203;
        ifm_input[1] = 'h 00040506;
        ifm_input[2] = 'h 00070809;
        
        #10;
        ifm_read = 1;
        ifm_load = 0;
        #10;
//        ifm_input[0] = 'h 00010203;
//        ifm_input[1] = 'h 00040506;
//        ifm_input[2] = 'h 00070809;
        #10;
        shift_mode = ALL;
        ifm_read = 0;
        ifm_load = 1;
        #10;
        ifm_read = 1;
        ifm_load = 0;
        #10;
        ifm_input[0] = 'h 0000000A;
        ifm_input[1] = 'h 0000000B;
        ifm_input[2] = 'h 0000000C;
        #10;
        ifm_read = 0;
        ifm_load = 1;
        #10;
        ifm_read = 1;
        ifm_load = 0;
        #10;
        ifm_input[0] = 'h 00000000;
        ifm_input[1] = 'h 00000000;
        ifm_input[2] = 'h 000D0E0F;
        
        #10;
        ifm_input[0] = 'h 000A0000;
        ifm_input[1] = 'h 000A0000;
        ifm_input[2] = 'h 000A0000;
        #100 $finish;
    end
endmodule
