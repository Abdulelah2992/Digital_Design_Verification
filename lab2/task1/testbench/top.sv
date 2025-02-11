
module top;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic and bit data types
bit         clk;

mem_if mif(clk);

// SYSTEMVERILOG:: implicit .* port connections.
mem_test test ( .mif(mif.TEST));

// SYSTEMVERILOG:: implicit .name port connections
mem memory ( .mif(mif.MEM));

always #5 clk = ~clk;
endmodule
