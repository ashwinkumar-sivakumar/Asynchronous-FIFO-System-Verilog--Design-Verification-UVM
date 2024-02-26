class fifo_sequence_item extends uvm_sequence_item;
  
  `uvm_object_utils(fifo_sequence_item)
  
  //Instantiation
    parameter DSIZE = 8;
  
  rand logic [DSIZE-1:0] wdata;
  logic winc;
  logic wclk;
  logic wrst_n;
  logic [DSIZE-1:0] rdata;
  logic rinc;
  logic rclk;
  logic rrst_n;
  logic wfull;
  logic rempty;
  int uniq_id;
  
  task reset();
   wrst_n <= 0;
    rrst_n <= 0;
    wait(!wrst_n);
    winc <= 0;
    wdata <= 0;
    rinc <= 0;
    rdata <= 0;
   
   
  endtask
  
  function void print();
    `uvm_info("SEQUENCE_ITEM", "TRANSACTION", UVM_HIGH)
    `uvm_info("SEQUENCE_ITEM", $sformatf("Inputs wdata= %h, uniq_id=%d", wdata,uniq_id), UVM_LOW)
   // $display("Inputs wdata= %0h, winc = %0h, and rdata = %0h", wdata, winc, rdata);
  endfunction: print

  
  
  function new(string name = "fifo_sequence_item");
    super.new(name);
    
  endfunction: new
    
 endclass :fifo_sequence_item
