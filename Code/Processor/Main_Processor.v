`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:30:33 02/15/2015 
// Design Name: 
// Module Name:    Main_Processor 
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
module Main_Processor(
input clk,
input [15:0]inst_in,
output reg [7:0]pc_out,
output reg [15:0]inst_out,
output reg [2:0]jmp_val,
output reg jmp,eop,
output reg [1:0]regwr_out2,dir_val_out2,
output reg memwr_out2,ctrl_sel_out2,wrbk_sel_out2,
output reg [2:0]aD_out2,dir_s2_out2,
output reg [3:0]alu_sel_out2,
output reg [7:0]dir_s1_out2,
output reg [15:0]s1_out2,s2_out2,
output reg [1:0]reg_wr_out3,reconfig_mul,reconfig_load,
output reg mem_wr_out3,wrbk_sel_out3,
output reg [2:0]aM_out3,aD_out3,
output reg [15:0]alu_out3,dM_out3,
output reg [15:0]wD_rf,
output reg [1:0]w_en,
output reg [2:0]aD_rf,
output reg s1_c0,s1_c1,s2_c0,s2_c1,
output reg [1:0]inita,
output reg [2:0]initb,
output reg [15:0]pc_2,pc_3,inst_out_tb,
output reg [15:0]mem_data_tb,
output reg mem_en_tb,
output reg [2:0]mem_add_tb
    );
//Start of Processor Part1	 
wire [7:0]pc_in;
//input [15:0]inst_in;
wire [7:0]k;
assign k=pc_out;
wire clk_mod=clk&~eop;
wire s1_c1_k,s2_c1_k,s1_c0_k,s2_c0_k;
initial
begin
pc_out=0;
jmp=0;
jmp_val=0;
eop=0;
s1_c0=0;
s1_c1=0;
s2_c0=0;
s2_c1=0;
w_en=0;
aD_rf=0;
wD_rf=0;
inita=3;
initb=4;
end
wire [1:0]k_mux; wire [2:0]kmux2;
mux2_1_1bit m5[1:0](2'b00,2'b11,inita[0]|inita[1],k_mux);
mux2_1_1bit m10[2:0](3'b000,3'b111,initb[0]|initb[1]|initb[2],kmux2); 
wire [1:0]k_sum=inita+k_mux;
wire [2:0]k_sum2=initb+kmux2;
mux2_1_1bit m6(s1_c0,1'b0,inita[0]|inita[1],s1_c0_k);
mux2_1_1bit m7(s2_c0,1'b0,inita[0]|inita[1],s2_c0_k);
mux2_1_1bit m8(s1_c1,1'b0,initb[0]|initb[1]|initb[2],s1_c1_k);
mux2_1_1bit m9(s2_c1,1'b0,initb[0]|initb[1]|initb[2],s2_c1_k);
always@(posedge clk)
begin
inita<=k_sum;
initb<=k_sum2;
end
wire w1;
wire jmp_w=jmp;
wire [2:0]jmp_val_w=jmp_val;
wire [2:0]w2;
assign w1=jmp_w&(jmp_val_w[0]|jmp_val_w[1]|jmp_val_w[2]);

mux2_1_1bit m1[2:0](3'b001,jmp_val,w1,w2);
adder_internal a1(k,w2,pc_in);

//inst_mem IM(pc_out,inst_in);

always@(posedge clk_mod)
begin
pc_out=pc_in;
end

always@(posedge clk_mod)
begin
inst_out=inst_in;

end
//End of Part1

//Start of Processor Part2
wire [15:0]pc;
assign pc=inst_out;
wire jmp_cu,eop_cu,ctrl_sel_in,memwr_in,wrbk_sel_in;
wire [1:0]regwr_in;
wire [3:0]alu_sel_in;
wire[1:0]dir_val_in,w_en_w;
wire[15:0] s1_in,s2_in,wD_rf_w,s1_in_1,s2_in_1;
wire [7:0]dir_s1_in;
assign dir_s1_in=pc[7:0];
wire [2:0]dir_s2_in,aD_rf_w;
assign dir_s2_in=pc[2:0];
assign wD_rf_w=wD_rf;
assign w_en_w=w_en;
assign aD_rf_w=aD_rf;

always@(*)
jmp_val=pc[2:0];

Control_Unit CU(pc[15:12],pc[11],pc[10:9],jmp_cu,eop_cu,ctrl_sel_in,memwr_in,wrbk_sel_in,regwr_in,alu_sel_in,dir_val_in);
reg_file RF(s1_in_1,s2_in_1,clk,pc[10:9],pc[5:3],pc[2:0],aD_rf_w,wD_rf_w,w_en_w);
assign s1_in=({{8{pc[10]}}& s1_in_1[15:8],{8{pc[9]}}& s1_in_1[7:0]});
assign s2_in=({{8{pc[10]}}& s2_in_1[15:8],{8{pc[9]}}& s2_in_1[7:0]});
always@(*)
begin
jmp=jmp_cu;
eop=eop_cu;
end
always@(posedge clk)
begin
regwr_out2<=regwr_in;
dir_val_out2<=dir_val_in;
memwr_out2<=memwr_in;
ctrl_sel_out2<=ctrl_sel_in;
wrbk_sel_out2<=wrbk_sel_in;
aD_out2<=pc[8:6];
dir_s1_out2<=dir_s1_in;
dir_s2_out2<=dir_s2_in;
s1_out2<=s1_in;
s2_out2<=s2_in;
alu_sel_out2<=alu_sel_in;
pc_2<=pc;
reconfig_mul<=pc[10:9];
end
//End of Part2

//For HCU
wire s1_c1_in=s1_c1_k;
wire s2_c1_in=s2_c1_k;
wire s1_c0_in=s1_c0_k;
wire s2_c0_in=s2_c0_k;
wire [15:0]A_scr1=s1_out2;
wire [15:0]A_scr2=s2_out2;
wire [15:0]B_hcu=({{8{pc[10]}}& alu_out3[15:8],{8{pc[9]}}& alu_out3[7:0]});//alu_out3 original assign
wire [15:0]C_hcu=({{8{pc[10]}}& wD_rf[15:8],{8{pc[9]}}& wD_rf[7:0]});//wD_rf original assign

//Start Of Processor Part3
wire [15:0]w3,w4,w5,w6,alu_op,hcu1,hcu2,alu_op_half,w3in1,w3in2,pc_k;
wire w7;
assign pc_k=pc_2;
assign w3in1={{8{1'b0}},dir_s1_out2};
assign w3in2={dir_s1_out2,{8{1'b0}}};
mux2_1_1bit mdirsel[15:0](w3in1,w3in2,regwr_out2[1],w3);
assign w4={{13{1'b0}},dir_s2_out2};


mux4_1_16bit mux1(A_scr1,B_hcu,C_hcu,B_hcu,s1_c0_in,s1_c1_in,hcu1);
mux4_1_16bit mux2(A_scr2,B_hcu,C_hcu,B_hcu,s2_c0_in,s2_c1_in,hcu2);
mux2_1_1bit m2[15:0](hcu1,w3,dir_val_out2[1],w5);
mux2_1_1bit m3[15:0](hcu2,w4,dir_val_out2[0],w6);

ALU alu(w5,w6,alu_sel_out2[3:2],alu_sel_out2[1:0],ctrl_sel_out2,reconfig_mul,alu_op_half,w7);
mux2_1_1bit mdir[15:0](alu_op_half,w3,dir_val_out2[1],alu_op);

always@(posedge clk)
begin
reg_wr_out3<=regwr_out2;
mem_wr_out3<=memwr_out2;
wrbk_sel_out3<=wrbk_sel_out2;
aM_out3<=dir_s2_out2;
aD_out3<=aD_out2;
alu_out3<=alu_op;
dM_out3<=w5;
pc_3<=pc_k;
reconfig_load<=reconfig_mul;
end

//End of Part3

//Start of Processor Part4
wire[15:0]pc_k1,z2;
wire [2:0]z1;
wire z3;
assign pc_k1=pc_3;
assign z1=aM_out3;
assign z2=dM_out3;
assign z3=mem_wr_out3;
wire [15:0]mem_out,wD_in,mem_inter;
data_mem DM(dM_out3,aM_out3,clk,mem_wr_out3,mem_inter);
mux2_1_1bit mload[15:0]({16{1'b0}},mem_inter,reconfig_load[0]&reconfig_load[1],mem_out);
mux2_1_1bit m4[15:0](alu_out3,mem_out,wrbk_sel_out3,wD_in);

always@(posedge clk)
begin
inst_out_tb<=pc_k1;
mem_data_tb<=z2;
mem_en_tb<=z3;
mem_add_tb<=z1;
wD_rf<=wD_in;
w_en<=reg_wr_out3;
aD_rf<=aD_out3;
end
//End of Part4

//Hazard Control Unit
reg [4:0]r1,r2,r4,r5;
reg [2:0]r3,r6;	 	 
wire h1,h2,h3,h4;
always@(posedge clk)
begin
r1<={{inst_in[10:9]},{inst_in[5:3]}};
r2<={{inst_in[10:9]},{inst_in[2:0]}};
r3<=pc[8:6];
end
comp co1(r1,r3,inst_in[15:12],h1);
comp co2(r2,r3,inst_in[15:12],h2);
always@(posedge clk)
begin
s1_c0<=h1;
s2_c0<=h2;
r4<={{inst_in[10:9]},{inst_in[5:3]}};
r5<={{inst_in[10:9]},{inst_in[2:0]}};
r6<=r3;
end
comp c03(r4,r6,inst_in[15:12],h3);
comp co4(r5,r6,inst_in[15:12],h4);
always@(posedge clk)
begin
s1_c1<=h3;
s2_c1<=h4;
end

endmodule

