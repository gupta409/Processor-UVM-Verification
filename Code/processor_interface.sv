interface processor_interface(input clk); 

//PC and Instruction word
   logic [7:0]pc;
   logic [15:0]inst_out;
   logic [15:0]inst_in;
//Register file Signals
   logic [15:0]reg_data;
   logic [1:0]reg_en;
   logic [2:0]reg_add;

//Data Memory Signals
   logic [15:0]mem_data;
   logic mem_en;
   logic [2:0]mem_add;
   
	clocking driver_cb @ (negedge clk);
		output inst_in;
	endclocking : driver_cb
	
  clocking monitor_cb @ (negedge clk);
	input pc;
	input inst_out;
	input reg_data;
	input reg_en;
	input reg_add;
	input mem_data;
	input mem_en;
	input mem_add;
  endclocking : monitor_cb

  modport driver_if_mp (clocking driver_cb);
  modport monitor_if_mp (clocking monitor_cb);
  
endinterface

