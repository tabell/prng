`timescale 1ns / 1ps

module mult_tb;


	parameter in_width = 32;
	parameter out_width = in_width*2;

	// Inputs
	reg [in_width-1:0] data_multiplicand;
	reg [in_width-1:0] data_multiplier;
	reg ctrl_enable;
	reg clk;
	reg rst;

	// Outputs
	wire [out_width-1:0] data_result;
	wire ctrl_done;

	// Instantiate the Unit Under Test (UUT)
	mult #(in_width) uut (
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

		// $monitor("%g: a=%b, b=%b, en=%g, done=%g, res=%g", $time,
		// $monitor("%g: a=%g, b=%g, en=%g, done=%g, res=%g", $time,
		// 	data_multiplicand,data_multiplier,ctrl_enable,ctrl_done,data_result);
		#110; // Wait 100 ns for global reset to finish
		$display("%g: RESET OVER",$time);
		#10 rst <= 0;
		data_multiplicand <= 7;
		data_multiplier <= 5;
		// #10;
		ctrl_enable <= 1;
		while (ctrl_done == 0) begin
			#10;
		end
		ctrl_enable <= 0;
		if (data_result != data_multiplicand*data_multiplier) $error("\033[1;31m[ERROR]\033[0m wrong result");
		#10;
		data_multiplicand <= 500;
		data_multiplier <= 111;
		#100 ctrl_enable <= 1;
		while (ctrl_done == 0) begin
			#10;
		end
		if (data_result != data_multiplicand*data_multiplier) $error("\033[1;31m[ERROR]\033[0m wrong result");
		$finish;

	end
	always begin // create clock
		#10 clk <= ~clk;
	end
      
endmodule

