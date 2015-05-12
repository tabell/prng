`timescale 1ns / 1ps

module test1;

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

        y = 5;
        x = 16807;
      en <= 1;
      #20;
      en <= 0;
      // #200;
      // y <= 100;
      // x <= 3;
      // en <= 1;
      // #20;
      // en <= 0;
        
        // Add stimulus here

    end

    always #10 clk <= ~clk;
      
endmodule

