

module mem_test ( input logic clk, 
                  output logic read, 
                  output logic write, 
                  output logic [4:0] addr, 
                  output logic [7:0] data_in,     // data TO memory
                  input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata [0:31];      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

task write_mem(input logic [4:0] address,input logic [7:0] in, bit debug = 0);
@(negedge clk) write <= 1; read <= 0; data_in <= in; addr <= address;
  if(debug==1)
   @(negedge clk) $display("address %d = %d",addr,data_in);
endtask

task read_mem(input logic [4:0] address, bit debug = 0);
@(negedge clk) write <= 0; read <= 1; addr <= address;
  if(debug==1)
   @(negedge clk) $display("address %d = %d",addr,data_out);
endtask



function void printstatus(int error_status);
if(error_status==0)
$display("test passed");
else $display("test faild;%d",error_status);
endfunction 

initial
  begin: memtest
  int error_status;

    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
      begin
       // Write zero data to every address location
       rdata[i]=$urandom_range(0, 255);
        write_mem(i,rdata[i],debug);
        
      end
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
        read_mem(i,debug);
        if(!(data_out==rdata[i]))
          error_status++;
       // check each memory location for data = 'h00

      end
        printstatus(error_status);

   // print results of test

//    $display("Data = Address Test");

//    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
       
//    for (int i = 0; i<32; i++)
//      begin
       // Read every address location

       // check each memory location for data = address

//      end

   // print results of test

    $finish;
  end

// add read_mem and write_mem tasks

// add result print function

endmodule
