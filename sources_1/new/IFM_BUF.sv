`timescale 1ns / 1ps

module IFM_BUF #(parameter input_width  = 32,
                           output_width = 8,
                           
                           input_reg    = 3,                           
                           PE_arr_size  = 9,
                           POOL_SIZE    = 2*2,
                           
                           ALL          = 3'b111,
                           RIGHT        = 3'b001,
                           DOWN         = 3'b010,
                           LEFT         = 3'b100,
                           NO_CHANGE    = 3'b101,
                           
                           CONVOLUTION  = 2'b01,
                           POOLING      = 2'b10,
                           FULLY        = 2'b11,
                           NONE         = 2'b00)
                           
                (clk, rst_n, layer_type, ifm_input, ifm_output);
    
    input clk, rst_n;
    input [1:0] layer_type;
    input signed [input_width-1:0] ifm_input [input_reg-1:0];
    
    output reg signed [output_width-1:0] ifm_output [PE_arr_size-1:0];
    
    reg [4:0] counter;
    reg [2:0] mode;
    
    integer i;
    
    //COUNTER
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else if (counter >= 9) begin 
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
    //END COUNTER
    
    //SHIFT MODE
    always_comb begin
        if (layer_type == CONVOLUTION) begin
            counter = 0;
            mode = ALL;
        end
        
        if (counter <= 2) begin
            mode = RIGHT;
        end else if (counter <= 3) begin
            mode = DOWN;
        end else if (counter <= 5) begin
            mode = LEFT;
        end else if (counter <= 6) begin
            mode = DOWN;
        end else if (counter <= 8) begin
            mode = RIGHT;
        end else begin
            mode = NO_CHANGE;
        end
    end
    //END SHIFT MODE
    
    //SHIFT IFM
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin //reset all ifm_output
            for (i=0; i<PE_arr_size; i++) begin
                ifm_output[i] <= 0;
            end           
        end else begin
            case (layer_type)
                CONVOLUTION: begin
                    case (mode)
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

                        NO_CHANGE: //no shifting 
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
                
                

//                FULLY:
//                case (ifm_read)
//                    ALL: //load all ifm data into 3x3 PE
//                    begin
//                        for (i=0; i<PE_arr_size/3; i++) begin
//                            ifm_output[i*3]   <= ifm_input[i][23:16];
//                            ifm_output[i*3+1] <= ifm_input[i][15:8];
//                            ifm_output[i*3+2] <= ifm_input[i][7:0];
//                        end  
//                    end

//                    RIGHT: //shift right
//                    begin
//                        //shift the value of 3 PE in the middle column to 3 PE in the left column
//                        ifm_output[0] <= ifm_output[1];
//                        ifm_output[3] <= ifm_output[4];
//                        ifm_output[6] <= ifm_output[7];
                        
//                        //shift the value of 3 PE in the right column to 3 PE in the middle column
//                        ifm_output[1] <= ifm_output[2];
//                        ifm_output[4] <= ifm_output[5];
//                        ifm_output[7] <= ifm_output[8];
                    
//                        //update the value of 3 PE in the right column
//                        ifm_output[2] <= ifm_input[0][23:16];
//                        ifm_output[5] <= ifm_input[0][15:8];
//                        ifm_output[8] <= ifm_input[0][7:0];
//                    end

//                    DOWN: //shift down
//                    begin
//                        //shift the value of 3 PE in the middle row to 3 PE in the top row
//                        ifm_output[0] <= ifm_output[3];
//                        ifm_output[1] <= ifm_output[4];
//                        ifm_output[2] <= ifm_output[5];
                        
//                        //shift the value of 3 PE in the bottom row to 3 PE in the middle row
//                        ifm_output[3] <= ifm_output[6];
//                        ifm_output[4] <= ifm_output[7];
//                        ifm_output[5] <= ifm_output[8];
                        
//                        //update the value of 3 PE in the bottom row
//                        ifm_output[6] <= ifm_input[1][23:16];
//                        ifm_output[7] <= ifm_input[1][15:8];
//                        ifm_output[8] <= ifm_input[1][7:0];
//                    end

//                    LEFT: //shift left
//                    begin
//                        //shift the value of 3 PE in the middle column to 3 PE in the right column
//                        ifm_output[2] <= ifm_output[1];
//                        ifm_output[5] <= ifm_output[4];
//                        ifm_output[8] <= ifm_output[7];
                        
//                        //shift the value of 3 PE in the left column to 3 PE in the middle column
//                        ifm_output[1] <= ifm_output[0];
//                        ifm_output[4] <= ifm_output[3];
//                        ifm_output[7] <= ifm_output[6];
                    
//                        //update the value of 3 PE in the left column
//                        ifm_output[0] <= ifm_input[2][23:16];
//                        ifm_output[3] <= ifm_input[2][15:8];
//                        ifm_output[6] <= ifm_input[2][7:0];
//                    end

//                    NO_CHANGE: //no shifting 
//                    begin                
//                        for (i=0; i<PE_arr_size; i++) begin
//                            ifm_output[i] <= ifm_output[i];
//                        end
//                    end                  
                    
//                    default: //no shifting 
//                    begin
//                        for (i=0; i<PE_arr_size; i++) begin
//                            ifm_output[i] <= ifm_output[i];
//                        end
//                    end                 
//                endcase    
                
                POOLING:
                begin
                    for (i=0; i<PE_arr_size; i=i+4) begin
                        ifm_output[i]     <= ifm_input[i/4][31:24];
                        ifm_output[i+1]   <= ifm_input[i/4][23:16];
                        ifm_output[i+2]   <= ifm_input[i/4][15:8];
                        ifm_output[i+3]   <= ifm_input[i/4][7:0];
                    end
                    ifm_output[8] <= 0;
                end              
                
                //############################################################################################
                default:
                begin
                    for (i=0; i<PE_arr_size; i++) begin
                        ifm_output[i] <= 0;
                    end  
                end
                
            endcase
        end   
    end
    //END SHIFT IFM 
    
endmodule