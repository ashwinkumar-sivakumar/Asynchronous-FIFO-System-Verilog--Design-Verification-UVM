module async_fifo1
#(
  parameter DSIZE = 8,
  parameter ASIZE = 8
 )
(
  input logic  winc, wclk, wrst_n,//winc write enable signal
  input logic  rinc, rclk, rrst_n,//rinc read enable signal
  input logic  [DSIZE-1:0] wdata,

  output logic  [DSIZE-1:0] rdata,
  output logic wfull,
  output logic rempty
);

  logic [ASIZE-1:0] waddr, raddr;
  logic [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w sync_r2w (.*);
  sync_w2r sync_w2r (.*);
  fifomem #(DSIZE, ASIZE) fifomem (.*);
  rptr_empty #(ASIZE) rptr_empty (.*);
  wptr_full #(ASIZE) wptr_full (.*);

endmodule
