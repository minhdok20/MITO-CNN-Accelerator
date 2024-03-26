`timescale 1ns / 1ps

// *******************************************************************************************
// ** MODULE MAIN BUFFER **
module  MAIN_BUF 
    // --- Parameters ---
  #(parameter                                   REGISTER_WIDTH          = 32,
                                                OUTPUT_IFM_WIDTH        = 8,
                                                OUTPUT_WGT_WIDTH        = 8,
                                                OUTPUT_BIAS_WIDTH       = 32,
                                                NUM_OF_PE_BLKS          = 9
   )
    // --- I/O ---
   (input                                       clk, 
    input                                       rst_n, 
    input                                       fully_convol_signal,
    input logic signed  [REGISTER_WIDTH-1:0]    main_input, 
    output bit                                  ready_load, 
    output logic signed [OUTPUT_IFM_WIDTH-1:0]  main_output_ifm         [NUM_OF_PE_BLKS-1:0],
    output logic signed [OUTPUT_WGT_WIDTH-1:0]  main_output_wgt         [NUM_OF_PE_BLKS-1:0],
    output logic signed [OUTPUT_BIAS_WIDTH-1:0] main_output_bias
   );
    
    // --- Additional parameters --- 
    parameter                                   MAX_COUNTER             = INPUT_IFM_REG + INPUT_WGT_REG + INPUT_BIAS_REG;
    // --- Additional variables ---
    int                                         counter;


    logic               [1:0]                   sel;
    
    bit                                         valid_read_ifm;
    bit                                         valid_read_wgt;
    bit                                         valid_read_bias;

    logic signed        [REGISTER_WIDTH-1:0]    wire_ifm;
    logic signed        [REGISTER_WIDTH-1:0]    wire_wgt;
    logic signed        [REGISTER_WIDTH-1:0]    wire_bias;

    // --- Flip-flop set counter ---
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            counter <= 0;
            ready_load <= 0;
        end 
        else 
        begin
            if (counter > MAX_COUNTER - 1)
                counter <= 0;
            else 
                counter <= counter + 1;
        end
    end
    
    // --- Decode sel ---
    always @(counter or fully_convol_signal) 
    begin
        if (fully_convol_signal)
        begin
            if (counter >= 0 && counter <= INPUT_IFM_REG - 1) 
            begin
                sel = IFM;
                ready_load = 0;            
            end 
            else if (counter >= INPUT_IFM_REG && counter <= INPUT_IFM_REG + INPUT_WGT_REG - 1) 
            begin
                sel = WGT;
                ready_load = 0;
            end 
            else if (counter == MAX_COUNTER - 1)
            begin
                sel = BIAS;
                ready_load = 1;
            end 
            else 
            begin
                sel = 0;
                ready_load = 0;
            end
        end
    end
    
    assign  valid_read_ifm  =  (sel == IFM)  ? 1 : 0;
    assign  valid_read_wgt  =  (sel == WGT)  ? 1 : 0;
    assign  valid_read_bias =  (sel == BIAS) ? 1 : 0;

    // --- Connections ---        
    DEMUX_1_TO_3                              #(.INPUT_WIDTH            (REGISTER_WIDTH),
                                                .OUTPUT_WIDTH           (REGISTER_WIDTH)
                                               )
                        demux1                 (.sel                    (sel), 
                                                .demux_input            (main_input), 
                                                .demux_output_ifm       (wire_ifm), 
                                                .demux_output_wgt       (wire_wgt), 
                                                .demux_output_bias      (wire_bias)
                                               );

    IFM_BUF                                   #(.INPUT_WIDTH            (REGISTER_WIDTH),
                                                .OUTPUT_WIDTH           (OUTPUT_IFM_WIDTH),
                                                .NUM_OF_OUTPUTS         (NUM_OF_PE_BLKS)
                                               )          
                        ifmbuf                 (.clk                    (clk), 
                                                .rst_n                  (rst_n), 
                                                .valid_read             (valid_read_ifm), 
                                                .ifm_input              (wire_ifm), 
                                                .ifm_output             (main_output_ifm)
                                               );
    WGT_BUF                                   #(.INPUT_WIDTH            (REGISTER_WIDTH),
                                                .OUTPUT_WIDTH           (OUTPUT_WGT_WIDTH),
                                                .NUM_OF_OUTPUTS         (NUM_OF_PE_BLKS)
                                               )                        
                        wgtbuf                 (.clk                    (clk), 
                                                .rst_n                  (rst_n), 
                                                .valid_read             (valid_read_wgt), 
                                                .wgt_input              (wire_wgt), 
                                                .wgt_output             (main_output_wgt)
                                               );
    BIAS_BUF                                  #(.INPUT_WIDTH            (REGISTER_WIDTH),
                                                .OUTPUT_WIDTH           (OUTPUT_BIAS_WIDTH)
                                               )                                    
                        biasbuf                (.clk                    (clk), 
                                                .rst_n                  (rst_n), 
                                                .valid_read             (valid_read_bias), 
                                                .bias_input             (wire_bias), 
                                                .bias_output            (main_output_bias)
                                               );
      
endmodule
// *******************************************************************************************



// *******************************************************************************************
// ** SUBMODULES **
// -------------------------------------------------------------------------------------------
// DEMUX BLOCK
module DEMUX_1_TO_3 
    // --- Parameter ---
  #(parameter                                   INPUT_WIDTH             = 32,
                                                OUTPUT_WIDTH            = 32   
   )
    // --- I/O ---
   (input logic         [1:0]                   sel, 
    input logic         [INPUT_WIDTH-1:0]       demux_input, 
    output logic        [OUTPUT_WIDTH-1:0]      demux_output_ifm, 
    output logic        [OUTPUT_WIDTH-1:0]      demux_output_wgt, 
    output logic        [OUTPUT_WIDTH-1:0]      demux_output_bias
   );

    // --- Selection ---     
    always @(sel) begin
        case (sel)
            IFM: begin
                demux_output_ifm = demux_input;
                demux_output_wgt = 'bx;
                demux_output_bias = 'bx;
            end
            
            WGT: begin
                demux_output_ifm = 'bx;
                demux_output_wgt = demux_input;
                demux_output_bias = 'bx;
            end
            
            BIAS: begin
                demux_output_ifm = 'bx;
                demux_output_wgt = 'bx;
                demux_output_bias = demux_input;
            end
            
            default: begin
                demux_output_ifm = 'bx;
                demux_output_wgt = 'bx;
                demux_output_bias = 'bx;
            end
        endcase
    end
endmodule
// -------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------
// INPUT FEATURE MAP BUFFER
module IFM_BUF 
    // --- Parameters ---
  #(parameter                                   INPUT_WIDTH             = 32,
                                                OUTPUT_WIDTH            = 8, 
                                                NUM_OF_OUTPUTS          = 9 
   )      
    // --- I/O ---    
   (input logic                                 clk, 
    input logic                                 rst_n, 
    input logic                                 valid_read, 
    input logic         [INPUT_WIDTH-1:0]       ifm_input, 
    output logic signed [OUTPUT_WIDTH-1:0]      ifm_output              [NUM_OF_OUTPUTS-1:0]
   );

    // --- Additional variables ---
    logic       [7:0]   H_or_V;
    logic       [2:0]   shift_mode;

    int                 counter;
    
    // --- Flip-flops determine shift mode and load data to PE array ---
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            counter <= 0;
            shift_mode <= ALL;
            for (int i = 0; i < NUM_OF_OUTPUTS; i++) 
            begin
                ifm_output[i] <= 'bx;
            end
        end 
        else 
        begin
            if (valid_read) begin
                case (shift_mode)
                    ALL: 
                    begin
                        if (counter == 0) 
                        begin
                            counter       <= 1;
                            ifm_output[0] <= ifm_input[23:16];
                            ifm_output[3] <= ifm_input[15:8];
                            ifm_output[6] <= ifm_input[7:0];
                        end 
                        else if (counter == 1) 
                        begin
                            counter       <= 2;
                            ifm_output[1] <= ifm_input[23:16];
                            ifm_output[4] <= ifm_input[15:8];
                            ifm_output[7] <= ifm_input[7:0];
                        end 
                        else if (counter == 2) 
                        begin
                            counter       <= 0;
                            ifm_output[2] <= ifm_input[23:16];
                            ifm_output[5] <= ifm_input[15:8];
                            ifm_output[8] <= ifm_input[7:0];
                        end
                        else
                        begin 
                            counter       <= 0;
                        end
                    end
                    
                    RIGHT: 
                    begin
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
                    
                    LEFT: 
                    begin
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
                    
                    DOWN: 
                    begin
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
                    
                    default: 
                    begin
                        for (int i = 0; i < NUM_OF_OUTPUTS; i++) 
                        begin
                            ifm_output[i] <= ifm_output[i];
                        end
                    end
                endcase
            end 
            else 
            begin
                for (int i = 0; i < NUM_OF_OUTPUTS; i++) 
                begin
                    ifm_output[i] <= ifm_output[i];
                end
            end
        end
    end
    
    // --- Decode shift mode --- 
    always @(ifm_input[31:24])
    begin
        H_or_V = ifm_input[31:24];
        case (H_or_V)
            8'b00000000: 
            begin
                shift_mode = ALL; 
            end
            
            8'b00000001:
            begin
                shift_mode = RIGHT; 
            end
            
            8'b00000010: 
            begin
                shift_mode = LEFT;
            end
            
            8'b11111111: 
            begin
                shift_mode = DOWN;
            end
            
            default: 
            begin
                shift_mode = ALL;
            end
        endcase
    end
endmodule
// -------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------
// WEIGHT BUFFER
module WGT_BUF
    // --- Parameters ---
  #(parameter                                   INPUT_WIDTH             = 32,
                                                OUTPUT_WIDTH            = 32,
                                                NUM_OF_OUTPUTS          = 9
   ) 
    // --- I/O ---
   (input logic                                 clk, 
    input logic                                 rst_n,
    input logic                                 valid_read,
    input logic         [INPUT_WIDTH-1:0]       wgt_input,
    output logic signed [OUTPUT_WIDTH-1:0]      wgt_output              [NUM_OF_OUTPUTS-1:0]
   );
    // --- Additional variables --- 
    int                 counter;   
    int                 i;

    // --- Load data to PE array ---
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n)     
        begin
            for (i = 0; i < NUM_OF_OUTPUTS; i++) 
            begin
                wgt_output[i] <= 'bx;
            end
        end 
        else 
        begin
            if(valid_read) 
            begin
                if (counter == 0) 
                begin
                    counter       <= 1;
                    wgt_output[0] <= wgt_input[23:16];
                    wgt_output[3] <= wgt_input[15:8];
                    wgt_output[6] <= wgt_input[7:0];
                end 
                else if (counter == 1) 
                begin
                    counter       <= 2;
                    wgt_output[1] <= wgt_input[23:16];
                    wgt_output[4] <= wgt_input[15:8];
                    wgt_output[7] <= wgt_input[7:0];
                end 
                else if (counter <= 2) 
                begin
                    counter       <= 0;
                    wgt_output[2] <= wgt_input[23:16];
                    wgt_output[5] <= wgt_input[15:8];
                    wgt_output[8] <= wgt_input[7:0];
                end
                else 
                begin
                    counter       <= 0;
                end
            end 
            else 
            begin
                for (i = 0; i < NUM_OF_OUTPUTS; i++) 
                begin
                    wgt_output[i] <= wgt_output[i];
                end
            end
        end
    end   
endmodule
// -------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------
// BIAS BUFFER
module BIAS_BUF 
    // --- Parameters ---
  #(parameter                                   INPUT_WIDTH             = 32,
                                                OUTPUT_WIDTH            = 32
   )
    // --- I/O --- 
   (input logic                                 clk, 
    input logic                                 rst_n,
    input logic                                 valid_read,
    input logic         [INPUT_WIDTH-1:0]       bias_input,
    output logic signed [OUTPUT_WIDTH-1:0]      bias_output
   );                       
    
    // --- Load data --- 
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            bias_output <= 'bx;
        end 
        else 
        begin
            if (valid_read) 
            begin
                bias_output <= bias_output;
            end 
            else 
            begin
                bias_output <= bias_input;
            end
        end
    end
    
endmodule
// -------------------------------------------------------------------------------------------
// *******************************************************************************************