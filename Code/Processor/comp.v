`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:49:38 02/13/2015 
// Design Name: 
// Module Name:    comp 
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
module comp(
input [4:0]a,
input [2:0]b,
input [3:0]op,
output s
    );
wire s_inter;
wire [2:0]w1;
assign w1=(~(a[2:0])|b)&((a[2:0])|~b);
assign s_inter=w1[0]&w1[1]&w1[2]&(a[4]|a[3]);
assign s=s_inter&(op[3]&op[2]&op[1]&~op[0]);

endmodule
