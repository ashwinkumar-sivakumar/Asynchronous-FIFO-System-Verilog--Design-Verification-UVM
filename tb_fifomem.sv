
`timescale 1ns/1ps

module tb_fifomem;

  parameter DATASIZE = 8;
  parameter ADDRSIZE = 4;
  localparam DEPTH = 1 << ADDRSIZE;

  // DUT Inputs
  logic winc, wfull, wclk;
  logic [ADDRSIZE-1:0] waddr, raddr;
  logic [DATASIZE-1:0] wdata;

  // DUT Output
  logic [DATASIZE-1:0] rdata;

  // Instantiate the Device Under Test (DUT)
  fifomem #(.DATASIZE(DATASIZE), .ADDRSIZE(ADDRSIZE)) DUT (
    .winc(winc),
    .wfull(wfull),
    .wclk(wclk),
    .waddr(waddr),
    .raddr(raddr),
    .wdata(wdata),
    .rdata(rdata)
  );

  // Clock Generation
  initial begin
    wclk = 0;
    forever #5 wclk = ~wclk; // 100MHz clock
  end

  // Reset Logic
  initial begin
    wfull = 0; // Assume wfull is controlled externally
    winc = 0;
    waddr = 0;
    raddr = 0;
    wdata = 0;

    // Basic write and read test
    repeat (2) @(posedge wclk);
    wdata = 8'hAA; waddr = 0; winc = 1;
    @(posedge wclk);
    winc = 0; raddr = 0;
    
    // Full Memory Write and Read Test
    for (int i = 0; i < DEPTH; i++) begin
      @(posedge wclk);
      
      wdata = i; waddr = i; winc = 1;
      wfull = (i == DEPTH - 1) ? 1 : 0; // Simulate FIFO getting full
      @(posedge wclk);
      raddr <= i;
    end
    winc = 0;
    

    // Additional scenarios...
    // - Randomized Write and Read Test
    // - Write Full and Write Enable Interaction Test
    // - Reset Functionality Test
    // - Boundary Condition Test
    // - etc.

    $finish;
  end
// assertions check
property p_check_r_after_w;
        @(posedge wclk) (wdata==8'hAA) |-> ##1 (rdata == 8'hAA);
    endproperty

    assert property (p_check_r_after_w) $display("pass base property r after w");
        else $error("Basic write/read test failed rdata =%0d, time=%0t",rdata,$time);

property p2;
        @(posedge wclk) (winc && !wfull)&&(rdata !=170 &&wdata!=170) |-> (rdata == $past(wdata));
    endproperty

    assert property (p2) $display("pass base property2 r after w rdata=%0d, wdata=%0d, time=%t",rdata,$past(wdata),$time);
        else $error("Basic write/read test 2 failed rdata =%0d, wdata=%0d, time=%0t",rdata,$past(wdata),$time);


endmodule
