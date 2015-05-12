`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:38:49 05/11/2015
// Design Name:   prng
// Module Name:   /home/alex/verilog/prng/tb_prng.v
// Project Name:  prng
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: prng
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_prng;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] m;
	reg [31:0] a;
	reg [31:0] seed;
	reg start;
	reg cont;

	// Outputs
	wire done;
	wire [31:0] rand;

	// Instantiate the Unit Under Test (UUT)
	prng uut (
		.clk(clk), 
		.rst(rst), 
		.m(m), 
		.a(a), 
		.seed(seed), 
		.start(start), 
		.cont(cont), 
		.done(done), 
		.rand(rand)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		m = 2147483647;
		a = 16807;
		seed = 1346601079;
		start = 0;
		cont = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst <= 0;
        
		// Add stimulus here
		// sel <= 1;

		#50 start <=1;
		#3500 cont <=1 ;

	end

	always #50 clk <= ~clk;
      
endmodule

