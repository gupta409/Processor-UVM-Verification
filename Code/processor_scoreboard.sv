`uvm_analysis_imp_decl(_mon_trans)
`uvm_analysis_imp_decl(_drv_trans)

class processor_scoreboard extends uvm_scoreboard;
    
    // register the scoreboard in the UVM factory
    `uvm_component_utils(processor_scoreboard);

    //processor_transaction trans, input_trans;

    // analysis implementation ports
    uvm_analysis_imp_mon_trans #(processor_transaction,processor_scoreboard) Mon2Sb_port;
    uvm_analysis_imp_drv_trans #(processor_transaction,processor_scoreboard) Drv2Sb_port;

    // TLM FIFOs to store the actual and expected transaction values
    uvm_tlm_fifo #(processor_transaction)  drv_fifo;
    uvm_tlm_fifo #(processor_transaction)  mon_fifo;

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      //Instantiate the analysis ports and Fifo
      Mon2Sb_port = new("Mon2Sb",  this);
      Drv2Sb_port = new("Drv2Sb",  this);
      drv_fifo     = new("drv_fifo", this,8);
      mon_fifo     = new("mon_fifo", this,8);
   endfunction : build_phase

   // write_drv_trans will be called when the driver broadcasts a transaction
   // to the scoreboard
   function void write_drv_trans (processor_transaction input_trans);
        void'(drv_fifo.try_put(input_trans));
   endfunction : write_drv_trans

   // write_mon_trans will be called when the monitor broadcasts the DUT results
   // to the scoreboard 
   function void write_mon_trans (processor_transaction trans);
        void'(mon_fifo.try_put(trans));
   endfunction : write_mon_trans

   task run_phase(uvm_phase phase);
      processor_transaction exp_trans, out_trans;
      reg [15:0]file[0:7];
      bit [15:0]h1,i1,i2; 
      bit [7:0]dir;
      bit store,jmp,eop,nop,inter1,multiply,shift;
      int s1,s2;
      forever begin
			drv_fifo.get(exp_trans);
			mon_fifo.get(out_trans);
			h1=0;
			dir=0;
			s1=0;
			s2=0;
			//Initialize Reg File
			file[0] = 16'h0435;
			file[1] = 16'h407F;
			file[2] = 16'h8185;
			file[3] = 16'hEBC0;
			file[4] = 16'h110B;
			file[5] = 16'h4073;
			file[6] = 16'h82BC;
			file[7] = 16'hD4C1;
        //Compare Instructions
        /*
instrn[15:12]=> OPCODE
instrn[11]=> CTRL
instrn[10:9]=>RECONFIG
instrn[8:6]=>DESTINATION
instrn[5:3]=>Source 1
instrn[2:0]=>Source 2
*/
if(exp_trans.instrn == out_trans.inst_out)		//FULL INST CHECK
begin
`uvm_info ("INSTRUCTION_WORD_PASS ", $sformatf("Actual Instruction=%h Expected Instruction=%h \n",out_trans.inst_out, exp_trans.instrn), UVM_LOW)
	if(exp_trans.instrn[8:6]==out_trans.reg_add)	//DESTINATION REG CHECK
	begin
	`uvm_info ("REG_ADDR_PASS ", $sformatf("Actual Reg Addr=%d Expected Reg Addr=%d \n",out_trans.reg_add, exp_trans.instrn[8:6]), UVM_LOW)
	s1=exp_trans.instrn[5:3];
	s2=exp_trans.instrn[2:0];
	dir=({{8{exp_trans.instrn[10]}}& exp_trans.instrn[7:0],{8{exp_trans.instrn[9]}}& exp_trans.instrn[7:0]});
	//This dir is for MOV Immediate
	
	store=(exp_trans.instrn[15]&~exp_trans.instrn[14]&exp_trans.instrn[13]&exp_trans.instrn[12]);	//Resetting reconfig for variables aptly named
	jmp=(exp_trans.instrn[15]&exp_trans.instrn[14]&~exp_trans.instrn[13]&exp_trans.instrn[12]);
	nop=(exp_trans.instrn[15]&exp_trans.instrn[14]&exp_trans.instrn[13]&~exp_trans.instrn[12]);
	eop=(exp_trans.instrn[15]&exp_trans.instrn[14]&exp_trans.instrn[13]&exp_trans.instrn[12]);;
	inter1=store|jmp|nop|eop;
	
	multiply=(exp_trans.instrn[15]&~exp_trans.instrn[14]&~exp_trans.instrn[13]&~exp_trans.instrn[12]);
	shift=(exp_trans.instrn[15]&exp_trans.instrn[14]&~exp_trans.instrn[13]&~exp_trans.instrn[12]&exp_trans.instrn[10]&exp_trans.instrn[9]);
	
		if(out_trans.reg_en[1:0]==({{(exp_trans.instrn[10]|multiply|shift)&(~inter1)},{(exp_trans.instrn[9]|multiply|shift)&(~inter1)}}))		//Register write enable check
		begin	
			i1=({{8{exp_trans.instrn[10]}}& file[s1][15:8],{8{exp_trans.instrn[9]}}& file[s1][7:0]});
			i2=({{8{exp_trans.instrn[10]}}& file[s2][15:8],{8{exp_trans.instrn[9]}}& file[s2][7:0]});
			case(out_trans.inst_out[15:12])
				4'b0000:begin
					 h1=i1+i2;				
						if((h1)==(out_trans.reg_data))
						begin
						`uvm_info ("ADDITION_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("ADDITION_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b0001:begin
					h1=i1-i2;
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("SUBTRACTION_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("SUBTRACTION_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b0011:begin
					h1=i1+1'b1;
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("INCREMENT_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("INCREMENT_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b0010:begin
					h1=i1-1'b1;
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("DECREMENT_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("DECREMENT_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b0100:begin
					if(!exp_trans.instrn[11])		//FOR two variations of AND, OR, EXOR, SHIFT, INV
						begin
						h1=i1&i2;
						end
						else
						begin
						h1=~(i1&i2);
						end
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("AND/NAND_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("AND/NAND_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b0101:begin
					if(!exp_trans.instrn[11])
						begin
						h1=i1|i2;
						end
						else
						begin
						h1=~(i1|i2);
						end
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("OR/NOR_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("OR/NOR_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end	
				4'b0110:begin
					if(!exp_trans.instrn[11])
						begin
						h1=i1^i2;
						end
						else
						begin
						h1=~(i1^i2);
						end
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("EXOR/EXNOR_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("EXOR/EXNOR_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b0111:begin
					if(!exp_trans.instrn[11])
						begin
						h1=i1;
						end
						else
						begin
						h1=~(i1);
						end
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("BUFF/INV_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("BUFF/INV_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end	
				4'b1100:begin
					if(!exp_trans.instrn[11])
						begin
						h1=i1<<s2;
						end
						else
						begin
						h1=i1>>s2;
						end
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("SHIFT_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("SHIFT_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b1000:begin
					if(exp_trans.instrn[10:9]==2'b01|exp_trans.instrn[10:9]==2'b11)
					begin
					h1=i1[7:0]*i2[7:0];
					end
					else
					begin
						if(exp_trans.instrn[10:9]==2'b10)
						begin
						h1=i1[15:8]*i2[15:8];
						end 
					end
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("MULTIPLY_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("MULTIPLY_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b1010:begin
					h1=0;			
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("LOAD_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("LOAD_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				4'b1011:begin
					h1=i1;
						if(exp_trans.instrn[2:0] == out_trans.mem_add)
						begin
						`uvm_info ("MEM_STORE_ADDR_PASS ", $sformatf("Actual Mem Addr=%d Expected Mem Addr=%d \n",out_trans.mem_add, exp_trans.instrn[2:0]), UVM_LOW)
							if(out_trans.mem_en)
							begin
								`uvm_info ("MEM_STORE_EN_PASS ", $sformatf("Actual Mem Addr=%d Expected Mem Addr=%d \n",out_trans.mem_en, 1'b1), UVM_LOW)
								if(h1==out_trans.mem_data)
								begin
								`uvm_info ("STORE_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
								end
								else
								begin
								`uvm_error("STORE_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
								end
							end
							else
							begin
							`uvm_error("MEM_STORE_EN_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.mem_en, 1'b1))
							end
						end
						else
						begin
						`uvm_error("MEM_STORE_ADDR_FAIL", $sformatf("Actual Dest=%d Expected Dest=%d\n",out_trans.mem_add,exp_trans.instrn[2:0]))
						end
					end	
				4'b1001:begin
					$display("in1=%d, in2=%d, reconfig=%d reg scr1 and 2= %d %d",i1,i2,out_trans.reg_en,s1,s2);
					if(!exp_trans.instrn[11])			//For MOVE(0) and MOVE_IMMEDIATE(1)
						begin
						h1=i1;
						end
						else
						begin
						h1=({{8{exp_trans.instrn[10]}}& exp_trans.instrn[7:0],{8{exp_trans.instrn[9]}}& exp_trans.instrn[7:0]});
						end
						if(h1==out_trans.reg_data)
						begin
						`uvm_info ("MOVE_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("MOVE_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end
					end
				default:`uvm_info ("JUMP/EOP_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.inst_out, exp_trans.instrn[15:12]), UVM_LOW)
			endcase
		end
		else
		begin
		`uvm_error("REG_EN_FAIL", $sformatf("Actual Reg Enable=%d Expected Reg Enable=%d \n",out_trans.reg_en, exp_trans.instrn[10:9]))
		end
	end
	else
	begin
	`uvm_error("REG_ADDR_FAIL", $sformatf("Actual Reg Addr=%d Expected Reg Addr=%d \n",out_trans.reg_add, exp_trans.instrn[8:6]))
	end
	
end	
else
begin
`uvm_error("INSTRUCTION_ERROR", $sformatf("Actual=%d Expected=%d \n",out_trans.inst_out, exp_trans.instrn))			
end				
      end
   endtask
endclass : processor_scoreboard
