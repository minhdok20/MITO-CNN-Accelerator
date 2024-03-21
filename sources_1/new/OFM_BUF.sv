`timescale 1ns / 1ps

// ** MODULE OFM BUFFER **
module OFM_BUF#(parameter   INPUT_WIDTH             = 8, 
                            OUTPUT_WIDTH            = 8
                )
                          
               (input                               clk, 
                input                               rst_n, 
                input       [INPUT_WIDTH-1:0]       ofm_input, 
                output reg  [OUTPUT_WIDTH-1:0]      ofm_output
               );
    
    always_ff @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            ofm_output <= 0;
        end 
        else 
        begin
            ofm_output <= ofm_input;
        end
    end

endmodule