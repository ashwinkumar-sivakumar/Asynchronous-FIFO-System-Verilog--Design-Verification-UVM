class driver;
  int tx_count1=0;
  int tx_count2=0;
  
  virtual async_fifo_if intf_vi;
  mailbox gen2driv;
 
  function new(virtual async_fifo_if intf_vi, mailbox gen2driv);
    this.intf_vi = intf_vi;
    this.gen2driv = gen2driv;
  endfunction
  
 //`include "transaction.sv" 
  
  task reset;
    intf_vi.wrst_n <= 0;
    intf_vi.rrst_n <= 0;
    wait(!intf_vi.wrst_n);
    $display("[ DRIVER ] ****** RESET STARTED ******");
    intf_vi.winc <= 0;
    intf_vi.wdata <= 0;
    intf_vi.rinc <= 0;
    
    repeat(5) @(posedge intf_vi.wclk);
    intf_vi.wrst_n = 1'b1;
    intf_vi.rrst_n = 1'b1;
    wait(intf_vi.wrst_n);
    $display("[ DRIVER ] ****** RESET ENDED ******");
  endtask
  
  task main;
    $display("[ DRIVER ] ****** DRIVER STARTED ******");
    
    forever begin
      transaction tx;  
      gen2driv.get(tx);
      
      @(posedge intf_vi.wclk);
      tx_count1++;
      
      intf_vi.wdata = tx.wdata;
      $display("[ DRIVER ]wdata rand burst =%h \n",tx.wdata);
      //$display("the tx_count1 =%d, the tx_count2=%d, winc=%d",tx_count1,tx_count2,intf_vi.winc);
      if (intf_vi.winc== 1'b1) tx_count2++;
    end
    $display("[ DRIVER ] ****** DRIVER ENDED ******");
  endtask
endclass
