`timescale 1ns / 1ps

module test(clk, rst_n, read, load, counter, reset_counter);

    input clk, rst_n, read, load;
    output reg [7:0] counter;
    
    output reg reset_counter;
    reg [7:0] next_counter;
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            counter <= 0;
            reset_counter <= 0;
        end else begin
            counter <= next_counter;
        end
    end
    
    always_comb begin
        if (read && !load && !reset_counter) begin
            next_counter = 0;
            reset_counter = 1;
        end else if (!read && load ) begin
        
        end else begin
            next_counter = counter + 1;
        end
    end

endmodule
