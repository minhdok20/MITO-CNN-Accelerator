`timescale 1ns / 1ps

module DEMUX_1_TO_3 #(INPUT_WIDTH   = 32,
                      OUTPUT_WIDTH  = 32,
                      
                      IFM           = 2'b01,
                      WGT           = 2'b10,
                      BIAS          = 2'b11)
    
                     (clk, rst_n, sel, main_input, main_output);
                     
    input clk, rst_n;
    input [1:0] sel;
    input [INPUT_WIDTH-1:0] main_input;
    
    output reg [OUTPUT_WIDTH-1:0] main_output [2:0];
    
    integer i;
    
    always_comb begin
        case (sel)
            IFM: begin
                main_output[0] = main_input;
                main_output[1] = 0;
                main_output[2] = 0;
            end
            
            WGT: begin
                main_output[0] = 0;
                main_output[1] = main_input;
                main_output[2] = 0;
            end
            
            BIAS: begin
                main_output[0] = 0;
                main_output[1] = 0;
                main_output[2] = main_input;
            end
            
            default: begin
                for (i=0; i<3; i++) begin
                    main_output[i] = 0;
                end
            end
        endcase
    end
endmodule
