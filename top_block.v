`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:39 07/25/2015 
// Design Name: 
// Module Name:    top_block 
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
module top_block(
input clk, 
input reset, 
input start, 
input test_word_TX, 
input test_byte_TX, 
output reg PRNG_busy, 
output UA_TX_ready, 
input [2:0] baud_sel, 
input [1:0] seed_sel, 
output bit_out
    );

reg [31:0] seed;
wire [31:0] rand;
reg [31:0] test_var;

UA_TX  serial0 (
    .seed(seed), 
    .s(rand), 
    .prng_done(done), 
    .baud_sel(baud_sel), 
    .clk(clk), 
    .reset(reset), 
    .test_word_TX(test_word_TX), 
    .test_byte_TX(test_byte_TX), 
    .UA_TX_ready(UA_TX_ready), 
    .bit_out(bit_out)
    );

prng prng0 (
    .clk(clk), 
    .rst(reset), 
    .seed(seed), 
    .start(start), 
    .cont(cont), 
    .done(done), 
    .rand(rand)
    );

always begin
case (seed_sel)
0 :  seed = 2072086837;
1 :  seed = 338579150;
2 :  seed = 1749629467;
3 :  seed = 1945185409 ;
default: seed = 123;
endcase
PRNG_busy <= ~done;
test_var <= 55;
end
endmodule
