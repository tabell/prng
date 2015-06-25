`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:02:28 06/23/2015
// Design Name:   mult
// Module Name:   /home/alex/code/misc/mult/mult_tb.v
// Project Name:  mult
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mult
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mult_tb#(
	parameter in_width = 4,
	parameter out_width = in_width*2)
	;

	// Inputs
	logic [in_width-1:0] data_multiplicand;
	logic [in_width-1:0] data_multiplier;
	logic ctrl_enable;
	logic clk;
	logic rst;

	// Outputs
	wire [out_width-1:0] data_result;
	wire ctrl_done;

	// Instantiate the Unit Under Test (UUT)
	mult uut (
		.data_multiplicand(data_multiplicand), 
		.data_multiplier(data_multiplier), 
		.data_result(data_result), 
		.ctrl_enable(ctrl_enable), 
		.ctrl_done(ctrl_done), 
		.rst(rst),
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		data_multiplicand = 0;
		data_multiplier = 0;
		ctrl_enable = 0;
		clk = 0;
		rst = 1;

		$monitor("%g: a=%b, b=%b, en=%g, done=%g, res=%g", $time,
			data_multiplicand,data_multiplier,ctrl_enable,ctrl_done,data_result);
		#100; // Wait 100 ns for global reset to finish
		$display("%g: RESET OVER",$time);
		#10 rst <= 0;
		data_multiplicand <= 7;
		data_multiplier <= 5;
		#10 ctrl_enable <= 1;
		while (ctrl_done == 0) begin
			#10;
		end
		#10 ctrl_enable <= 0;
		assert(data_result == data_multiplicand*data_multiplier) else $error("\033[1;31m[ERROR]\033[0m wrong result");
		$finish;

	end
	always begin // create clock
		#5 clk <= ~clk;
	end
      
endmodule

