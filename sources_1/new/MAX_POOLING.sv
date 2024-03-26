`timescale 1ns / 1ps

// *******************************************************************************************
// ** MODULE MAX POOLING **
module  MAX_POOLING    
    // --- Parameters ---
  #(parameter                               INPUT_WIDTH         = 32,
                                            OUTPUT_WIDTH        = 8,
                                            POOL_SIZE           = 2*2
   )  
    // --- I/O ---     
   (input logic                             clk, 
    input logic                             rst_n, 
    input logic                             pooling_signal, 
    input logic signed  [INPUT_WIDTH-1:0]   ifm_input,
    output logic signed [OUTPUT_WIDTH-1:0]  ifm_output,
    output logic                            ready_write
   );
                    
    logic signed        [OUTPUT_WIDTH-1:0]  buffer              [POOL_SIZE-2:0];
    
    genvar i;
    
    for (i = 0; i < POOL_SIZE - 1; i++) 
    begin
        if (i==0) 
        begin
            COLLATIONER compare            (.clk                (clk), 
                                            .rst_n              (rst_n), 
                                            .ifm_input0         (ifm_input[7:0]), 
                                            .ifm_input1         (ifm_input[15:8]), 
                                            .ifm_output         (buffer[0])
                                            );
        end 
        else 
        begin
            COLLATIONER compare            (.clk                (clk), 
                                            .rst_n              (rst_n), 
                                            .ifm_input0         (buffer[i-1]), 
                                            .ifm_input1         (ifm_input[OUTPUT_WIDTH*(i+2)-1:OUTPUT_WIDTH*(i+1)]), 
                                            .ifm_output         (buffer[i])
                                           );
        end
    end
    
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            ifm_output <= 'bx;
            ready_write <= 1'b0;
        end 
        else 
        begin
            if (pooling_signal) 
            begin
                ifm_output <= buffer[POOL_SIZE-2];
                ready_write <= 1'b1;
            end 
            else 
            begin
                ifm_output <= ifm_output;
                ready_write <= 1'b1;
            end
        end
    end   
    
endmodule
// *******************************************************************************************

// -------------------------------------------------------------------------------------------
// ** MODULE COLLATIONER **
module COLLATIONER 
  #(parameter                               INPUT_WIDTH         = 8,
                                            OUTPUT_WIDTH        = 8
   )           
   (input logic                             clk, 
    input logic                             rst_n, 
    input logic signed  [INPUT_WIDTH-1:0]   ifm_input0,
    input logic signed  [INPUT_WIDTH-1:0]   ifm_input1, 
    output logic signed [OUTPUT_WIDTH-1:0]  ifm_output
   );
    
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            ifm_output <= 'bx;
        end 
        else 
        begin
            ifm_output <= (ifm_input0 > ifm_input1) ? ifm_input0 : ifm_input1;
        end        
    end
    
endmodule
// -------------------------------------------------------------------------------------------