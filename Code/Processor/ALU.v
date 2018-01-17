`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:48:12 02/12/2015 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
input [15:0]a,
input [15:0]b,
input [1:0]alu_sel,	//use of alu_sel 
input [1:0]s,			// 4 bits
input sel,
input [1:0]mul,
output [15:0]y,
output cout
    );  
wire [15:0]ar1,ar2,l1,l2,l3,l4,l5,l6,l7,l8,sh1,sh2,sh3,w1,w2,mul1;

wire k_mov=alu_sel[1]&~alu_sel[0]&~s[1]&s[0]; //For move;

//Arithmetic

assign ar1=((~({16{s[0]}}))&b)|((({16{s[0]}})^({16{s[1]}}))&~b)&({16{~k_mov}});	
Adder a1(a,ar1,(s[0]&(~k_mov)),ar2,cout);

//Logical
assign l1=a&b;
assign l2=a|b;
assign l3=a^b;
assign l4=a;
mux2_1_1bit m1[15:0](l1,l2,s[0],l5);
mux2_1_1bit m2[15:0](l3,l4,s[0],l6);
mux2_1_1bit m3[15:0](l5,l6,s[1],l7);
assign l8=l7^({16{sel}});

//Mulitplication
wire[7:0] wmul1,wmul2,wmul11,wmul22;
mux2_1_1bit mmul1[7:0](a[7:0],a[15:8],~mul[0],wmul1);
mux2_1_1bit mmul2[7:0](b[7:0],b[15:8],~mul[0],wmul2);
mux2_1_1bit mmul3[7:0]({8{1'b0}},wmul1,mul[0]|mul[1],wmul11);
mux2_1_1bit mmul4[7:0]({8{1'b0}},wmul2,mul[0]|mul[1],wmul22);
wallace_8bit m4(wmul11,wmul22,mul1); 

//Shifter
assign sh1=a<<b;
assign sh2=a>>b;
mux2_1_1bit m5[15:0](sh1,sh2,sel,sh3);

//Final Mux_logic
mux2_1_1bit m6[15:0](ar2,l8,alu_sel[0],w1);
mux2_1_1bit m7[15:0](mul1,sh3,alu_sel[0],w2);
mux2_1_1bit m8[15:0](w1,w2,alu_sel[1]&(~k_mov),y);

endmodule
