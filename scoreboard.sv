//`include "transaction.sv"
class scoreboard;
  mailbox mon_in2scb;
  mailbox mon_out2scb;
  virtual async_fifo_if vif;
  logic [7:0] rdata_fifo[$];
  logic [7:0] wdata_fifo[$]; 
  int fd;
logic [8-1:0] verif_data_q[$];
int verif_data_id[$];
  logic [8-1:0] verif_wdata;
  int verif_id;
  function new(virtual async_fifo_if vif, mailbox mon_in2scb, mailbox mon_out2scb);
    this.vif = vif;
    this.mon_in2scb  = mon_in2scb;
    this.mon_out2scb = mon_out2scb;
  endfunction
  
  task main;
	fork 
      get_data_w();
      get_data_r();
      //get_output();
    join_none;
  endtask
  

  
  
  
  task get_data_w();
    
     transaction tx;
   
   for(int i=0;i <100;i++) begin
      
      @(posedge vif.wclk iff !vif.wfull);
        
        if (vif.winc) begin
          mon_in2scb.get(tx);
           verif_data_q.push_front(tx.wdata); 
           verif_data_id.push_front(tx.uniq_id); 
         if(tx.uniq_id==1)
         $display("[SCOREBOARD] wdata =%h, uniq_id=%d",tx.wdata,tx.uniq_id);
        end
     end 
    
  endtask
  task get_data_r();
    
     transaction tx;
    
    fd= $fopen("output1.txt","w");
     $fdisplay(fd,"Team1 scoreboard results");

    for(int j=0;j<100;j++) begin
        
        
        @(posedge vif.rclk iff !vif.rempty)
        vif.rinc = (j%3 == 0)? 1'b1 : 1'b0;
        if ((vif.rinc) &&(j!=0)) begin
          verif_wdata = verif_data_q.pop_back();
          verif_id = verif_data_id.pop_back();
              mon_out2scb.get(tx);
          // Check the rdata against modeled wdata
            //fd= $fopen("output1.txt","a");
                   if(tx.rdata === verif_wdata) 
			$display("PASS : expected wdata = %h, rdata = %h, uniq_id=%d", verif_wdata, tx.rdata,verif_id);
	            else 
                        $error("Checking failed: expected wdata = %h, rdata = %h,uniq_id=%d", verif_wdata, tx.rdata, verif_id);
                    end
        
      end 
      mon_out2scb.get(tx);
    
    
  endtask 
  
   
   
    
endclass
