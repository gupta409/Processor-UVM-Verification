`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:26:48 08/25/2014 
// Design Name: 
// Module Name:    wallace_8bit 
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
//Code For Wallace Tree Multiplier.
module wallace_8bit(
    input [7:0] a,
    input [7:0] b,
    output [15:0] p
    );
reg [63:0]w;
integer i,j,k,l;
always@(*)
begin
i=63;
l=7;
while(i>=36)
 begin
  k=7;
  for(j=l;j<=7;j=j+1)
    begin
    if(k>=l)	 
     w[i]=a[j]&b[k];
    i=i-1;
	 k=k-1;
    end
  l=l-1;
 end
  l=0;
  i=0;
while(i!=36)
 begin
  j=0;
  for(k=l;k>=0;k=k-1)
   begin
    if(j<=l)
	  w[i]=a[k]&b[j];
    i=i+1;
	 j=j+1;
   end
  l=l+1;
 end
w[0]=a[0]&b[0];
end
 
assign p[0]=w[0];

halfadder hfa1(w[1],w[2],p[1],b1);

halfadder hf2(w[3],w[4],k1,c1);
full_adder fa1(w[5],k1,b1,p[2],c2);

halfadder hf3(w[6],w[7],k2,d1);
full_adder fa2(w[8],k2,c1,k3,d2);
full_adder fa3(w[9],k3,c2,p[3],d3);

halfadder hf4(w[10],w[11],k4,e1);
full_adder fa4(w[12],k4,d1,k5,e2);
full_adder fa5(w[13],k5,d2,k6,e3);
full_adder fa6(w[14],k6,d3,p[4],e4);
	
halfadder hf5(w[15],w[16],k7,f1);
full_adder fa7(w[17],k7,e1,k8,f2);
full_adder fa8(w[18],k8,e2,k9,f3);
full_adder fa9(w[19],k9,e3,k10,f4);
full_adder fa10(w[20],k10,e4,p[5],f5);	
	
halfadder hf6(w[21],w[22],k11,g1);
full_adder fa11(w[23],k11,f1,k12,g2);
full_adder fa12(w[24],k12,f2,k13,g3);
full_adder fa13(w[25],k13,f3,k14,g4);
full_adder fa14(w[26],k14,f4,k15,g5);
full_adder fa15(w[27],k15,f5,p[6],g6);
	
halfadder hf7(w[28],w[29],k16,h1);
full_adder fa16(w[30],k16,g1,k17,h2);
full_adder fa17(w[31],k17,g2,k18,h3);
full_adder fa18(w[32],k18,g3,k19,h4);
full_adder fa19(w[33],k19,g4,k20,h5);
full_adder fa20(w[34],k20,g5,k21,h6);
full_adder fa21(w[35],k21,g6,p[7],h7);

halfadder hf8(w[36],w[37],k22,i1);
full_adder fa22(w[38],k22,h1,k23,i2);
full_adder fa23(w[39],k23,h2,k24,i3);
full_adder fa24(w[40],k24,h3,k25,i4);
full_adder fa25(w[41],k25,h4,k26,i5);
full_adder fa26(w[42],k26,h5,k27,i6);
full_adder fa27(k27,h7,h6,p[8],i7);

full_adder fa28(w[43],w[44],i1,k28,j1);
full_adder fa29(w[45],k28,i2,k29,j2);
full_adder fa30(w[46],k29,i3,k30,j3);
full_adder fa31(w[47],k30,i4,k31,j4);
full_adder fa32(w[48],k31,i5,k32,j5);
full_adder fa33(k32,i7,i6,p[9],j6);

full_adder fa34(w[49],w[50],j1,k33,l1);
full_adder fa35(w[51],k33,j2,k34,l2);
full_adder fa36(w[52],k34,j3,k35,l3);
full_adder fa37(w[53],k35,j4,k36,l4);
full_adder fa38(j5,j6,k36,p[10],l5);

full_adder fa39(w[54],w[55],l1,k37,m1);
full_adder fa40(w[56],k37,l2,k38,m2);
full_adder fa41(w[57],k38,l3,k39,m3);
full_adder fa42(l4,l5,k39,p[11],m4);

full_adder fa43(w[58],w[59],m1,k40,n1);
full_adder fa44(w[60],k40,m2,k41,n2);
full_adder fa45(m3,m4,k41,p[12],n3);

full_adder fa46(w[61],w[62],n1,k42,o1);
full_adder fa47(n2,n3,k42,p[13],o2);

full_adder fa48(w[63],o1,o2,p[14],p[15]);


endmodule
