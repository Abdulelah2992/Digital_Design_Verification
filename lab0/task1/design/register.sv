module register(
    input logic [7:0]data,
    input logic enable,
    input logic clk,
    input logic rst_,
    output logic [7:0]out
);

always @(posedge clk ,negedge rst_)
 begin
    if(!rst_)
        out<=0;
    else if(enable==1)
        out<=data;
     
 end


endmodule