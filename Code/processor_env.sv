class processor_env extends uvm_env;
  `uvm_component_utils(processor_env)
    
    processor_agent agent;
    processor_monitor mon;
    processor_scoreboard sb;
    processor_subscriber sub;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      agent = processor_agent::type_id::create("agent", this);
      mon   = processor_monitor::type_id::create("mon",this);
      sb    = processor_scoreboard::type_id::create("sb",this);
      sub   = processor_subscriber::type_id::create("sub",this);
    endfunction
  
    // connect ports of various TB components here
   function void connect_phase(uvm_phase phase);
      `uvm_info("", "Called env::connect_phase", UVM_NONE);
      
      // connect driver's analysis port to scoreboard's analysis
      // implementation por
      agent.driver.Drv2Sb_port.connect(sb.Drv2Sb_port);
      
      // connect monitor's analysis port to scoreboard's analysis
      // implementation port
      mon.Mon2Sb_port.connect(sb.Mon2Sb_port);

      // connect monitor's analysis port to subscriber's analysis
      // implementation port
mon.aport.connect(sub.aport);
   endfunction: connect_phase


endclass
