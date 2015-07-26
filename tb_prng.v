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


	reg [31:0] test_in [0:3];
	reg [31:0] test_out [0:3];


// reg [31:0] test_out [0:3] = '{


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
		// seed = 1346601079;
		// seed = 338579150;
		seed = 1749629467;
		// seed = 2072086837;
		start = 0;
		cont = 0;
    	counter = 0;

		test_in[0] = 32'h7B818935;
		test_in[1] = 32'h142E4ECE;
		test_in[2] = 32'h68493A1B;
		test_in[3] = 32'h73F12C81;

		test_out[0] = 32'h755735EB;
		test_out[1] = 32'h6C37C0BB;
		test_out[2] = 32'h1F85F81A;
		test_out[3] = 32'h5EA1049E;


		// Wait 100 ns for global reset to finish
		#100;
    $display("%g: Starting sim",$time);
		rst <= 0;
        
		// Add stimulus here
		// sel <= 1;

//    $monitor("rand=%.10g, start=%g, done=%g, cont=%g",rand,start,done,cont);
    while (counter < 4) begin
    	seed <= test_in[counter];
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
      if (rand != test_out[counter-1]) $error("\033[1;31m[ERROR]\033[0m wrong result");
      seed <= rand;
      $display("%g: seed=%.10h rand=%.10h, start=%g, done=%g, cont=%g",$time,seed,rand,start,done,cont);
      #50;
    end
   // #100000;
    $finish;

	end

	always #50 clk <= ~clk;
      
endmodule

