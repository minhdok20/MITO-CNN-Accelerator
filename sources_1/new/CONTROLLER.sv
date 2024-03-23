`timescale 1ns / 1ps

module CONTROLLER #(parameter CONVOLUTION   = 2'b01,
                              POOLING       = 2'b10,
                              FULLY         = 2'b11,
                              NONE          = 2'b00,
                              
                              READ_IFM      = 3'b001,
                              READ_WGT      = 3'b010,
                              READ_BIAS     = 3'b100,
                              LOAD          = 3'b111,
                              SUSPEND       = 3'b000) 
                              
                   (clk, rst_n, start, ofm_valid, layer_type, ifm_read, wgt_read, bias_read, input_load);
                   
    input clk, rst_n, start, ofm_valid;  
    output reg [1:0] layer_type; 
    output reg ifm_read, wgt_read, bias_read, input_load;
    
    reg [1:0] layer_type_temp;
    
    reg [4:0] counter = 1;
    reg rst_counter = 1;
    
    reg [1:0] stage = READ_IFM;
    reg [1:0] next_stage = READ_IFM;
    
    always_ff @(posedge clk or negedge rst_counter) begin
        if (!rst_counter) begin
            counter <= 1;
        end else begin
            counter <= counter + 1;
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage <= READ_IFM;
        end else begin
            stage <= next_stage;
        end
    end
    
    always_comb begin
        case(stage)
            READ_IFM: begin
                if (counter == 3) begin
                    next_stage = READ_WGT;
                end
                ifm_read = 1;
                wgt_read = 0;
                bias_read = 0;
                input_load = 0;
            end
            
            READ_WGT: begin
                if (counter == 6) begin
                    next_stage = READ_BIAS;
                end
                ifm_read = 0;
                wgt_read = 1;
                bias_read = 0;
                input_load = 0;
            end
            
            READ_BIAS: begin
                if (counter == 7) begin
                    next_stage = LOAD;
                end
                ifm_read = 0;
                wgt_read = 0;
                bias_read = 1;
                input_load = 0;
            end
            
            LOAD: begin
                if (counter == 8) begin
                    next_stage = SUSPEND;
                end
                ifm_read = 0;
                wgt_read = 0;
                bias_read = 0;
                input_load = 1;
            end
            
            SUSPEND: begin
                ifm_read = 0;
                wgt_read = 0;
                bias_read = 0;
                input_load = 0;
            end
            
            default: begin
                next_stage = SUSPEND;
            end
        endcase
    end
    
    //LAYER STATE MACHINE FOR MITO
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin  
            layer_type <= NONE;
        end else begin
            layer_type <= layer_type_temp;
        end
    end
    
    always_comb begin
        layer_type_temp = NONE;
        case(layer_type)
             CONVOLUTION: begin
                if(ofm_valid == 1 && start ) begin
                    layer_type_temp = POOLING;
                end else begin
                    layer_type_temp = CONVOLUTION;
                end
             end
             
             POOLING: begin
                if (ofm_valid == 1) begin
                    layer_type_temp = FULLY;
                end else begin
                    layer_type_temp = POOLING;
                end
             end
             
             FULLY: begin
                if (ofm_valid == 1) begin
                    layer_type_temp = NONE;
                end else begin
                    layer_type_temp = FULLY;
                end
             end
             
             NONE: begin
                if (start == 1) begin
                    layer_type_temp = CONVOLUTION;
                end else begin
                    layer_type_temp = NONE;
                end
             end
             
             default: begin
                layer_type_temp = NONE;
             end
             
        endcase
    end
    
endmodule