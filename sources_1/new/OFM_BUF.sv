`timescale 1ns / 1ps

// ***********************************************************************
// ** MODULE OFM BUFFER **
module OFM_BUF
    // --- Parameters ---
  #(parameter                               INPUT_WIDTH             = 8, 
                                            OUTPUT_WIDTH            = 32
   )
    // --- I/O ---                  
   (input logic                             clk, 
    input logic                             rst_n, 
    input logic                             sel,
    input logic                             ready_write,
    input logic     [INPUT_WIDTH-1:0]       input_activation,
    input logic     [INPUT_WIDTH-1:0]       input_pooling,
    output logic    [OUTPUT_WIDTH-1:0]      ofm_output,
    output logic                            finish,
    output logic                            flag_full_data_reg_output           
   );

    logic           [INPUT_WIDTH-1:0]       demux_output;
    int                                     counter;
    // --- Demux determine output based on select value ---
    always_comb 
    begin
        case (sel)
            FULLY_CONVOL: 
            begin
                demux_output = input_activation;
            end
            
            POOLING: 
            begin
                demux_output = input_pooling;
            end

            default: 
            begin
                demux_output = demux_output;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            ofm_output <= 'bx;
            finish <= 1'b1;
            counter <= 0;
            flag_full_data_reg_output <= 0;
        end 
        else 
        begin
            if (ready_write) 
            begin
                finish <= 1'b1;
                ofm_output[31:24] <= (sel) ? 8'b11111111 : 8'b00000000;
                if (counter <= 0) 
                begin
                    ofm_output[23:16] <= demux_output;
                    ofm_output[15:0] <= 'bx;
                    counter <= counter + 1;
                    flag_full_data_reg_output <= 0;
                end 
                else if (counter <= 1) 
                begin
                    ofm_output[15:8] <= demux_output;
                    counter <= counter + 1;
                    flag_full_data_reg_output <= 0;
                end 
                else if (counter <= 2) 
                begin
                    ofm_output[7:0] <= demux_output;
                    counter <= 0;
                    flag_full_data_reg_output <= 1;
                end
            end 
            else 
            begin 
                ofm_output <= ofm_output;
                finish <= 0;
            end            
        end
    end

endmodule
// ***********************************************************************
