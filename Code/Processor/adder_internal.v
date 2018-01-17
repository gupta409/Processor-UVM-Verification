`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:41:49 02/15/2015 
// Design Name: 
// Module Name:    adder_internal 
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
module adder_internal(
input [7:0]a,
input [2:0]b,
output [7:0]y
    );
assign y=a+({{5{2'b0}},b});

endmodule
