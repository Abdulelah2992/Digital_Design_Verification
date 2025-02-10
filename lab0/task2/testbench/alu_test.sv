
module register_test;
timeunit 1ns;
timeprecision 100ps;

logic [7:0]   a  ;
logic [7:0]   b ;
logic [7:0]   out ;
logic [2:0]   opcode ;
logic         zero ;
logic         clk = 1'b1;

`define PERIOD 10

always
    #(`PERIOD/2) clk = ~clk;

// INSTANCE register 
 alu al1 (
    .opcode(opcode),
    .clk(clk),
    .out(out),
    .a(a),
    .b(b),
    .zero(zero)
);


  // Monitor Results
  initial
    begin
     $timeformat ( -9, 1, " ns", 9 );
     $monitor ( "time=%t opcode=%b a=%b b=%b out=%h zero=%b",
	        $time,   opcode,   a,   b,   out,  zero );
     #(`PERIOD * 99)
     $display ( "ALU TEST TIMEOUT" );
     $finish;
    end

// Verify Results
  task expect_test (input [7:0] expects) ;
    if ( out !== expects )
      begin
        $display ( "out=%b, should be %b", out, expects );
        $display ( "REGISTER TEST FAILED" );
        $finish;
      end
  endtask

  initial
    begin
      @(posedge clk)
      { opcode, a, b } = 19'b000_00000001_00000010; @(negedge clk) expect_test ( 8'h03 );
      { opcode, a, b } = 19'b001_00000100_00000010; @(negedge clk) expect_test ( 8'h02 );
      { opcode, a, b } = 19'b010_00000101_00000010; @(negedge clk) expect_test ( 8'h0A );
      { opcode, a, b } = 19'b011_00000001_00000010; @(negedge clk) expect_test ( 8'h03 );
      { opcode, a, b } = 19'b100_00001001_00000011; @(negedge clk) expect_test ( 8'h01 );
      { opcode, a, b } = 19'b101_00000001_00000010; @(negedge clk) expect_test ( 8'h03 );
      { opcode, a, b } = 19'b110_00000001_00000010; @(negedge clk) expect_test ( 8'h04 );
      { opcode, a, b } = 19'b111_00000001_00000010; @(negedge clk) expect_test ( 8'h00 );

      $display ( "REGISTER TEST PASSED" );
      $finish;
    end
endmodule
