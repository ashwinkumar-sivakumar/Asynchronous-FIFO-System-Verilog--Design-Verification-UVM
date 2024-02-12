
module async_fifo1 #(parameter DSIZE = 8, ASIZE = 8) (
  async_fifo_if.master bus
);
  logic [ASIZE-1:0] waddr, raddr;
  logic [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

 /* sync_r2w sync_r2w (.*);
  sync_w2r sync_w2r (.*);
  fifomem #(DSIZE, ASIZE) fifomem (.*);
  rptr_empty #(ASIZE) rptr_empty (.*);
  wptr_full #(ASIZE) wptr_full (.*); */

  sync_r2w sync_r2w (bus.wclk,bus.wrst_n,rptr,wq2_rptr);
  sync_w2r sync_w2r (bus.rclk ,bus.rrst_n,wptr,rq2_wptr);
  fifomem #(DSIZE, ASIZE) fifomem (bus.winc,bus.wfull,bus.wclk,waddr,raddr,bus.wdata,bus.rdata);
  rptr_empty #(ASIZE) rptr_empty (bus.rinc,bus.rclk,bus.rrst_n,rq2_wptr,bus.rempty,raddr,rptr);
  wptr_full #(ASIZE) wptr_full (bus.winc,bus.wclk,bus.wrst_n,wq2_rptr,bus.wfull,waddr,wptr);

endmodule
