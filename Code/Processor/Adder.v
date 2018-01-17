`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    Adder 
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
module Adder(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] s,
    output cout
    );

wire [15:0]g,p,GG;

//Bitwise Generate And Propogate Signals.
assign g=a&b;
assign p=a^b;


//Group Generate And Propogate Signals.
assign GG[0]=g[0]|(p[0]&cin);
black_box b1(g[15],p[15],g[14],p[14],g1,p1);
black_box b2(g[14],p[14],g[13],p[13],g2,p2);
black_box b3(g[13],p[13],g[12],p[12],g3,p3);
black_box b4(g[12],p[12],g[11],p[11],g4,p4);
black_box b5(g[11],p[11],g[10],p[10],g5,p5);
black_box b6(g[10],p[10],g[9],p[9],g6,p6);
black_box b7(g[9],p[9],g[8],p[8],g7,p7);
black_box b8(g[8],p[8],g[7],p[7],g8,p8);
black_box b9(g[7],p[7],g[6],p[6],g9,p9);
black_box b10(g[6],p[6],g[5],p[5],g10,p10);
black_box b11(g[5],p[5],g[4],p[4],g11,p11);
black_box b12(g[4],p[4],g[3],p[3],g12,p12);
black_box b13(g[3],p[3],g[2],p[2],g13,p13);
black_box b14(g[2],p[2],g[1],p[1],g14,p14);
gray_box gb1(g[1],p[1],GG[0],GG[1]);

black_box b15(g1,p1,g3,p3,g15,p15);
black_box b16(g2,p2,g4,p4,g16,p16);
black_box b17(g3,p3,g5,p5,g17,p17);
black_box b18(g4,p4,g6,p6,g18,p18);
black_box b19(g5,p5,g7,p7,g19,p19);
black_box b20(g6,p6,g8,p8,g20,p20);
black_box b21(g7,p7,g9,p9,g21,p21);
black_box b22(g8,p8,g10,p10,g22,p22);
black_box b23(g9,p9,g11,p11,g23,p23);
black_box b24(g10,p10,g12,p12,g24,p24);
black_box b25(g11,p11,g13,p13,g25,p25);
black_box b26(g12,p12,g14,p14,g26,p26);
gray_box gb3(g13,p13,GG[1],GG[3]);
gray_box gb2(g14,p14,GG[0],GG[2]);

black_box b27(g15,p15,g19,p19,g27,p27);
black_box b28(g16,p16,g20,p20,g28,p28);
black_box b29(g17,p17,g21,p21,g29,p29);
black_box b30(g18,p18,g22,p22,g30,p30);
black_box b31(g19,p19,g23,p23,g31,p31);
black_box b32(g20,p20,g24,p24,g32,p32);
black_box b33(g21,p21,g25,p25,g33,p33);
black_box b34(g22,p22,g26,p26,g34,p34);
gray_box gb7(g23,p23,GG[3],GG[7]);
gray_box gb6(g24,p24,GG[2],GG[6]);
gray_box gb5(g25,p25,GG[1],GG[5]);
gray_box gb4(g26,p26,GG[0],GG[4]);

gray_box gb15(g27,p27,GG[7],GG[15]);
gray_box gb14(g28,p28,GG[6],GG[14]);
gray_box gb13(g29,p29,GG[5],GG[13]);
gray_box gb12(g30,p30,GG[4],GG[12]);
gray_box gb11(g31,p31,GG[3],GG[11]);
gray_box gb10(g32,p32,GG[2],GG[10]);
gray_box gb9(g33,p33,GG[1],GG[9]);
gray_box gb8(g34,p34,GG[0],GG[8]);


//Final Sum And Cout.
assign s[0]=p[0]^cin;
assign s[1]=p[1]^GG[0]; 
assign s[2]=p[2]^GG[1];
assign s[3]=p[3]^GG[2];
assign s[4]=p[4]^GG[3];
assign s[5]=p[5]^GG[4];
assign s[6]=p[6]^GG[5];
assign s[7]=p[7]^GG[6];
assign s[8]=p[8]^GG[7];
assign s[9]=p[9]^GG[8];
assign s[10]=p[10]^GG[9];
assign s[11]=p[11]^GG[10];
assign s[12]=p[12]^GG[11];
assign s[13]=p[13]^GG[12];
assign s[14]=p[14]^GG[13];
assign s[15]=p[15]^GG[14];
assign cout=GG[15];


endmodule

