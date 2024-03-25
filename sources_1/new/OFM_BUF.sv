`timescale 1ns / 1ps

module OFM_BUF#(parameter INPUT_WIDTH   = 8, 
                          OUTPUT_WIDTH  = 32)
                          
               (clk, rst_n, ready_write, ofm_input, ofm_output, ready_finish);

    input clk, rst_n;
    input ready_write;
    input [INPUT_WIDTH-1:0] ofm_input;
    
    output reg [OUTPUT_WIDTH-1:0] ofm_output;
    output reg ready_finish;
    
    reg [7:0] counter;
    reg [7:0] next_counter;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            counter <= next_counter;
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ofm_output <= 0;
            ready_finish <= 0;
        end else begin
            ofm_output[31:24] <= 0;
            if (ready_write) begin
                if (counter <= 0) begin
                    ofm_output[23:16] <= ofm_input;
                    next_counter <= counter + 1;
                    ready_finish <= 0;
                end else if (counter <= 1) begin
                    ofm_output[15:8] <= ofm_input;
                    next_counter <= counter + 1;
                    ready_finish <= 0;
                end else if (counter <= 2) begin
                    ofm_output[7:0] <= ofm_input;
                    counter <= 0;
                    ready_finish <= 1;
                end
            end else begin 
                ofm_output <= ofm_output;
                next_counter <= 0;
                ready_finish <= 0;
            end
        end
    end

endmodule