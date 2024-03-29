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
