class processor_agent extends uvm_agent;
  `uvm_component_utils(processor_agent)
    
    processor_driver driver;
    uvm_sequencer#(processor_transaction) sequencer;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      driver = processor_driver::type_id::create("driver", this);
      sequencer = uvm_sequencer#(processor_transaction)::type_id::create("sequencer", this);
    endfunction    
    
    // In UVM connect phase, we connect the sequencer to the driver.
    function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction      

endclass
