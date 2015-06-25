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
    output logic [out_width-1:0] data_result,
    input ctrl_enable,
    output logic ctrl_done,
    input rst,
    input clk
    );

	logic [in_width-1:0] a;
	logic [in_width-1:0] b;

	logic [1:0] state;

	// logic ctrl_done;
	// logic [out_width:0] data_result;
	
	
	integer accum;
	logic[out_width-1:0] pp;

always_ff @(posedge clk) begin : proc_mult
	if (rst == 1) begin
		state <= 0;
		ctrl_done <= 0;
	end else begin
		if(ctrl_enable) begin 
			if (state == 0) begin
				// sample inputs on trigger
				a <= data_multiplicand;
				b <= data_multiplier;
				state <= 1;
			end
			if(state == 1) begin
				accum = 0;
				for (int i = 0; i < in_width; i++) begin
					for (int j = 0; j < in_width; j++) begin
						pp = ((a[i] & b[j]));
						// if (pp != 0) begin
							// $display("%g: i=%g, j=%g a[i]=%b, b[j]=%b, pp=%b<<%g accum=%g",$time, 
							// i,j,a[i],b[j],a[i] & b[j],(i+j),accum);
						// end
						accum = accum + (pp<<(i+j));
					end
				end
				data_result <= accum;
				ctrl_done <= 1;
				state <= 0;
			end
		end
	end
end


endmodule
