`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:39:52 10/05/2014 
// Design Name: 
// Module Name:    black_box 
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
module black_box(
	input a,b,c,d,
	output x,y
    );
	 
assign x=a|(b&c);
assign y=b&d;
	 
endmodule
