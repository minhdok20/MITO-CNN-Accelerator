`timescale 1ns / 1ps

// ** MODULE QUANTIZATION AND RELU **
module  ACTIVATION     #(parameter              INPUT_WIDTH         = 32,
                                                OUTPUT_WIDTH        = 8
                        )
                        (input logic                                clk, 
                         input logic                                rst_n, 
                         input logic                                ready_activation,
                         input logic signed    [INPUT_WIDTH-1:0]    ofm_input, 
                         output logic signed   [OUTPUT_WIDTH-1:0]   ofm_output,
                         output logic signed                        ready_write 
                        );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ofm_output <= 'bx;
            ready_write <= 0;
        end else begin
            if (ready_activation) begin
                if (ofm_input >= 32'h80000000 && ofm_input <= 32'hFFFFFFFF) begin
                    ofm_output <= 8'h00;
                end else if (ofm_input >= 32'h00000000 && ofm_input <= 32'h7FFFFFFF) begin
                    ofm_output <= ofm_input[INPUT_WIDTH-1:INPUT_WIDTH-8];
                end else begin
                    ofm_output <= 'bx;
                end
                ready_write <= 1;
            end else begin
                ofm_output <= ofm_output;
                ready_write <= 0;
            end
        end
    end       
   
endmodule
