`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:09 02/15/2015
// Design Name:   Main_Processor
// Module Name:   D:/Non_working/Main_Processor3/stg_final.v
// Project Name:  Main_Processor3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Main_Processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module stg_final;

	// Inputs
	reg clk;

	// Outputs
	wire [7:0] pc_out;
	wire [15:0] inst_out;
	wire [2:0] jmp_val;
	wire jmp;
	wire [1:0] regwr_out2;
	wire [1:0] dir_val_out2;
	wire memwr_out2;
	wire ctrl_sel_out2;
	wire wrbk_sel_out2;
	wire [2:0] aD_out2;
	wire [2:0] dir_s2_out2;
	wire [3:0] alu_sel_out2;
	wire [7:0] dir_s1_out2;
	wire [15:0] s1_out2;
	wire [15:0] s2_out2;
	wire [1:0] reg_wr_out3;
	wire mem_wr_out3;
	wire wrbk_sel_out3;
	wire [2:0] aM_out3;
	wire [2:0] aD_out3;
	wire [15:0] alu_out3;
	wire [15:0] dM_out3;
	wire [15:0] wD_rf;
	wire [1:0] w_en;
	wire [2:0] aD_rf;
	wire s1_c0;
	wire s1_c1;
	wire s2_c0;
	wire s2_c1;
	wire eop;
	wire [1:0]inita;
	wire [2:0]initb;
	// Instantiate the Unit Under Test (UUT)
	Main_Processor uut (
		.clk(clk), 
		.pc_out(pc_out), 
		.inst_out(inst_out), 
		.jmp_val(jmp_val), 
		.jmp(jmp), 
		.regwr_out2(regwr_out2), 
		.dir_val_out2(dir_val_out2), 
		.memwr_out2(memwr_out2), 
		.ctrl_sel_out2(ctrl_sel_out2), 
		.wrbk_sel_out2(wrbk_sel_out2), 
		.aD_out2(aD_out2), 
		.dir_s2_out2(dir_s2_out2), 
		.alu_sel_out2(alu_sel_out2), 
		.dir_s1_out2(dir_s1_out2), 
		.s1_out2(s1_out2), 
		.s2_out2(s2_out2), 
		.reg_wr_out3(reg_wr_out3), 
		.mem_wr_out3(mem_wr_out3), 
		.wrbk_sel_out3(wrbk_sel_out3), 
		.aM_out3(aM_out3), 
		.aD_out3(aD_out3), 
		.alu_out3(alu_out3), 
		.dM_out3(dM_out3), 
		.wD_rf(wD_rf), 
		.w_en(w_en), 
		.aD_rf(aD_rf), 
		.s1_c0(s1_c0), 
		.s1_c1(s1_c1), 
		.s2_c0(s2_c0), 
		.s2_c1(s2_c1), 
		.eop(eop),
		.inita(inita),
		.initb(initb)
	);
reg [2:0] count;
always begin
#25 clk=~clk;
$display("%b \t %b",clk, count);
if(eop == 1) begin 
count++;
if(count>10)
$finish;
end
end
	initial begin
		// Initialize Inputs
		clk = 0;
		count = 0;
	end
      	
endmodule

