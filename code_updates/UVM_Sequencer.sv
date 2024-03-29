class fifo_sequencer extends uvm_sequencer#(fifo_sequence_item);
  `uvm_component_utils(fifo_sequencer)


  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_sequencer", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("SEQUENCER_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new

  
 /* //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQUENCER_CLASS", "Build Phase!", UVM_LOW)



  endfunction: build_phase

  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQUENCER_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase */

  


endclass: fifo_sequencer

