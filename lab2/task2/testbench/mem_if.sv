interface mem_if (input clk, input debug);
    logic       read;
    logic       write;
    logic [4:0] addr;
    logic [7:0] data_in;
    logic [7:0] data_out;
    
    modport MEM (input read, input write , input addr , input data_in ,  output data_out);
    modport TEST (output read, output write, output addr , output data_in , output data_out);

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


endinterface
