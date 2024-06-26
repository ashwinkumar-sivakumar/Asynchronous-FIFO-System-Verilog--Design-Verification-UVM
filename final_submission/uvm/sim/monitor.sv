class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)


virtual async_fifo_if vif;
fifo_sequence_item item;
  uvm_analysis_port #(fifo_sequence_item) monitor_port;
 int i,count_in,count_out,count;
  bit done,stop;

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
     monitor_port = new("monitor_port", this);
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
    count =vif.tx_count +10;
    wait(vif.rrst_n);
    forever begin
      fork
       for(int i=0;i <vif.tx_count;i++) begin
          if(vif.uniq_id ==1)
               `uvm_info("MONITOR", $sformatf("Inputs wdata= %h, uniq_id=%d",vif.wdata,vif.uniq_id), UVM_LOW)
       @(posedge vif.wclk iff !vif.wfull);
         if(stop==0)
         vif.winc <= (i%1 == 0)? 1'b1 : 1'b0;
         if ((vif.winc)&&(vif.wrst_n==1)) begin
           
           item.wdata =vif.wdata;
           item.uniq_id =vif.uniq_id;
           vif.w_data_q.push_front(item.wdata);
           vif.m_uniq_id.push_front(item.uniq_id);
           
       end
       if(i== vif.tx_count -1) begin
                 vif.winc=0;
                 stop=1;
       end
        end
        
       for(int j=0;j<count;j++) begin
         @(posedge vif.rclk iff !vif.rempty)
            vif.rinc <= (j%3 == 0)? 1'b1 : 1'b0;
         if (vif.rinc) begin
             item.rdata =vif.rdata;
             monitor_port.write(item);
           count_out ++;
          end
         if(count_out ==count-1)
           done=1;
             
        end
       
      join
      
    end

  endtask: run_phase


endclass: fifo_monitor
         
         