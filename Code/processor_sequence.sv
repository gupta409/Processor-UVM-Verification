class processor_transaction extends uvm_sequence_item;

  `uvm_object_utils(processor_transaction)
   rand bit [15:0] instrn;
   bit [7:0]pc;
   bit [15:0]inst_out;
   bit [15:0]reg_data;
   bit [1:0]reg_en;
   bit [2:0]reg_add;
   bit [15:0]mem_data;
   bit mem_en;
   bit [2:0]mem_add;
constraint input_constraint
   {
	//Cosntraint to prevent EOF operation
      instrn inside {[16'h0000:16'hEFFF]};
   }
  function new (string name = "");
    super.new(name);
  endfunction

endclass: processor_transaction


class inst_sequence extends uvm_sequence#(processor_transaction);

  `uvm_object_utils(inst_sequence)

  function new (string name = "");
    super.new(name);
  endfunction

  bit [15:0] inst;
//processor_transaction req;
  task body;
    
      req = processor_transaction::type_id::create("req");

      start_item(req);

      if (!req.randomize()) begin
        `uvm_error("Instruction Sequence", "Randomize failed.");
      end
     inst = req.instrn;

      finish_item(req);
    
  endtask: body

endclass: inst_sequence



class processor_sequence extends uvm_sequence#(processor_transaction);

  `uvm_object_utils(processor_sequence)

  function new (string name = "");
    super.new(name);
  endfunction

  inst_sequence inst_seq;

  task body;
    
	//LOOP relative to use case (say 256)
     for(int i =0;i<10000;i++) 
     begin
        inst_seq = inst_sequence::type_id::create("inst_seq");
        inst_seq.start(m_sequencer);
     end
     
  endtask: body

endclass: processor_sequence


