

module mem_test ( mem_if mif);
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
logic [7:0] rdata [0:31];      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end


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
       //rdata[i]= 0;

        mif.write_mem(i,rdata[i],1);
        
      end
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
        mif.read_mem(i,1);
        if(!(mif.data_out==rdata[i]))
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
