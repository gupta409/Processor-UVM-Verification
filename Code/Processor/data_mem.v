`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:13:56 02/13/2015 
// Design Name: 
// Module Name:    mem_unit 
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
module data_mem(
input [15:0]dM,
input [2:0]aM,
input clk,wr,
output reg [15:0]m
    );
reg [15:0]mem[7:0];	 
integer i;
	 initial 
	  for(i=0;i<8;i=i+1)
	  begin
	  mem[i]=0;
	  end
//Store
always@(posedge clk)
begin
 if(wr==1)
  mem[aM]=dM;
end	 

//Load
always@(negedge clk)
begin 
m=mem[aM];
end
endmodule
