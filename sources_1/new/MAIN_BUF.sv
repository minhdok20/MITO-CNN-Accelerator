`timescale 1ns / 1ps

module MAIN_BUF #(parameter INPUT_WIDTH = 32,
                            OUTPUT_WIDTH = 8,
                            
                            NUM_OF_OUTPUTS = 9,
                            
                            IFM = 2'b01,
                            WGT = 2'b10,
                            BIAS = 2'b11)

                 (clk, rst_n, start_signal, ready_load, main_input, main_output_ifm, main_output_wgt, main_output_bias);

    input clk, rst_n, start_signal;
    input signed [INPUT_WIDTH-1:0] main_input;
    
    output reg ready_load;
    output reg signed [OUTPUT_WIDTH-1:0] main_output_ifm [NUM_OF_OUTPUTS-1:0];
    output reg signed [OUTPUT_WIDTH-1:0] main_output_wgt [NUM_OF_OUTPUTS-1:0];
    output reg signed [OUTPUT_WIDTH-1:0] main_output_bias;
    
    wire signed [INPUT_WIDTH-1:0] wire_ifm;
    wire signed [INPUT_WIDTH-1:0] wire_wgt;
    wire signed [INPUT_WIDTH-1:0] wire_bias;
    
    reg [7:0] counter;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            if (counter > 6)
                counter <= 0;
            else 
                counter <= counter + 1;
        end
    end
    
    reg [1:0] sel;
    wire valid_read_ifm;
    wire valid_read_wgt;
    wire valid_read_bias;
    
    always_comb begin
        if (counter >= 0 && counter <= 2) begin
            sel = IFM;
            ready_load = 0;            
        end else if (counter >= 3 && counter <= 5) begin
            sel = WGT;
            ready_load = 0;
        end else if (counter == 6) begin
            sel = BIAS;
            ready_load = 1;
        end else begin
            sel = 0;
            ready_load = 0;
        end
    end
    
    assign valid_read_ifm = (sel == IFM) ? 1 : 0;
    assign valid_read_wgt = (sel == WGT) ? 1 : 0;
    assign valid_read_bias = (sel == BIAS) ? 1 : 0;
            
    DEMUX_1_TO_3 demux1 (.clk(clk), .rst_n(rst_n), .sel(sel), .demux_input(ifm_input), .demux_output_ifm(wire_ifm), .demux_output_wgt(wire_wgt), .demux_output_bias(wire_bias));

    IFM_BUF ifmBuf (.clk(clk), .rst_n(rst_n), .valid_read(valid_read_ifm), .ifm_input(wire_ifm), .ifm_output(main_output_ifm));
    WGT_BUF wgtBuf (.clk(clk), .rst_n(rst_n), .valid_read(valid_read_wgt), .wgt_input(wire_wgt), .wgt_output(main_output_wgt));
    BIAS_BUF biasBuf (.clk(clk), .rst_n(rst_n), .valid_read(valid_read_bias), .bias_input(wire_bias), .bias_output(main_output_bias));
    
    
endmodule