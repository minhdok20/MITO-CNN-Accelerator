//`timescale 1ns / 1ps

//module MAIN_BUF #(INPUT_WIDTH       = 32,
//                  OUTPUT_WIDTH      = 8,
//                  BIAS_WIDTH        = 32, 
                  
//                  NUM_OF_INPUTS     = 7,
//                  NUM_OF_OUTPUTS    = 9,
                  
//                  READ              = 2'b01,
//                  LOAD              = 2'b10,
//                  SUSPEND           = 2'b11)

//                 (clk, rst_n, control_buffer, respond_controller, main_input, ifm_output, wgt_output, bias_output);
                 
//    input clk, rst_n; 
//    input control_buffer, respond_controller;
    
//    input signed [INPUT_WIDTH-1:0] main_input [NUM_OF_INPUTS-1:0];
    
//    output signed [OUTPUT_WIDTH-1:0] ifm_output [NUM_OF_OUTPUTS-1:0];
//    output signed [OUTPUT_WIDTH-1:0] wgt_output [NUM_OF_OUTPUTS-1:0];
    
//    output signed [BIAS_WIDTH-1:0] bias_output;
    
//    reg [1:0] state;
//    reg [1:0] next_state;
    
//    reg [7:0] counter;
//    reg [7:0] next_counter;
    
//    reg start_read;
    
//    //    ----------------------------------- COUNTER -----------------------------------
    
//    always_ff @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            counter <= 0;
//        end else begin
//            counter <= next_counter + 1;
//        end
//    end
    
//    always_comb begin
//        if (control_buffer) begin
//            next_counter = -1;
//        end else begin
//            next_counter = counter;
//        end
//    end
    
//    always_ff @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            state <= SUSPEND;
//        end else begin
//            state <=  next_state;
//        end
//    end
    
//    always_comb begin
//        case (state)
//            READ: begin
//                start_read = 1;
//            end
            
//            LOAD: begin
//                start_read = 0;
//            end
            
//            SUSPEND: begin
//                start_read = 0;
//                if (control_buffer) begin
//                    next_state = READ;
//                end
//            end
            
//            default: begin
//                next_state = SUSPEND;
//            end
//        endcase
//    end
    
//    always_ff @(posedge clk) begin
//        if (start_read) begin
//            if (counter >= 0 && counter <= 2) begin
//                IFM_BUF ifm_buffer (.clk(clk), .rst_n(rst_n), .control_signal(control_signal), .layer_type(layer_type), .ifm_input(main_input[counter]), .ifm_output(ifm_output));
//            end else if (counter >= 3 && counter <= 5) begin
            
//            end else if (counter == 6) begin
                
//            end
//        end
//    end
//endmodule
