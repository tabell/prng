`timescale 1ns / 1ps

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
  integer counter = 0;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		m = 2147483647;
		a = 16807;
		seed = 1346601079;
		start = 0;
		cont = 0;
    counter = 0;

		// Wait 100 ns for global reset to finish
		#100;
    $display("%g: Starting sim",$time);
		rst <= 0;
        
		// Add stimulus here
		// sel <= 1;

//    $monitor("rand=%.10g, start=%g, done=%g, cont=%g",rand,start,done,cont);
    while (counter < 10) begin

		  #100 start <=1; // start generation
      counter <= counter + 1;
      while (done == 0) begin // loop until done
        #100;// $display("%g: done",$time);
      end
      start <= 0;
      #100;
      while (done == 1) begin // loop until done signal deasserted
      #100;
      end

      seed <= rand;
      $display("%g: rand=%.10g, start=%g, done=%g, cont=%g",$time,rand,start,done,cont);
      #50;
    end
   // #100000;
    $finish;

	end

	always #50 clk <= ~clk;
      
endmodule

