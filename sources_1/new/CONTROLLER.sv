`timescale 1ns / 1ps

module CONTROLLER #(parameter CONVOLUTION   = 4'b0001,
                              POOLING       = 4'b0010,
                              FULLY         = 4'b0011,
                              READ          = 4'b0100,
                              COMP          = 4'b0101,
                              WRITE         = 4'b0110,
                              INIT          = 4'b0111,
                              SUSPEND       = 4'b1000,
                              FINISH        = 4'b1001) 
                              
                   (clk, rst_n, ifm_read, wgt_read, bias_read);
                   
    input clk, rst_n;
    
    output reg ifm_read, wgt_read, bias_read;
    
    reg [3:0] mode;
    
    reg [3:0] counter;
    
    //read data
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            //reset toàn bộ tín hiệu
            ifm_read <= 0;
            wgt_read <= 0;
            bias_read <= 0;
            counter <= 0;
            mode <= INIT;
        end else begin
            case(mode)
                CONVOLUTION:
                if (counter < 1) begin
                    //chu kỳ đầu, cho phép load toàn bộ ifm, wgt và bias vào PE array
                    ifm_read <= 1;
                    wgt_read <= 1;
                    bias_read <= 1;
                    //chuyển sang chu kỳ tiếp theo
                    counter <= counter + 1;
                end else if (counter < 9) begin
                    //các chu kỳ sau, chỉ load wgt và bias 
                    ifm_read <= 1;
                    wgt_read <= 0;
                    bias_read <= 0;
                    //chuyển sang chu kỳ tiếp theo
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                end     
                
                POOLING:
                if (counter < 1) begin
                    //chu kỳ đầu, cho phép load toàn bộ ifm, wgt và bias vào PE array
                    ifm_read <= 1;
                    wgt_read <= 1;
                    bias_read <= 1;
                    //chuyển sang chu kỳ tiếp theo
                    counter <= counter + 1;
                end else if (counter < 9) begin
                    //các chu kỳ sau, chỉ load wgt và bias 
                    ifm_read <= 1;
                    wgt_read <= 0;
                    bias_read <= 0;
                    //chuyển sang chu kỳ tiếp theo
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                end  
                
                FULLY:
                if (counter < 1) begin
                    //chu kỳ đầu, cho phép load toàn bộ ifm, wgt và bias vào PE array
                    ifm_read <= 1;
                    wgt_read <= 1;
                    bias_read <= 1;
                    //chuyển sang chu kỳ tiếp theo
                    counter <= counter + 1;
                end else if (counter < 9) begin
                    //các chu kỳ sau, chỉ load wgt và bias 
                    ifm_read <= 1;
                    wgt_read <= 0;
                    bias_read <= 0;
                    //chuyển sang chu kỳ tiếp theo
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                end  
            endcase           
        end
    end
    
    //calculate
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
        end else begin
            
        end
    end
    
    //write back  
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
        end else begin
            
        end
    end
    
endmodule
