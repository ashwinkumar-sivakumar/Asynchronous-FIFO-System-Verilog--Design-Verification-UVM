//`include "transaction.sv"
class monitor_out;
  int tx_count=0;
  virtual async_fifo_if vif;
  mailbox mon_out2scb;
   transaction tx = new();
int fd;
int i;
  function new(virtual async_fifo_if vif, mailbox mon_out2scb);
    this.vif = vif;
    this.mon_out2scb = mon_out2scb;
  endfunction
  
  task main;
    $display("[ MONITOR_OUT ] ****** MONITOR_OUT STARTED ******");    
  
    forever begin
        
        @(posedge vif.rclk iff !vif.rempty)
        vif.rinc = (i%3 == 0)? 1'b1 : 1'b0;
        if ((vif.rinc)&&(i!=0)) begin
             tx.rdata =vif.rdata;
             
             mon_out2scb.put(tx);
             tx_count++;
             
             fd= $fopen("output1.txt","a");
            // $fdisplay(fd,"monitor_out rdata  =%h",tx.rdata);
        end
  i++;
      end 
   
    $display("[ MONITOR_OUT ] ****** MONITOR_OUT ENDED ******");    
  endtask
endclass
