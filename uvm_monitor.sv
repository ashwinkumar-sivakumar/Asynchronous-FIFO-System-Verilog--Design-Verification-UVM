class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)


virtual async_fifo_if vif;
fifo_sequence_item item;
 int i,count_in,count_out; 
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new

  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    if(!(uvm_config_db #(virtual async_fifo_if)::get(this, "*", "vif", vif))) begin
    `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end


  endfunction: build_phase

  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase

  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Run Phase!", UVM_HIGH)
//logic
       item = fifo_sequence_item::type_id::create("item");
    wait(vif.rrst_n);
    forever begin
      fork
       for(int i=0;i <vif.tx_count;i++) begin
       @(posedge vif.wclk iff !vif.wfull);
        
        if (vif.winc) begin
           
           item.wdata =vif.wdata;
           item.uniq_id =vif.uniq_id;
             if(item.uniq_id ==1)
               `uvm_info("MONITOR", $sformatf("Inputs wdata= %h, uniq_id=%d",item.wdata,item.uniq_id), UVM_LOW)
       end
        end
        
       for(int j=0;j<vif.tx_count;j++) begin
       @(posedge vif.rclk iff !vif.rempty)
         vif.rinc = (j%3 == 0)? 1'b1 : 1'b0;
         if ((vif.rinc)&&(j!=0)) begin
             item.rdata =vif.rdata;
           
          
          end
      
        end
       
      join
      
      
    end

  endtask: run_phase


endclass: fifo_monitor
