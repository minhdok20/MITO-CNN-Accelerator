`timescale 1ns / 1ps

module CONTROLLER #(parameter CONVOLUTION   = 2'b01,
                              POOLING       = 2'b10,
                              FULLY         = 2'b11,
                              NONE          = 2'b00,
                              
                              READ          = 4'b0100,
                              COMP          = 4'b0101,
                              WRITE         = 4'b0110,
                              
                              INIT          = 4'b0111,
                              SUSPEND       = 4'b1000,
                              FINISH        = 4'b1001) 
                              
                   (clk, rst_n, start, ofm_valid, layer_type);
                   
    input clk, rst_n, start, ofm_valid;  
    output reg [1:0] layer_type;  
    
    reg [1:0] layer_type_temp; 
    
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
