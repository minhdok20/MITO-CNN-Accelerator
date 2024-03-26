`timescale 1ns / 1ps

module MUX_2_TO_1 #(parameter INPUT_WIDTH = 8,
                              OUTPUT_WIDTH = 8,
                              
                              ACTIVATION = 1'b0,
                              POOLING = 1'b1)
                              
                   (sel, mux_input_activation, mux_input_pooling, mux_output);
                   
    input sel;
    input [INPUT_WIDTH-1:0] mux_input_activation;
    input [INPUT_WIDTH-1:0] mux_input_pooling;
    
    output reg [OUTPUT_WIDTH-1:0] mux_output;
    
    always_comb begin
        case (sel) 
            ACTIVATION:
                mux_output = mux_input_activation;
            POOLING:
                mux_output = mux_input_pooling;
        endcase
    end
endmodule
