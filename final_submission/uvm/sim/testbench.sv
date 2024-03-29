`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

//--------------------------------------------------------
//Include Files
//--------------------------------------------------------
`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

module async_fifo1_tb_uvm;

  parameter DSIZE = 8;
  parameter ASIZE = 8;
  parameter IDLE_R =3;
  parameter IDLE_W=1; 

  // Declare interface instance
  async_fifo_if bus_tb();

  // Instantiate DUT
  async_fifo1 #(DSIZE, ASIZE) dut (
    .bus(bus_tb)
  );

  // Coverage declarations
  covergroup fifo_coverage @(posedge bus_tb.wclk);
    option.per_instance = 1;

    // Coverpoint for individual bits of bus_tb.wdata
    coverpoint bus_tb.wdata {
      // Define bins for each bit separately, covering both 0 and 1
      bins wdata_bit0 = {1'b0, 1'b1}; // Bit 0
      bins wdata_bit1 = {1'b0, 1'b1}; // Bit 1
      bins wdata_bit2 = {1'b0, 1'b1}; // Bit 2
      bins wdata_bit3 = {1'b0, 1'b1}; // Bit 3
      bins wdata_bit4 = {1'b0, 1'b1}; // Bit 4
      bins wdata_bit5 = {1'b0, 1'b1}; // Bit 5
      bins wdata_bit6 = {1'b0, 1'b1}; // Bit 6
      bins wdata_bit7 = {1'b0, 1'b1}; // Bit 7
    }
    coverpoint bus_tb.rinc {
      bins rinc_bin[] = {0, 1};
    }
    coverpoint bus_tb.winc {
      bins rinc_winc[] = {0, 1};
    }
    coverpoint bus_tb.wrst_n {
      bins rinc_wrst_n[] = {0, 1};
    }
    coverpoint bus_tb.rrst_n {
      bins rinc_rrst_n[] = {0, 1};
    }
    // Coverpoints for wfull and rempty
    coverpoint bus_tb.wfull {
      bins wfull_bin[] = {0, 1};
    }
    coverpoint bus_tb.rempty {
      bins rempty_bin[] = {0, 1};
    }

    coverpoint bus_tb.wdata {
    bins wdata_onehot[] = {8'h01,8'h02,8'h04,8'h08,8'h10,8'h20,8'h40,8'h80};

    }
    coverpoint bus_tb.wdata {
    bins wdata_border[] = {8'hff,8'h00};

    }
 
  // Coverpoints for specific data patterns in wdata
  
  endgroup

  // Initial block to set up the test environment
  initial begin
    // Set up UVM environment
    uvm_config_db #(virtual async_fifo_if)::set(null, "*", "vif", bus_tb);

    // Initialize signals
    bus_tb.wclk = 1'b0;
    bus_tb.rclk = 1'b0;
    bus_tb.wrst_n = 0;
    bus_tb.rrst_n = 0;
    
    // Wait for reset to complete
    wait(!bus_tb.wrst_n);
    
    bus_tb.winc = 0;
    bus_tb.wdata = 0;
    bus_tb.rinc = 0;
     `uvm_info("TEST", $sformatf("\nTotal diected and  random Test transactions =%0d\n", bus_tb.tx_count), UVM_LOW)

    // Create a fork to generate clocks
    fork
      forever #2ns bus_tb.wclk = ~bus_tb.wclk;
      forever #5ns bus_tb.rclk = ~bus_tb.rclk;
    join
  end

initial begin

assert (!bus_tb.rinc) else
  `uvm_error("ASSERTION", "Read increment is active at the beginning of simulation");
  
assert (!bus_tb.winc) else
  `uvm_error("ASSERTION", "Write increment is active at the beginning of simulation");

assert (bus_tb.wclk === 0 || bus_tb.wclk === 1) else
  `uvm_error("ASSERTION", "Write clock has unexpected value");

assert (bus_tb.rclk === 0 || bus_tb.rclk === 1) else
  `uvm_error("ASSERTION", "Read clock has unexpected value");


assert (!bus_tb.wrst_n || (bus_tb.wclk && bus_tb.wdata)) else
  `uvm_error("ASSERTION", "Unexpected sequencing of write events");

assert (!bus_tb.rrst_n || (bus_tb.rclk && bus_tb.rdata)) else
  `uvm_error("ASSERTION", "Unexpected sequencing of read events");

while (!bus_tb.wclk) begin
    #1;

    assert (!bus_tb.wfull) else
    `uvm_error("ASSERTION", "Write FIFO is full at the beginning of simulation");
end
 while (!bus_tb.rclk) begin
    #1;


assert (bus_tb.rempty) else
  `uvm_error("ASSERTION", "Read FIFO is not empty at the beginning of simulation");
end

end

always begin


  // Other initializations...

  // Wait for a short delay
  
  // Wait for the positive edge of rclk
  wait (bus_tb.rclk == 1)
   

  // Wait for rinc to be 1
  wait (bus_tb.rinc ==1)
    

  // Wait for 3 rclk cycles
  repeat (3) @(posedge bus_tb.rclk);
    #1;
  assert (bus_tb.rinc) else
    `uvm_error("ASSERTION", "rinc is not high after 3 rclk cycles");
  
  // Add more assertions as needed...

end
  // Dump VCD file
  initial begin
    $dumpfile("d.vcd");
    $dumpvars();
  end

  // Create and sample coverage
  initial begin
    fifo_coverage fifo_cov = new();
    // Continuously sample coverage
    forever begin
      @(posedge bus_tb.wclk);
      fifo_cov.sample();
    end
  end

  // Start test
  initial begin
    run_test("fifo_test");
   
  end

endmodule
