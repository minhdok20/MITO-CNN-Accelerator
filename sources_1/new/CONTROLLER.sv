`timescale 1ns / 1ps

// *******************************************************************************************
// ** MODULE CONTROLLER CNN LAYERS **
module CONTROLLER 
    // --- Parameters ---
  #(parameter                               INSTRUCTION_WIDTH               = 32
   )  
    // --- I/O ---
   (input logic                             clk,                               
    input logic                             rst_n,                     
    input logic     [INSTRUCTION_WIDTH-1:0] instruction_signal,               
    input logic                             ready_write_from_act,     
    input logic                             ready_write_from_pooling,            
    output logic                            layer_signal,
    output logic                            fully_convol_signal,                          
    output logic                            pooling_signal,                          
    output logic                            write_signal                 
   );   

    bit                                     ready_to_read_instruction       = 1;
    // -- Main functional ---
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            layer_signal <= FULLY_CONVOL;
            fully_convol_signal <= 1;
            pooling_signal <= 0;
            write_signal <= 0;
            ready_to_read_instruction <= 1;
        end 
        else 
        begin
            if (ready_to_read_instruction) 
            begin
                if (instruction_signal == 32'hFFFFFFFF) 
                begin
                    layer_signal <= POOLING; 
                    fully_convol_signal <= 0;
                    pooling_signal <= 1;                
                end 
                else
                begin
                    layer_signal <= FULLY_CONVOL;
                    fully_convol_signal <= 1;
                    pooling_signal <= 0;
                end
            end
            else 
            begin
                layer_signal <= layer_signal;
                fully_convol_signal <= fully_convol_signal;
                pooling_signal <= pooling_signal;                    
            end
            ready_to_read_instruction <= write_signal;
        end
    end
      
    always @(ready_write_from_act or ready_write_from_pooling) 
    begin
        if (ready_write_from_act || ready_write_from_pooling) 
        begin
            write_signal = 1;
        end 
        else 
        begin
            write_signal = 0;
        end
    end
endmodule
// *******************************************************************************************