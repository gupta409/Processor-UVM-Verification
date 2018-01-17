`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:03:35 02/14/2015 
// Design Name: 
// Module Name:    inst_mem 
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
module inst_mem(
input [7:0]a,					//Memory Address
output  [15:0]r					//Memory data output
); 

reg [15:0]rom[255:0];				//declaration of 256X16 memory
 
 initial $readmemh("instructions.txt",rom);	//Read and copy hex code from text file to memory 
 assign r = rom[a];				//Read from memory

endmodule

