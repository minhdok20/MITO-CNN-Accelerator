//`timescale 1ns / 1ps

//module IFM_BUF #(parameter input_width  = 32,
//                           output_width = 8,
                           
//                           NUM_OF_INPUTS    = 3,                           
//                           PE_arr_size      = 9,
//                           POOL_SIZE        = 2*2,
                           
//                           ALL          = 3'b111,
//                           RIGHT        = 3'b001,
//                           DOWN         = 3'b010,
//                           LEFT         = 3'b100,
//                           NO_CHANGE    = 3'b101,
                           
//                           CONVOLUTION  = 2'b01,
//                           POOLING      = 2'b10,
//                           FULLY        = 2'b11,
//                           NONE         = 2'b00)
                           
//                (clk, rst_n, layer_type, shift_mode, ifm_read, ifm_load, ifm_input, ifm_output, counter_var);
    /*
    input clk, rst_n;
    input [1:0] layer_type;
    input signed [input_width-1:0] ifm_input [input_reg-1:0];
    
    output reg signed [output_width-1:0] ifm_output [PE_arr_size-1:0];
    
    reg start_counter = 1;
    reg [4:0] counter;
    reg [2:0] mode;
    
    integer i;
    
    //COUNTER
    always_ff @(posedge clk or negedge start_counter) begin
        if (!start_counter) begin
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
            start_counter = 0;
        end
            
        if (counter <= 0) begin
            start_counter = 1;
            mode = ALL;
        end else if (counter <= 2) begin
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
                                ifm_output[i*3]     <= ifm_input[i][23:16];
                                ifm_output[i*3+1]   <= ifm_input[i][15:8];
                                ifm_output[i*3+2]   <= ifm_input[i][7:0];
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
    
    */
    
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    
//    input clk, rst_n;
//    input [1:0] layer_type;
//    input [2:0] shift_mode;
//    input ifm_read, ifm_load;
//    input signed [input_width-1:0] ifm_input [NUM_OF_INPUTS-1:0];
    
//    reg [input_width-1:0] ifm_buf [NUM_OF_INPUTS-1:0];
    
//    output reg signed [output_width-1:0] ifm_output [PE_arr_size-1:0];
//    output reg [7:0] counter_var;
    
//    reg reset_counter;
//    reg [7:0] counter = 1;
     
//    reg [2:0] stage;
//    reg [2:0] next_stage;
    
//    reg first_ifm_read;
    
//    integer i;
    
//    //START COUNTER READ IFM INTO BUFFER
//    always_ff @(posedge clk or negedge rst_n) begin
//        counter_var <= counter;
//        if (!rst_n) begin
//            counter <= 0;
//            reset_counter <= 0;
//            first_ifm_read <= 1;
//        end else begin
//            if (reset_counter) begin
//                counter <= 0;
//                reset_counter <= 0;
//            end else if (ifm_read && !ifm_load && !reset_counter) begin
//                reset_counter <= 1;
//                first_ifm_read <= 1;                
//            end else if (!ifm_read && ifm_load && !reset_counter) begin
//                reset_counter <= 1;
//            end else begin
//                counter <= counter + 1;
//            end
//        end
//    end
//    //END COUNTER READ IFM INTO BUFFER
    
//    always_ff @(posedge clk) begin
//        case(layer_type)
//            CONVOLUTION: begin
//                if (ifm_read && !ifm_load) begin            //READ IFM
//                    if (counter < NUM_OF_INPUTS && first_ifm_read) begin    //FIRST TIME READ IFM IN 3 CYCLE
//                        ifm_buf[counter] <= ifm_input[counter];
//                    end else begin
//                        for (i=0; i<NUM_OF_INPUTS; i=i+1) begin             //RELOAD BUFFER BEFORE READ SHIFT IFM
//                            ifm_buf[i] <= ifm_buf[i];
//                        end
                                                
//                        //READ SHIFT IFM
//                        case (shift_mode)
//                            RIGHT: begin
//                                ifm_buf[0] <= ifm_input[0];
//                            end
                            
