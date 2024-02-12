class transaction;
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

  
  function void print ();
    $display("*******Transaction*******");
    $display("Inputs wdata= %0h, winc = %0h, and rdata = %0h", wdata, winc, rdata);
  endfunction: print
  
endclass