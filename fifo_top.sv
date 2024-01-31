module async_fifo1 (interface bus);
  parameter DSIZE =8;
  parameter ASIZE =4;


  logic [ASIZE-1:0] waddr, raddr;
  logic [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w sync_r2w (bus.wclk,bus.wrst_n,rptr,wq2_rptr);
  sync_w2r sync_w2r (bus.rclk ,bus.rrst_n,wptr,rq2_wptr);
  fifomem #(DSIZE, ASIZE) fifomem (bus.winc,bus.wfull,bus.wclk,waddr,raddr,bus.wdata,bus.rdata);
  rptr_empty #(ASIZE) rptr_empty (bus.rinc,bus.rclk,bus.rrst_n,rq2_wptr,bus.rempty,raddr,rptr);
  wptr_full #(ASIZE) wptr_full (bus.winc,bus.wclk,bus.wrst_n,wq2_rptr,bus.wfull,waddr,wptr);

endmodule

  interface bus;

logic wclk;
logic wrst_n;
logic winc;
logic rclk;
logic rinc;
logic rrst_n;
  logic[7:0] wdata;
  logic[7:0] rdata;
//logic wr_cs;
//logic wr_en;
//logic rd_cs;
//logic rd_en;
logic rempty;
logic wfull;

endinterface: bus
