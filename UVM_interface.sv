interface async_fifo_if #(parameter DSIZE = 8, ASIZE = 8);
  logic [DSIZE-1:0] wdata;
  logic winc;
  logic wclk;
  logic wrst_n;
  logic [DSIZE-1:0] rdata;
  logic rinc;
  logic rclk;
  logic rrst_n;
  logic wfull;
  logic rempty;
//Tb parameters
  int uniq_id;
  int tx_count=30;
  logic [8-1:0] verif_data_q[$];
  logic [8-1:0] verif_wdata;
  int i;
  // Define clocking block for write clock
  /*clocking wr_clk @(posedge wclk);
    output winc, wrst_n;
  endclocking

  // Define clocking block for read clock
  clocking rd_clk @(posedge rclk);
    output rinc, rrst_n;
  endclocking */

  modport master (
    input wclk, wrst_n,wdata,
    output  winc, wfull,
    input rclk, rrst_n,rinc,
    output rdata,rempty
  );

  

endinterface
