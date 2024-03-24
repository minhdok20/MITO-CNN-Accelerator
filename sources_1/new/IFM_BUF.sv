`timescale 1ns / 1ps

module IFM_BUF #(parameter INPUT_WIDTH = 32,
                           OUTPUT_WIDTH = 8, 
                           
                           NUM_OF_OUTPUTS = 9, 
                           
                           ALL = 3'b001,
                           RIGHT = 3'b010,
                           LEFT = 3'b100,
                           DOWN = 3'b101)
                          
                (clk, rst_n, valid_read, ifm_input, ifm_output);
                
    input clk, rst_n, valid_read;
    input [INPUT_WIDTH-1:0] ifm_input;
    
    output reg signed [OUTPUT_WIDTH-1:0] ifm_output [NUM_OF_OUTPUTS-1:0];
    
    reg [7:0] H_or_V;
    reg [2:0] shift_mode;
    
    reg [7:0] counter;
    reg [7:0] next_counter;
    
    integer i;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            next_counter <= 0;
        end else begin
            counter <= next_counter;
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<NUM_OF_OUTPUTS; i++) begin
                ifm_output[i] <= 0;
            end
        end else begin
            if (valid_read) begin
                case (shift_mode)
                    ALL: begin
                        if (counter <= 0) begin
                            next_counter <= counter + 1;
                            ifm_output[0] <= ifm_input[23:16];
                            ifm_output[3] <= ifm_input[15:8];
                            ifm_output[6] <= ifm_input[7:0];
                        end else if (counter <= 1) begin
                            next_counter <= counter + 1;
                            ifm_output[1] <= ifm_input[23:16];
                            ifm_output[4] <= ifm_input[15:8];
                            ifm_output[7] <= ifm_input[7:0];
                        end else if (counter <= 2) begin
                            next_counter <= 3;
                            ifm_output[2] <= ifm_input[23:16];
                            ifm_output[5] <= ifm_input[15:8];
                            ifm_output[8] <= ifm_input[7:0];
                        end
                    end
                    
                    RIGHT: begin
                        ifm_output[0] <= ifm_output[1];
                        ifm_output[3] <= ifm_output[4];
                        ifm_output[6] <= ifm_output[7];
                        
                        ifm_output[1] <= ifm_output[2];
                        ifm_output[4] <= ifm_output[5];
                        ifm_output[7] <= ifm_output[8];
                        
                        ifm_output[2] <= ifm_input[23:16];
                        ifm_output[5] <= ifm_input[15:8];
                        ifm_output[8] <= ifm_input[7:0];
                    end
                    
                    LEFT: begin
                        ifm_output[2] <= ifm_output[1];
                        ifm_output[5] <= ifm_output[4];
                        ifm_output[8] <= ifm_output[7];
                        
                        ifm_output[1] <= ifm_output[0];
                        ifm_output[4] <= ifm_output[3];
                        ifm_output[7] <= ifm_output[6];
                        
                        ifm_output[0] <= ifm_input[23:16];
                        ifm_output[3] <= ifm_input[15:8];
                        ifm_output[6] <= ifm_input[7:0];
                    end
                    
                    DOWN: begin
                        ifm_output[0] <= ifm_output[3];
                        ifm_output[1] <= ifm_output[4];
                        ifm_output[2] <= ifm_output[5];
                        
                        ifm_output[3] <= ifm_output[6];
                        ifm_output[4] <= ifm_output[7];
                        ifm_output[5] <= ifm_output[8];
                        
                        ifm_output[6] <= ifm_input[23:16];
                        ifm_output[7] <= ifm_input[15:8];
                        ifm_output[8] <= ifm_input[7:0];
                    end
                    
                    default: begin
                        for (i=0; i<NUM_OF_OUTPUTS; i++) begin
                            ifm_output[i] <= ifm_output[i];
                        end
                    end
                endcase
            end else begin
                for (i=0; i<NUM_OF_OUTPUTS; i++) begin
                    ifm_output[i] <= ifm_output[i];
                end
            end
        end
    end
    
    always_comb begin
        H_or_V = ifm_input[31:24];
        case (H_or_V)
            8'b00000000: begin
                shift_mode = ALL; 
            end
            
            8'b00000001: begin
                shift_mode = RIGHT; 
            end
            
            8'b00000010: begin
                shift_mode = LEFT;
            end
            
            8'b11111111: begin
                shift_mode = DOWN;
            end
            
            default: begin
            
            end
        endcase
    end

endmodule