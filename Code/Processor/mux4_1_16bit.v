`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:49:52 02/15/2015 
// Design Name: 
// Module Name:    mux4_1_16bit 
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
module mux4_1_16bit(
input [15:0]a,b,c,d,
input s0,s1,
output [15:0]y
    );
wire [15:0]w1,w2;
mux2_1_1bit m1[15:0](a,b,s0,w1);
mux2_1_1bit m2[15:0](c,d,s0,w2);
mux2_1_1bit m3[15:0](w1,w2,s1,y);


endmodule
