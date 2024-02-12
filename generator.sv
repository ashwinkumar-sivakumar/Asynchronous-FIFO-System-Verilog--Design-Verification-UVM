`include "transaction.sv"

class generator;
  rand transaction tx;
  mailbox gen2driv;
  virtual async_fifo_if bus_tb;
  int tx_count;
  logic [8-1:0] verif_data_q[$];
  logic [8-1:0] verif_wdata;
  int i;
  event ended;
  function new(virtual async_fifo_if bus_tb, mailbox gen2driv);
    this.bus_tb = bus_tb;
    this.gen2driv = gen2driv;
  endfunction
  
  
  task main();
    $display("[ GENERATOR ] ****** GENERATOR STARTED ******");
    $display("{Genarator} tx_count = %d",tx_count);
    //repeat(tx_count) begin
   tx = new();
fork 
     for(int i=0;i <tx_count;i++) begin
      //$display("entering generate loop");
     //@(posedge bus_tb.wclk)
      @(posedge bus_tb.wclk iff !bus_tb.wfull);
         bus_tb.winc = (i%1 == 0)? 1'b1 : 1'b0;
        
        if (bus_tb.winc) begin
          
          assert(tx.randomize());
          //bus_tb.wdata = tx.wdata;
          gen2driv.put(tx);
          verif_data_q.push_front(bus_tb.wdata);
          $display("[ GENERATOR ]wdata rand burst =%h", tx.wdata);
        end
       
      end
      for(int j=0;j<tx_count;j++) begin
        
        //@(posedge bus_tb.rclk)
        @(posedge bus_tb.rclk iff !bus_tb.rempty)
        bus_tb.rinc = ((j%3 == 0)||(j==0))? 1'b1 : 1'b0;
        if (bus_tb.rinc) begin
          verif_wdata = verif_data_q.pop_back();
          // Check the rdata against modeled wdata
          $display("Assertion check rdata: expected wdata = %h, rdata = %h, time=%0t", verif_wdata, bus_tb.rdata,$time); 
          assert(bus_tb.rdata === verif_wdata) else $error("Checking failed: expected wdata = %h, rdata = %h", verif_wdata, bus_tb.rdata);
        end
        
      end 
     join
      
    
   -> ended;
    $display("[ GENERATOR ] ****** GENERATOR ENDED ******");
  endtask
endclass
