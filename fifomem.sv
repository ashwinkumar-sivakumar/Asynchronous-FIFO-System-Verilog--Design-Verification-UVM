
// Ashwin module 
module fifomem
#(
  parameter DATASIZE = 8, // word width - not finalized 
  parameter ADDRSIZE = 4  // Nmem address bits  - not finalized
)
(
  input  logic winc, wfull, wclk,
  input  logic [ADDRSIZE-1:0] waddr, raddr,
  input  logic [DATASIZE-1:0] wdata,
  output logic [DATASIZE-1:0] rdata
);

  
  localparam DEPTH = 1<<ADDRSIZE;

  logic [DATASIZE-1:0] mem [0:DEPTH-1];
always_comb begin
  rdata <= mem[raddr];
end

  always_ff @(posedge wclk) begin
    if (winc && !wfull)
      mem[waddr] <= wdata;
  end
endmodule
