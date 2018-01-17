`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:26:49 02/02/2015 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit(
input [3:0]op,
input ctrl,
input [1:0]re_config,
output jmp,eop,ctrl_sel,mem_wr,wr_bk_sel,
output [1:0]reg_wr,
output [3:0]alu_sel,
output [1:0]dir_val
    );

wire w1,w2,w3,w4,k,shiftv;

//Regwr
assign w1=(op[3]&~op[2]&op[1]&op[0]);	//store
assign w2=(op[3]&op[2]&~op[1]&op[0]);	//jump
assign w3=(op[3]&op[2]&op[1]&~op[0]);	//NOP
assign w4=(op[3]&op[2]&op[1]&op[0]);	//EOP
assign k=w1|w2|w3|w4;

assign shiftv=re_config[1]&re_config[0]&op[3]&op[2]&~op[1]&~op[0];
assign reg_wr[1]=(re_config[1]|(op[3]&~op[2]&~op[1]&~op[0])|shiftv)&(~k);
assign reg_wr[0]=(re_config[0]|(op[3]&~op[2]&~op[1]&~op[0])|shiftv)&(~k);
//Memwr
assign mem_wr=w1;

//Write Back Select
assign wr_bk_sel=(op[3]&~op[2]&op[1]&~op[0]);

//Dual select in ALU
assign ctrl_sel=ctrl&~w3;

//Jump
assign jmp=(op[3]&op[2]&~op[1]&op[0]);

//EOP
assign eop=(op[3]&op[2]&op[1]&op[0]);

//Direct Value
assign dir_val[1]=op[3]&~op[2]&~op[1]&op[0]&ctrl;
assign dir_val[0]=op[3]&op[2]&~op[1]&~op[0];

//ALU select
assign alu_sel=(op&{4{~w3}})|({~op[3],op[2],op[1],~op[0]}&{4{w3}});

endmodule