//                            LEFT: begin
//                                ifm_buf[1] <= ifm_input[1];
//                            end
                            
//                            DOWN: begin
//                                ifm_buf[2] <= ifm_input[2];
//                            end
                            
//                            default: begin
//                                for (i=0; i<NUM_OF_INPUTS; i=i+1) begin
//                                    ifm_buf[i] <= ifm_buf[i];
//                                end
//                            end
//                        endcase
//                        //END READ SHIFT IFM
//                    end
//                    first_ifm_read <= 0;
//                end else if (!ifm_read && ifm_load) begin   //LOAD IFM
                    
//                    if (counter < 1) begin
//                        case (shift_mode)
//                            ALL: begin                      //LOAD ALL
//                                for (i=0; i<PE_arr_size/3; i++) begin
//                                    ifm_output[i*3]     <= ifm_buf[i][7:0];
//                                    ifm_output[i*3+1]   <= ifm_buf[i][15:8];
//                                    ifm_output[i*3+2]   <= ifm_buf[i][23:16];
//                                end  
//                            end
    
//                            RIGHT: begin                    //SHIFT RIGHT
//                                //shift the value of 3 PE in the middle column to 3 PE in the left column
//                                ifm_output[0] <= ifm_output[1];
//                                ifm_output[3] <= ifm_output[4];
//                                ifm_output[6] <= ifm_output[7];
                                
//                                //shift the value of 3 PE in the right column to 3 PE in the middle column
//                                ifm_output[1] <= ifm_output[2];
//                                ifm_output[4] <= ifm_output[5];
//                                ifm_output[7] <= ifm_output[8];
                            
//                                //update the value of 3 PE in the right column
//                                ifm_output[2] <= ifm_buf[0][7:0];
//                                ifm_output[5] <= ifm_buf[0][15:8];
//                                ifm_output[8] <= ifm_buf[0][23:16];
//                            end
    
//                            DOWN: begin                     //SHIFT DOWN
//                                //shift the value of 3 PE in the middle row to 3 PE in the top row
//                                ifm_output[0] <= ifm_output[3];
//                                ifm_output[1] <= ifm_output[4];
//                                ifm_output[2] <= ifm_output[5];
                                
//                                //shift the value of 3 PE in the bottom row to 3 PE in the middle row
//                                ifm_output[3] <= ifm_output[6];
//                                ifm_output[4] <= ifm_output[7];
//                                ifm_output[5] <= ifm_output[8];
                                
//                                //update the value of 3 PE in the bottom row
//                                ifm_output[6] <= ifm_buf[1][7:0];
//                                ifm_output[7] <= ifm_buf[1][15:8];
//                                ifm_output[8] <= ifm_buf[1][23:16];
//                            end
    
//                            LEFT: begin                     //SHIFT LEFT
//                                //shift the value of 3 PE in the middle column to 3 PE in the right column
//                                ifm_output[2] <= ifm_output[1];
//                                ifm_output[5] <= ifm_output[4];
//                                ifm_output[8] <= ifm_output[7];
                                
//                                //shift the value of 3 PE in the left column to 3 PE in the middle column
//                                ifm_output[1] <= ifm_output[0];
//                                ifm_output[4] <= ifm_output[3];
//                                ifm_output[7] <= ifm_output[6];
                            
//                                //update the value of 3 PE in the left column
//                                ifm_output[0] <= ifm_buf[2][7:0];
//                                ifm_output[3] <= ifm_buf[2][15:8];
//                                ifm_output[6] <= ifm_buf[2][23:16];
//                            end
    
//                            NO_CHANGE: begin                //NO SHIFT                
//                                for (i=0; i<PE_arr_size; i++) begin
//                                    ifm_output[i] <= ifm_output[i];
//                                end
//                            end                  
                            
//                            default: begin                  //NO SHIFT
//                                for (i=0; i<PE_arr_size; i++) begin
//                                    ifm_output[i] <= ifm_output[i];
//                                end
//                            end                 
//                        endcase
//                    end
//                end
//            end
            
////            FULLY: begin
                
////            end
            
