`timescale 1ns / 1ps

// *******************************************************************************************
// ** MODULE DEMUX 1 TO 2: DETERMINE LAYER MODE **
module DEMUX_1_TO_2 
    // --- Parameters ---
  #(parameter                               INPUT_WIDTH             = 32,
                                            OUTPUT_WIDTH            = 32
   )
    
   (input logic                             sel, 
    input logic     [INPUT_WIDTH-1:0]       demux_input, 
    output logic    [OUTPUT_WIDTH-1:0]      demux_output_main_buf, 
    output logic    [OUTPUT_WIDTH-1:0]      demux_output_max_pooling
   );

    always_comb 
    begin
        case (sel)
            FULLY_CONVOL: 
            begin
                demux_output_main_buf = demux_input;
                demux_output_max_pooling = 'bx;
            end
            
            POOLING: 
            begin
                demux_output_main_buf = 'bx;
                demux_output_max_pooling = demux_input;
            end
            
            default: 
            begin
                demux_output_main_buf = 'bx;
                demux_output_max_pooling = 'bx;
            end
        endcase
    end

endmodule
// *******************************************************************************************