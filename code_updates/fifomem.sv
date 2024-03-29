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