////            POOLING: begin
////                if (ifm_read && !ifm_load) begin            //READ IFM
////                    if (counter < 1) begin
                        
////                    end
////                end
////            end
            
//            NONE: begin
//                counter <= 0;
//                reset_counter <= 0;
//                first_ifm_read <= 1;
//            end
            
//            default: begin
//                counter <= 0;
//                reset_counter <= 0;
//                first_ifm_read <= 1;
//            end
//        endcase
//    end
    
//endmodule

























//###################################################################################################
//###################################################################################################
//###################################################################################################
//###################################################################################################
//###################################################################################################


`timescale 1ns / 1ps

module IFM_BUF #(parameter INPUT_WIDTH  = 32,
                           OUTPUT_WIDTH = 8,
                                                     
                           PE_ARR_SIZE  = 9,
                           POOL_SIZE    = 2*2,
                           
                           READ         = 2'b01,
                           LOAD         = 2'b10,
                           SUSP         = 2'b11,
                           
                           CONVOLUTION  = 2'b01,
                           POOLING      = 2'b10,
                           FULLY        = 2'b11,
                           NONE         = 2'b00)
                           
                (clk, rst_n, control_signal, layer_type, ifm_input, ifm_output);
                
    input clk, rst_n, control_signal;
    input [1:0] layer_type;
    input signed [INPUT_WIDTH-1:0] ifm_input;
    
    reg [INPUT_WIDTH-1:0] ifm_buf [PE_ARR_SIZE-1:0];
    
    output reg signed [OUTPUT_WIDTH-1:0] ifm_output [PE_ARR_SIZE-1:0];
    
    reg [1:0] stage;
    reg [1:0] next_stage;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage <= SUSP;
        end else begin
            stage <= next_stage;
        end
    end
    
    always_comb begin
        case (stage)
            READ: begin
                
            end
        endcase
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
        end else begin
            
        end
    end
    
    
//    reg reset_counter;
//    reg [7:0] counter;
//    reg [7:0] next_counter;
     
//    reg [2:0] stage;
//    reg [2:0] next_stage;
    
//    reg first_ifm_read;
    
//    integer i;
    
//    //START COUNTER 
//    always_ff @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            counter <= 0;
////            reset_counter <= 0;
////            first_ifm_read <= 1;
////            counter_var <= counter;
//        end else begin
//            counter <= next_counter;
//        end
//    end
//    //END COUNTER
    
//    //START COMPUTE NEXT COUNTER
//    always_comb begin
////        reset_counter = 0;
////        if (reset_counter) begin
////            next_counter = 0;
////            reset_counter = 0;
////        end else if (ifm_read && !ifm_load && !reset_counter) begin
////            reset_counter = 1;
////            next_counter = next_counter + 1;
////        end else if (!ifm_read && ifm_load && !reset_counter) begin
////            reset_counter = 1;
////            next_counter = next_counter + 1;
////        end else begin
//            next_counter = next_counter + 1;
////        end
//    end
//    //END COMPUTE NEXT COUNTER
    
//    always_ff @(posedge clk) begin
//        case(layer_type)
//            CONVOLUTION: begin
//                if (ifm_read && !ifm_load) begin            //READ IFM
//                    if (counter < NUM_OF_INPUTS && first_ifm_read) begin    //FIRST TIME READ IFM IN 3 CYCLE
//                        ifm_buf[counter] <= ifm_input[counter];
//                    end else begin
//                        for (i=0; i<NUM_OF_INPUTS; i=i+1) begin             //RELOAD BUFFER BEFORE READ SHIFT IFM
//                            ifm_buf[i] <= ifm_buf[i];
//                        end
                                                
//                        //READ SHIFT IFM
//                        case (shift_mode)
//                            RIGHT: begin
//                                ifm_buf[0] <= ifm_input[0];
//                            end
                            
//                            LEFT: begin
//                                ifm_buf[1] <= ifm_input[1];
//                            end
                            
//                            DOWN: begin
//                                ifm_buf[2] <= ifm_input[2];
//                            end
                            
//                            default: begin
//                                for (i=0; i<NUM_OF_INPUTS; i=i+1) begin
//                                    ifm_buf[i] <= ifm_buf[i];
//                                end
//                            end
//                        endcase
//                        //END READ SHIFT IFM
//                    end
//                    first_ifm_read <= 0;
//                end else if (!ifm_read && ifm_load) begin   //LOAD IFM
                    
//                    if (counter < 1) begin
//                        case (shift_mode)
//                            ALL: begin                      //LOAD ALL
//                                for (i=0; i<PE_arr_size/3; i++) begin
//                                    ifm_output[i*3]     <= ifm_buf[i][7:0];
//                                    ifm_output[i*3+1]   <= ifm_buf[i][15:8];
//                                    ifm_output[i*3+2]   <= ifm_buf[i][23:16];
//                                end  
//                            end
    
//                            RIGHT: begin                    //SHIFT RIGHT
//                                //shift the value of 3 PE in the middle column to 3 PE in the left column
//                                ifm_output[0] <= ifm_output[1];
//                                ifm_output[3] <= ifm_output[4];
//                                ifm_output[6] <= ifm_output[7];
                                
//                                //shift the value of 3 PE in the right column to 3 PE in the middle column
//                                ifm_output[1] <= ifm_output[2];
//                                ifm_output[4] <= ifm_output[5];
//                                ifm_output[7] <= ifm_output[8];
                            
//                                //update the value of 3 PE in the right column
//                                ifm_output[2] <= ifm_buf[0][7:0];
//                                ifm_output[5] <= ifm_buf[0][15:8];
//                                ifm_output[8] <= ifm_buf[0][23:16];
//                            end
    
//                            DOWN: begin                     //SHIFT DOWN
//                                //shift the value of 3 PE in the middle row to 3 PE in the top row
//                                ifm_output[0] <= ifm_output[3];
//                                ifm_output[1] <= ifm_output[4];
//                                ifm_output[2] <= ifm_output[5];
                                
//                                //shift the value of 3 PE in the bottom row to 3 PE in the middle row
//                                ifm_output[3] <= ifm_output[6];
//                                ifm_output[4] <= ifm_output[7];
//                                ifm_output[5] <= ifm_output[8];
                                
//                                //update the value of 3 PE in the bottom row
//                                ifm_output[6] <= ifm_buf[1][7:0];
//                                ifm_output[7] <= ifm_buf[1][15:8];
//                                ifm_output[8] <= ifm_buf[1][23:16];
//                            end
    
//                            LEFT: begin                     //SHIFT LEFT
//                                //shift the value of 3 PE in the middle column to 3 PE in the right column
//                                ifm_output[2] <= ifm_output[1];
//                                ifm_output[5] <= ifm_output[4];
//                                ifm_output[8] <= ifm_output[7];
                                
//                                //shift the value of 3 PE in the left column to 3 PE in the middle column
//                                ifm_output[1] <= ifm_output[0];
//                                ifm_output[4] <= ifm_output[3];
//                                ifm_output[7] <= ifm_output[6];
                            
//                                //update the value of 3 PE in the left column
//                                ifm_output[0] <= ifm_buf[2][7:0];
//                                ifm_output[3] <= ifm_buf[2][15:8];
//                                ifm_output[6] <= ifm_buf[2][23:16];
//                            end
    
//                            NO_CHANGE: begin                //NO SHIFT                
//                                for (i=0; i<PE_arr_size; i++) begin
//                                    ifm_output[i] <= ifm_output[i];
//                                end
//                            end                  
                            
//                            default: begin                  //NO SHIFT
//                                for (i=0; i<PE_arr_size; i++) begin
//                                    ifm_output[i] <= ifm_output[i];
//                                end
//                            end                 
//                        endcase
//                    end
//                end
//            end
            
//            NONE: begin
//                counter <= 0;
//                reset_counter <= 0;
//                first_ifm_read <= 1;
//            end
            
//            default: begin
//                counter <= 0;
//                reset_counter <= 0;
//                first_ifm_read <= 1;
//            end
//        endcase
//    end
    
//endmodule