// module prng (

// 	input [1:0] sel, // [1:0]  IN Select a PRNG seed
// 	input p2s_ready, //   IN Parallel-to-serial converter status
// 	input clk, //   IN System clock
// 	input start, //   IN Start the PRNG processor
// 	input reset, //   IN Global reset
// 	output reg [31:0] s, // [31 : 0] OUT Calculated random number
// 	output reg [31:0] seed, // [31:0] OUT Selected initial seed
// 	output reg prng_done //   OUT PRNG is finished
// 	// output reg prng_ready //   OUT PRNG is busy calculating // TODO: what is this for?
// );

module prng (
	input clk,    // Clock
	input rst,  // reset
	input [31:0] seed, // initially 5,7,9,11
	input start,
	input cont,
	output reg done,
	output reg [31:0] rand
);


reg [3:0] state; 
reg [15:0] param_a;
reg [31:0] param_m;
reg [31:0] quot;
reg [31:0] rem;
reg [31:0] y;
reg [31:0] z;
reg [31:0] q;
reg [31:0] r;
//reg [31:0] s;
reg [31:0] m1;
reg [31:0] m2;
reg [31:0] sub_res;
reg [31:0] int_seed; // internal seed

reg [31:0] div_y;
reg [31:0] div_x;
wire [31:0] div_q;
wire [31:0] div_r;
reg div_start;
wire div_done;

reg [31:0] sub_a;
reg [31:0] sub_b;
reg [31:0] sub_out;

reg [31:0] mult_in_a;
reg [31:0] mult_in_b;
reg mult_enable;
wire mult_done;
wire [31:0] mult_out;

div div0 (
	.clk	(clk),
    .en	(div_start),
    .y	(div_y),
    .x	(div_x),
    .q	(div_q),
    .r	(div_r),
    .done	(div_done)
);

mult #(32) mult0 (
	.data_multiplicand(mult_in_a),
	.data_multiplier(mult_in_b),
	.data_result(mult_out),
	.ctrl_enable(mult_enable),
	.ctrl_done(mult_done),
	.rst(rst),
	.clk(clk)
	);

always @(posedge clk) begin
	if(rst) begin
		// $monitor("%g: state: %g",$time, state);
		q <= 0;
		r <= 0;
		y <= 0;
		z <= 0;
		state <= 0;
		done <= 0;
		int_seed <= 0;
		param_a <= 16'h41a7; // 16807
		param_m <= {{1'b0},{31{1'b1}}}; // 2^31 - 1
		quot <= 127773;
		rem <= 2836;
		div_start <= 0;
	end else begin
		if (div_start == 1) div_start <= 0;
		 if (state == 0) begin  // 0 - idle
		 	if (start == 1) begin
		 		// store in case inputs change
		 	  int_seed <= seed;
		 		// start first op
				div_start <= 1; // this division is not necessary as per gebali in class june 25
				div_y <= param_m;
				div_x <= param_a;
		 		state <=1;
		 	end 
      else done <= 0;
		 end
		 if (state == 1) begin //
		 	if (div_done == 1) begin
		 		// finish this division
				q <= div_q;
				r <= div_r;
		 		// start next div
		 		state <= 2;
		 		div_start <= 1;
				div_y <= int_seed; // s0 on first pass
				div_x <= div_q; // operand forwarding
		 	end
		 end
		 if (state == 2) begin //
		 	if (div_done == 1) begin
		 		state <= 3;

				z <= div_q;
				y <= div_r;

				mult_in_a <= param_a;
				mult_in_b <= div_r;
				mult_enable <= 1;

				// temp bypass
				// m1 <= param_a*div_r;
				// m2 <= div_q*r;

		 	end
		 end
		 if (state == 3) begin
		 	if (mult_done == 1) begin
			 	state <= 4;
			 	mult_enable <= 0;
				m1 <= mult_out;
				$display("Got a correct result");
			end
		 end
		 if (state == 4) begin
				state <= 5;
				mult_enable <= 1;
				mult_in_a <= div_q;
				mult_in_b <= r;
		 end
		 if (state == 5) begin 
		 	if (mult_done == 1) begin
				m2 <= mult_out;
				state <= 6;
				mult_enable <= 0;
			end
		 end
		 if (state == 6) begin //
			state <= 7;
			sub_res <= $signed(m1) - $signed(m2);
		 end
		 if (state == 7) begin //
			state <= 8;
			div_y <= sub_res;
			div_x <= param_m;
	 		div_start <= 1;
		 end
		 if (state == 8) begin //
		 	if (div_done == 1) begin
				rand <= div_r;
		 		state <= 0;
        	done <= 1;
		 	end
		 end

	end
end

endmodule
