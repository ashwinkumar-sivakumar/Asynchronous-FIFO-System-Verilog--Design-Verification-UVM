class fifo_scoreboard extends uvm_test;
    `uvm_component_utils(fifo_scoreboard)
  
    uvm_analysis_imp #(fifo_sequence_item, fifo_scoreboard) scoreboard_port;
    fifo_sequence_item transaction[$];
    virtual async_fifo_if vif; // Use the appropriate virtual interface type
  logic[7:0] v_wdata;
   int v_uniq_id;
   
   // fifo_sequence_item item;
    
    //--------------------------------------------------------
    //Constructor
    //--------------------------------------------------------
    function new(string name = "fifo_scoreboard", uvm_component parent);
        super.new(name, parent);
        `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
    endfunction: new
    
    //--------------------------------------------------------
    //Build Phase
    //--------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
       scoreboard_port = new("scoreboard_port", this);
    endfunction: build_phase
    
    //--------------------------------------------------------
    //Connect Phase
    //--------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      `uvm_info("SCB_CLASS", "Connect Phase!", UVM_LOW)
       
        if (!uvm_config_db#(virtual async_fifo_if)::get(this, "*", "vif", vif))
            `uvm_fatal("SCOREBOARD", "Failed to get VIF from config DB")
    endfunction: connect_phase
          
          
          function void write(fifo_sequence_item item);
      transaction.push_back(item);
          endfunction: write
   
    
    //--------------------------------------------------------
    //Run Phase
    //--------------------------------------------------------
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
      `uvm_info("SCB_CLASS", "Run Phase!", UVM_LOW)
       
           forever begin
           fifo_sequence_item curr_trans;
      wait((transaction.size() != 0));
            
 
     
           v_wdata = vif.w_data_q.pop_back();
           curr_trans = transaction.pop_front();
           v_uniq_id = vif.m_uniq_id.pop_back();
           if(curr_trans.rdata !== v_wdata)
             `uvm_error("SCOREBOARD", $sformatf("Mismatch detected! Expected: %h, Actual: %h, Uniq_id: %0d", v_wdata, curr_trans.rdata, v_uniq_id))
            else 
              `uvm_info("SCOREBOARD", $sformatf("PASS! Expected: %h, Actual: %h, Uniq_id: %0d", v_wdata, curr_trans.rdata,v_uniq_id), UVM_LOW)
         
   
           end
    endtask: run_phase
  
 
    
endclass: fifo_scoreboard
