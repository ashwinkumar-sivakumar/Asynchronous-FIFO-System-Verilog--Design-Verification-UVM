class fifo_driver extends uvm_driver#(fifo_sequence_item);
  `uvm_component_utils(fifo_driver)

virtual async_fifo_if vif;
  fifo_sequence_item item;
  fifo_base_sequence seq;
  int i,j,count_in,count_out;
bit stop;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new

 
  task reset;
    vif.wrst_n <= 0;
    vif.rrst_n <= 0;
    wait(!vif.wrst_n);
    $display("[ DRIVER ] ****** RESET STARTED ******");
    vif.winc <= 0;
    vif.wdata <= 0;
    vif.rinc <= 0;
    vif.rdata <= 0;
   // @(posedge vif.wclk);
    vif.wrst_n <= 1'b1;
    vif.rrst_n <= 1'b1;
    //wait(vif.wrst_n);
    $display("[ DRIVER ] ****** RESET ENDED ******");
  endtask 
 
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH)

    if(!(uvm_config_db #(virtual async_fifo_if)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get VIF from config DB!")
    end

  endfunction: build_phase

  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase

  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("AGENT_CLASS", "Run Phase!", UVM_HIGH)
   
    
    forever begin
     
       //vif.wdata = 1'b1;
       vif.winc = 1'b0;
       item = fifo_sequence_item::type_id::create("item"); 
      seq = fifo_base_sequence::type_id::create("seq"); 
       //seq_item_port.get_next_item(item);
      drive(item); //need to create task
    end

  endtask: run_phase
  
  task drive(fifo_sequence_item item);
    fork 
      for(int i=0;i <vif.tx_count;i++) begin
            
        if(count_in < vif.tx_count)begin
        @(posedge vif.wclk iff !vif.wfull);
         vif.rrst_n = item.rrst_n;
              vif.wrst_n = item.wrst_n;
        if(stop==0)
         vif.winc = (i%1 == 0)? 1'b1 : 1'b0;
        
          if ((vif.winc)) begin
          //item.uniq_id ++;
            //seq.rand_fifo(item.uniq_id,item.wdata);
            seq_item_port.get_next_item(item);
          if(item.uniq_id==1) begin
           `uvm_info("DRIVER", $sformatf("Inputs wdata= %h, uniq_id=%d", item.wdata,item.uniq_id), UVM_LOW)
           end
         vif.wdata  <= item.wdata;
         vif.uniq_id <= item.uniq_id;
        
           seq_item_port.item_done();
         vif.verif_data_q.push_front(vif.wdata);
          count_in++;
            
        end
       
    
        end
       /* if(i== vif.tx_count-1) begin
          vif.winc=0;
          stop=1; 
        end */
      end
        
   join 
      
    
  //-> ended;
    
  endtask


endclass: fifo_driver