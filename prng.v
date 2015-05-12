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
	input [31:0] m, // initially 2^31 - 1 = 2,147,483,647
	input [31:0] a, // initially 16,807
	input [31:0] seed, // initially 5,7,9,11
	input start,
	input cont,
	output reg done,
	output reg [31:0] rand
);


reg [2:0] state; 
reg [15:0] param_a;
reg [31:0] param_m;
reg [31:0] quot;
reg [31:0] rem;
reg [31:0] y;
reg [31:0] z;
reg [31:0] q;
reg [31:0] r;
reg [31:0] s;
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



div div0 (
	.clk	(clk),
    .en	(div_start),
    .y	(div_y),
    .x	(div_x),
    .q	(div_q),
    .r	(div_r),
    .done	(div_done)
);

// always @(sel) begin
// 	if (sel == 0) int_seed <= 5;
// 	if (sel == 1) int_seed <= 7;
// 	if (sel == 2) int_seed <= 9;
// 	if (sel == 3) int_seed <= 11;
// end

// always @(state) begin // multiplexors
// 	case (state)
// 		1 : begin

// 		end
// 		2 : begin

// 		end
// 		5 : begin

// 		end
// 		default : begin
// 			div_y <= 32'bZ;;
// 			div_x <= 32'bZ;;
// 			// div_q <= div_q;
// 			// div_r <= div_r;
// 		end
// 	endcase // state
// end


always @(posedge clk) begin
	if(rst) begin
		q <= 0;
		r <= 0;
		y <= 0;
		z <= 0;
		state <= 0;
		s <= 0;
		done <= 0;
		int_seed <= 0;
		param_a <= 16'h41a7; // 16807
		param_m <= {0 & 31{1'b1}}; // 2^31 - 1
		quot <= 127773;
		rem <= 2836;
		div_start <= 0;
	end else begin
		if (div_start == 1) div_start <= 0;



		 if (state == 0) begin  // 0 - idle
		 	if (start == 1) begin
		 		// store in case inputs change
		 		param_m <= m;
		 		param_a <= a;
		 		if (cont == 0)
		 			int_seed <= seed;
		 		else
		 			int_seed <= s;
		 		// start first op
				div_start <= 1;
				div_y <= m;
				div_x <= a;
		 		state <=1;
		 	end 
		 end
		 if (state == 1) begin // 1 - division 1
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
		 if (state == 2) begin // 2 - division 2
		 	if (div_done == 1) begin
		 		state <= 3;
				z <= div_q;
				y <= div_r;
				m1 <= param_a*div_r;
				m2 <= div_q*r;
		 	end
		 end
		 if (state == 3) begin // 3 - multiplication
			state <= 4;
			sub_res <= $signed(m1) - $signed(m2);
		 end
		 if (state == 4) begin // 4 - subtraction
			state <= 5;
			div_y <= sub_res;
			div_x <= param_m;
	 		div_start <= 1;
		 end
		 if (state == 5) begin // 5 - division 3
		 	if (div_done == 1) begin
				s <= div_r;
				rand <= div_r;
				$display("Generated random number %i",div_r);
		 		state <= 0;
		 	end
			// int_seed <= 
		 end

	end
end

endmodule