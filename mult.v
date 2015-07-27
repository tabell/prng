`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:51:58 06/23/2015 
// Design Name: 
// Module Name:    mult 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mult#(
	parameter in_width = 4,
	parameter out_width = in_width*2)
	(
    input [in_width-1:0] data_multiplicand,
    input [in_width-1:0] data_multiplier,
    output reg [in_width-1:0] data_result,
    input ctrl_enable,
    output reg ctrl_done,
    input rst,
    input clk
    );

	reg [in_width-1:0] a;
	reg [in_width-1:0] b;

	reg [1:0] state;

	
	
	integer accum,i,j;
	reg[out_width-1:0] pp;

always @(posedge clk) begin : proc_mult
	if (rst == 1) begin
		state <= 0;
		ctrl_done <= 0;
	end else begin
		if (state == 0) begin
			if(ctrl_enable == 1) begin 
				state <= 1;
			end
		end
		if (state == 1) begin
			// sample inputs on trigger
			a <= data_multiplicand;
			b <= data_multiplier;
			ctrl_done <= 0;
			state <= 2;
			i <= 0;
			accum <= 0;
		end
		if(state == 2) begin
			if (i > 31) begin
				state <= 3;
			end else begin
				if (a[i] != 0) begin
					accum <= accum + (b<<i);
				end
				i <= i + 1;
			end
		end
		if(state == 3) begin
			data_result <= accum[31:0];
			if (ctrl_enable == 0) begin
				state <= 0;
				ctrl_done <= 0;
			end else begin
				ctrl_done <= 1;
			end
		end
	end
end


endmodule
