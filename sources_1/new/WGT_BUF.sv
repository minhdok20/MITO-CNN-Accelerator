`timescale 1ns / 1ps

// **MODEL WEIGHT FEATURE MAP BUFFER **
module WGT_BUF #(parameter          INPUT_WIDTH         = 32,
                                    OUTPUT_WIDTH        = 8,
                                    INPUT_WGT_REG       = 3,
                                    PE_ARR_SIZE         = 9
                )
                          
                (input                                  clk, 
                 input                                  rst_n, 
                 input                                  wgt_read,
                 input signed       [INPUT_WIDTH-1:0]   wgt_input   [INPUT_WGT_REG-1:0], 
                 output reg signed  [OUTPUT_WIDTH-1:0]  wgt_output  [PE_ARR_SIZE-1:0]
                );
   
    int i;
  
    always_ff @(posedge clk or negedge rst_n) 
    begin
        if (~rst_n) 
        begin
            for (i = 0; i < PE_ARR_SIZE; i++) 
            begin
                wgt_output[i] <= 'bx;
            end
        end 
        else 
        begin
            if(wgt_read) 
            begin
                for (i = 0; i < PE_ARR_SIZE/3; i++) 
                begin
                    wgt_output[i*3]     <= wgt_input[i][23:16];
                    wgt_output[i*3+1]   <= wgt_input[i][15:8];
                    wgt_output[i*3+2]   <= wgt_input[i][7:0];
                end
            end 
            else 
            begin
                for (i = 0; i < PE_ARR_SIZE; i++) 
                begin
                    wgt_output[i]       <= wgt_output[i];
                end
            end
        end
    end
    
endmodule