class processor_monitor extends uvm_monitor;
     // register the monitor in the UVM factory
     `uvm_component_utils(processor_monitor)
     int count;
     //Declare virtual interface
     virtual processor_interface processor_vif;

     // Analysis port to broadcast results to scoreboard 
     uvm_analysis_port #(processor_transaction) Mon2Sb_port; 
     
     // Analysis port to broadcast results to subscriber 
	uvm_analysis_port #(processor_transaction) aport;     
     function new(string name, uvm_component parent);
       super.new(name, parent);
     endfunction
     
     function void build_phase(uvm_phase phase);
       // Get interface reference from config database
       if(!uvm_config_db#(virtual processor_interface)::get(this, "", "processor_vif", processor_vif)) begin
         `uvm_error("", "uvm_config_db::get failed")
       end
       Mon2Sb_port = new("Mon2Sb",this);
       aport = new("aport",this);
     endfunction

     task run_phase(uvm_phase phase);
         processor_transaction pros_trans;
         pros_trans = new ("trans");
         count = 0;
	 fork
	   forever begin
	     @(processor_vif.monitor_if_mp.monitor_cb.inst_out)
	     begin
	     if(count<17)
	        begin
	        count++;
	        end
	     else
	        begin
		//Set transaction from interface data
		pros_trans.pc = processor_vif.monitor_if_mp.monitor_cb.pc;
		pros_trans.inst_out = processor_vif.monitor_if_mp.monitor_cb.inst_out;
		pros_trans.reg_data = processor_vif.monitor_if_mp.monitor_cb.reg_data;
		pros_trans.reg_en = processor_vif.monitor_if_mp.monitor_cb.reg_en;
		pros_trans.reg_add = processor_vif.monitor_if_mp.monitor_cb.reg_add;
		pros_trans.mem_data = processor_vif.monitor_if_mp.monitor_cb.mem_data;
		pros_trans.mem_en = processor_vif.monitor_if_mp.monitor_cb.mem_en;						
        	pros_trans.mem_add = processor_vif.monitor_if_mp.monitor_cb.mem_add;			
		//Send transaction to Scoreboard
	        Mon2Sb_port.write(pros_trans);
		//Send transaction to subscriber		
		aport.write(pros_trans);	   
		count = 0;             
	        end
	     end
	   end
	 join
     endtask : run_phase

endclass : processor_monitor
