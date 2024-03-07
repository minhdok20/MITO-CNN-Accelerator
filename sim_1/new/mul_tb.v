`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 04:26:38 PM
// Design Name: 
// Module Name: mul_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns/1ps

module mul_tb ();
  
   reg RESET;
   reg CLK;
   reg START;
   wire [31:0] OUT;
   wire DONE;
   reg [15:0] IN1;   
   reg [15:0] IN2;

   mul_ DUT(.clk(CLK), .reset(RESET), .start(START), .in1(IN1), .in2(IN2), .out(OUT), .done(DONE));
   
   always
     begin 
        #5 CLK = !CLK;
     end
   
   initial
     begin
        CLK = 0;
        RESET = 0;
	START = 0;        

        #2 RESET = 1;
        
        @(negedge CLK);
        
	RESET = 0;
	
        @(negedge CLK);
        
	IN1 = 16'd8648;
	IN2 = 16'd2301;

	// expected out: 19899048

        @(negedge CLK);

	START = 1;

	@(negedge CLK);

	@(negedge CLK);

	@(negedge CLK);

	START = 0;

	#200
     
        $stop;
     end
   
endmodule