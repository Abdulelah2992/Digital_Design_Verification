module register_random_test1;
timeunit 1ns;
timeprecision 100ps;

logic [7:0]   a ;
logic [7:0]   b ;
logic [7:0]   out ;
logic [2:0]   opcode ;
logic         zero ;
logic         clk = 1'b1;

`define PERIOD 10

always
    #(`PERIOD/2) clk = ~clk;

// INSTANCE register 
 alu al1 (.opcode(opcode), .clk(clk), .out(out), .a(a), .b(b), .zero(zero));

  // Monitor Results
  initial
    begin
     $timeformat ( -9, 1, " ns", 9 );
     $monitor ( "time=%t opcode=%b a=%b b=%b out=%h zero=%b",
	        $time,   opcode,   a,   b,   out,  zero );
     #(`PERIOD * 99)
     $display ( "REGISTER TEST TIMEOUT" );
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
      @(negedge clk)
      opcode = 3'b000;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a+b); // enable is high so data should be written to register at posedge
      opcode = 3'b001;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a-b); // rst_ is low so register should now store 8'b0
      opcode = 3'b010;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a*b); // enable is high so data should be written to register at posedge      
      opcode = 3'b011;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a|b); // ..
      opcode = 3'b100;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a&b); // ..
      opcode = 3'b101;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a^b);
      opcode = 3'b110;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a<<b);
      opcode = 3'b111;  a = $random % 8'hFF;  b = $random % 8'hFF; @(negedge clk) expect_test (a>>b);
      
      $display ( "REGISTER TEST PASSED" );
      $finish;
    end
endmodule
