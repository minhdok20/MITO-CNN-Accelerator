`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 04:19:24 PM
// Design Name: 
// Module Name: mul_
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



module mul_ (
	input [15:0] in1,
	input [15:0] in2,
	input start,
	input reset,
	input clk,

	output reg [31:0] out,
	output reg done
);


parameter IDLE = 2'b00, RUN = 2'b01, DONE = 2'b10; 

reg [1:0] state, next_state;

reg load,clear;
reg [31:0] partial,par_out_a;
reg [15:0] par_out_b;
reg [5:0] count;


always@ (posedge clk, posedge reset)				//SHIFT REGISTER A 32 bit
begin 
	if (reset == 1'b1)
		par_out_a <= 32'd0;
	else if(load == 1'b1)
		par_out_a <= {16'd0,in1}; 	
	else	
		par_out_a <= {par_out_a[30:0],1'b0};
				
end

always@ (posedge clk, posedge reset)				//SHIFT REGISTER B 16 bit
begin
	if (reset == 1'b1)
		par_out_b <= 16'd0;
	else if(load == 1'b1)
		par_out_b <= in2; 	
	else	
		par_out_b <= {1'b0, par_out_b[15:1]};
				
end

always@ (par_out_b,par_out_a)					//MULTIPLEXER
begin
	if(par_out_b[0] == 1'b0)
		partial <= 32'd0;
	else
		partial <= par_out_a;
end

always@ (posedge clk, posedge reset)				//ACCUMULATOR
begin
	if (reset == 1'b1 || clear)
		out <= 32'd0;
	else
		out <= out+partial;
end;


always@ (posedge clk, posedge reset)				//COUNTER
begin
	if (reset == 1'b1 || state!=RUN)
		count <= 5'b10001;
	else 
		count <= count-5'b00001;
end;

always@ (posedge clk, posedge reset)				//STATE REGISTER
begin
	if (reset == 1'b1)
		state <= IDLE;
	else
		state <= next_state;
end;


always@ (start,count,state)					//FSM COMB
begin
	case(state)
		IDLE:
		begin
			if(start == 1)
				next_state <= RUN;
			else
				next_state <= IDLE;
			
			load <= 0;
			clear <= 1;
			done <= 0;
		end
		
		RUN:
		begin
			if(count == 5'b00000)
				next_state <= DONE;
			else
				next_state <= RUN;
			
			if(count == 5'b10000) 
				load <= 1;
			else
				load <= 0;
			clear <= 0;
			done <= 0;
		end

		DONE:
		begin
			next_state <= IDLE;
			load <= 0;
			clear <= 0;
			done <= 1;
		end
		
		default:
		begin
			next_state <= IDLE;
			load <= 0;
			clear <= 1;
			done <= 0;
		end
		
	endcase
end
	
endmodule