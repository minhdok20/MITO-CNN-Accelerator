`timescale 1ns / 1ps

module IFM_BUF #(parameter input_width  = 32,
                           output_width = 8,
                           input_reg    = 3,
                           PE_arr_size  = 9,
                           ALL          = 3'b111,
                           RIGHT        = 3'b001,
                           DOWN         = 3'b010,
                           LEFT         = 3'b100,
                           KEEP         = 3'b000)
                           
                (clk, rst_n, ifm_read, ifm_input, ifm_output);
    
    input clk, rst_n;
    input [2:0] ifm_read;
    input signed [input_width-1:0] ifm_input [input_reg-1:0];
    
    output reg signed [output_width-1:0] ifm_output [PE_arr_size-1:0];
    
    integer i;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin //reset all ifm_output
            for (i=0; i<PE_arr_size; i++) begin
                ifm_output[i] <= 0;
            end           
        end else begin
            case (ifm_read)
                ALL: //load all ifm data into 3x3 PE
                begin
                    for (i=0; i<PE_arr_size/3; i++) begin
                        ifm_output[i*3]   <= ifm_input[i][23:16];
                        ifm_output[i*3+1] <= ifm_input[i][15:8];
                        ifm_output[i*3+2] <= ifm_input[i][7:0];
                    end  
                end
            
                RIGHT: //shift right
                begin
                    //shift the value of 3 PE in the middle column to 3 PE in the left column
                    ifm_output[0] <= ifm_output[1];
                    ifm_output[3] <= ifm_output[4];
                    ifm_output[6] <= ifm_output[7];
                    
                    //shift the value of 3 PE in the right column to 3 PE in the middle column
                    ifm_output[1] <= ifm_output[2];
                    ifm_output[4] <= ifm_output[5];
                    ifm_output[7] <= ifm_output[8];
                
                    //update the value of 3 PE in the right column
                    ifm_output[2] <= ifm_input[0][23:16];
                    ifm_output[5] <= ifm_input[0][15:8];
                    ifm_output[8] <= ifm_input[0][7:0];
                end
                
                DOWN: //shift down
                begin
                    //shift the value of 3 PE in the middle row to 3 PE in the top row
                    ifm_output[0] <= ifm_output[3];
                    ifm_output[1] <= ifm_output[4];
                    ifm_output[2] <= ifm_output[5];
                    
                    //shift the value of 3 PE in the bottom row to 3 PE in the middle row
                    ifm_output[3] <= ifm_output[6];
                    ifm_output[4] <= ifm_output[7];
                    ifm_output[5] <= ifm_output[8];
                    
                    //update the value of 3 PE in the bottom row
                    ifm_output[6] <= ifm_input[1][23:16];
                    ifm_output[7] <= ifm_input[1][15:8];
                    ifm_output[8] <= ifm_input[1][7:0];
                end
                
                LEFT: //shift left
                begin
                    //shift the value of 3 PE in the middle column to 3 PE in the right column
                    ifm_output[2] <= ifm_output[1];
                    ifm_output[5] <= ifm_output[4];
                    ifm_output[8] <= ifm_output[7];
                    
                    //shift the value of 3 PE in the left column to 3 PE in the middle column
                    ifm_output[1] <= ifm_output[0];
                    ifm_output[4] <= ifm_output[3];
                    ifm_output[7] <= ifm_output[6];
                
                    //update the value of 3 PE in the left column
                    ifm_output[0] <= ifm_input[2][23:16];
                    ifm_output[3] <= ifm_input[2][15:8];
                    ifm_output[6] <= ifm_input[2][7:0];
                end
                
                KEEP: //no shifting 
                begin                
                    for (i=0; i<PE_arr_size; i++) begin
                        ifm_output[i] <= ifm_output[i];
                    end
                end                  
                
                default: //no shifting 
                begin
                    for (i=0; i<PE_arr_size; i++) begin
                        ifm_output[i] <= ifm_output[i];
                    end
                end                 
            endcase         
        end   
    end 
    
endmodule