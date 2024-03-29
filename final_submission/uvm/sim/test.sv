

class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

 
  fifo_env env;
  fifo_base_sequence reset_seq;
  fifo_test_sequence test_seq;
  
  //need to create handles for sequences
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new

  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)
     env = fifo_env::type_id::create("env", this);
  endfunction: build_phase

  virtual function void end_of_elaboration_phase (uvm_phase phase);
         super.end_of_elaboration_phase(phase);
         uvm_top.print_topology();

  endfunction
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase

  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)
//logic
    phase.raise_objection(this);
    //drv.reset();
    
    //start our sequences
    //reset seq
    reset_seq = fifo_base_sequence::type_id::create("reset_seq");
    reset_seq.start(env.agnt.seqr);
    
      //test_seq
      test_seq = fifo_test_sequence::type_id::create("test_seq");
      test_seq.start(env.agnt.seqr);
      
    wait(env.agnt.mon.done==1);
        #100 phase.drop_objection(this);
    
    

  endtask: run_phase


endclass: fifo_test

