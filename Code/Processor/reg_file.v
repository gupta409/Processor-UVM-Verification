`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:56:22 02/12/2015 
// Design Name: 
// Module Name:    reg_file 
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
module reg_file(
    output reg [15:0] r0,//scr1 o/p
    output reg [15:0] r1,//scr2 o/p
    input clk,
	 input [1:0] reconfig,//active high
    input [2:0] a0,		//source 1
    input [2:0] a1,		//source 2
    input [2:0] d,		//dest register
    input [15:0] wr,		//data to be written
    input [1:0] w_en		//active high
    );

	 reg [15:0]gpr[7:0];
	 integer i;
	 initial 
	  for(i=0;i<8;i=i+1)
	  begin
	  gpr[i]=0;
	  end
	 always@(negedge clk)
		begin
			if(reconfig==2'b11)
				begin
					r0<=gpr[a0];	//read the data
					r1<=gpr[a1];	//at negative edge
				end
			else if(reconfig==2'b10)
				begin
					r0<={gpr[a0][15:8],{8{1'b0}}};
					r1<={gpr[a1][15:8],{8{1'b0}}};
				end
			else if(reconfig==2'b01)
				begin
					r0<={{8{1'b0}},gpr[a0][7:0]};
					r1<={{8{1'b0}},gpr[a1][7:0]};
				end
			else
				begin
					r0<=16'b0;
					r1<=16'b0;
				end
				
		end
		
	always@(posedge clk)	//write at positive
		begin					//edge
			if(w_en==2'b11)
				gpr[d]<=wr;	//16 bit write
			else if(w_en==2'b01)
				gpr[d][7:0]<=wr[7:0];	//lower byte write
			else if(w_en==2'b10)
				gpr[d][15:8]<=wr[15:8];	//higher byte write
		end

endmodule
