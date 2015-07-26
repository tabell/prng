`timescale 1ns / 1ps
module div(
    input clk,
    input en,
    input [31:0] y,
    input [31:0] x,
    output reg [31:0] q,
    output reg [31:0] r,
    output reg done
    );

// internal
reg [31:0] orig_x; // storage for end of computation
reg [2:0]  state; // state machine of algorithm
reg [31:0] dividend; // number to divide
reg [31:0] divisor; // number to divide by
reg [5:0] m; // length of dividend in bits
reg [5:0] n; // length of divisor in bits
reg [4:0] i; // iteration counter
reg [4:0] i2; // iteration counter
reg [31:0] tmp_q;
reg [31:0] tmp2;
reg [4:0] tmp3;
reg trivial;
// outputs
// reg [31:0] q; // will converge to quotient
// reg [31:0] r; // will converge to remainder
// reg done; // active high, set on completion


always @(posedge clk) begin : proc_divide
	if(en) begin // reset the internal state and load new initial values
		state <= 0;
		done <= 0;
		dividend <= y;
		divisor <= x;
		orig_x <= x;
		tmp_q <= 0;
		r <= 0;
		trivial <= 0;
    i <= 0;

		for (i2 = 0; i2 < 31; i2 = i2 +1) begin
		  	if (y[i2] == 1) begin
		  		m <= i2;
		  	end
		  	if (x[i2] == 1) begin
		  		n <= i2;
		  	end
		end
	end else begin
		if (state == 0) begin 
			// FSM housekeeping
			i <= i + 1;
			done <= 0;
			// algorithm
			tmp3 <= $signed(m) - $signed(n);
			if ($signed($signed(m) - $signed(n)) < 0) begin
				state <= 3;
			end
			else state <= 1;
			tmp2 <= 0;
		end
		if (state == 1) begin 
			// FSM housekeeping
			i <= i + 1;
			if (i >= (m - n)) begin
				state <= 2;
			end
			// algorithm
			if ($signed(dividend) > 0) begin
				dividend <= dividend - (divisor << (m - n - i));
				tmp_q <= tmp_q + (1 << (m - n - i));
			end else begin
				dividend <= dividend + (divisor << (m - n - i));
				tmp_q <= tmp_q - (1 << (m - n - i));
			end
		end
		if (state == 2) begin 
			if ($signed(dividend) > $signed(divisor)) begin
				dividend <= ($signed(dividend) - $signed(divisor));
				tmp_q <= ($signed(tmp_q) + 1);
			end
			if ($signed(dividend) < 0) begin
				dividend <= ($signed(dividend) + $signed(divisor));
				tmp_q <= ($signed(tmp_q) - 1);
			end
			state <= 3;
		end
		if (state == 3) begin 
			r <= dividend;
			q <= tmp_q;
			if (tmp2 == 0) begin
				done <= 1;
				tmp2 <= 1;
			end
			else done <= 0;

			state <= 3; // think i wrote this so all control paths are defined
		end
		
	end
end

endmodule
