`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:42:43 07/26/2015
// Design Name:   div
// Module Name:   /home/alex/verilog/prng_test3/div_tb.v
// Project Name:  prng_test3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module div_tb;

	// Inputs
	reg clk;
	reg en;
	reg [31:0] y;
	reg [31:0] x;

	// Outputs
	wire [31:0] q;
	wire [31:0] r;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	div uut (
		.clk(clk), 
		.en(en), 
		.y(y), 
		.x(x), 
		.q(q), 
		.r(r), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		en = 0;
		y = 0;
		x = 0;

		// Wait 100 ns for global reset to finish
		#100;
    
    y <= 65536;
    x <= 16;
    en <= 1;
    #20 en <= 0;
    
    while (done == 0) begin
    #20;
    end
    $finish;
    
        
		// Add stimulus here

	end
  always begin
  #10 clk <= ~clk;
  end
      
endmodule

