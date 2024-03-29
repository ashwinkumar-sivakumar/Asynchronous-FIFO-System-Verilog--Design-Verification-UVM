// Code your design here

module async_fifo1 #(parameter DSIZE = 8, ASIZE = 8) (
  async_fifo_if.master bus
);
  logic [ASIZE-1:0] waddr, raddr;
  logic [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

   sync_r2w sync_r2w (bus.wclk,bus.wrst_n,rptr,wq2_rptr);
  sync_w2r sync_w2r (bus.rclk ,bus.rrst_n,wptr,rq2_wptr);
  fifomem #(DSIZE, ASIZE) fifomem (bus.winc,bus.wfull,bus.wclk,waddr,raddr,bus.wdata,bus.rdata);
  rptr_empty #(ASIZE) rptr_empty (bus.rinc,bus.rclk,bus.rrst_n,rq2_wptr,bus.rempty,raddr,rptr);
  wptr_full #(ASIZE) wptr_full (bus.winc,bus.wclk,bus.wrst_n,wq2_rptr,bus.wfull,waddr,wptr);

endmodule

module fifomem
#(
  parameter DATASIZE = 8, // Memory data word width
  parameter ADDRSIZE = 8  // Number of mem address bits
)
(
  input logic  winc, wfull, wclk,
  input logic  [ADDRSIZE-1:0] waddr, raddr,
  input logic  [DATASIZE-1:0] wdata,
  output logic [DATASIZE-1:0] rdata
);

  // RTL Verilog memory model
  localparam DEPTH = 255;//2*addsize

  logic [DATASIZE-1:0] mem [0:DEPTH-1];

  always_comb begin
   rdata = mem[raddr];
  end

  always_ff @(posedge wclk)
    if (winc && !wfull)
      mem[waddr] <= wdata;

endmodule

module rptr_empty
#(
  parameter ADDRSIZE = 8
)
(
  input logic  rinc, rclk, rrst_n,
  input logic  [ADDRSIZE :0] rq2_wptr,
  output logic rempty,
  output logic [ADDRSIZE-1:0] raddr,
  output logic [ADDRSIZE :0] rptr
);

  logic [ADDRSIZE:0] rbin;
  logic [ADDRSIZE:0] rgraynext, rbinnext;

  //-------------------
  // GRAYSTYLE2 pointer
  //-------------------
  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rbin, rptr} <= '0;
    else
      {rbin, rptr} <= {rbinnext, rgraynext};

  // Memory read-address pointer (okay to use binary to address memory)
  always_comb begin
  	raddr = rbin[ADDRSIZE-1:0];
  	rbinnext = rbin + (rinc & ~rempty);
  	rgraynext = (rbinnext>>1) ^ rbinnext;
  end

  //---------------------------------------------------------------
  // FIFO empty when the next rptr == synchronized wptr or on reset
  //---------------------------------------------------------------
     assign rempty_val = (rgraynext == rq2_wptr);

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;

endmodule


module sync_r2w
#(
  parameter ADDRSIZE = 8
)
(
  input logic   wclk, wrst_n,
  input logic  [ADDRSIZE:0] rptr,
  output logic [ADDRSIZE:0] wq2_rptr//readpointer with write side
);

  logic [ADDRSIZE:0] wq1_rptr;

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
    else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};

endmodule

module sync_w2r
#(
  parameter ADDRSIZE = 8
)
(
  input logic  rclk, rrst_n,
  input logic  [ADDRSIZE:0] wptr,
  output logic[ADDRSIZE:0] rq2_wptr
);

  logic [ADDRSIZE:0] rq1_wptr;

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rq2_wptr,rq1_wptr} <= 0;
    else
      {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};

endmodule

module wptr_full
#(
  parameter ADDRSIZE = 8
)
(
  input logic  winc, wclk, wrst_n,
  input logic  [ADDRSIZE :0] wq2_rptr,
  output logic  wfull,
  output logic [ADDRSIZE-1:0] waddr,
  output logic[ADDRSIZE :0] wptr
);

   logic [ADDRSIZE:0] wbin;
  logic [ADDRSIZE:0] wgraynext, wbinnext;
  logic wfull_val;
  // GRAYSTYLE2 pointer
  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      {wbin, wptr} <= '0;
    else
      {wbin, wptr} <= {wbinnext, wgraynext};

  // Memory write-address pointer (okay to use binary to address memory)
always_comb begin 
   waddr = wbin[ADDRSIZE-1:0];
   wbinnext = wbin + (winc & ~wfull);
   wgraynext = (wbinnext>>1) ^ wbinnext;
end
  //------------------------------------------------------------------
  // Simplified version of the three necessary full-tests:
  // assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
  // (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
  // (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
  //------------------------------------------------------------------
  assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      wfull <= 1'b0;
    else
      wfull <= wfull_val;

endmodule
