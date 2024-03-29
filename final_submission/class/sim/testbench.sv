`include "interface.sv"
`include "test.sv"

module async_fifo1_tb_uvm;

  parameter DSIZE = 8;
  parameter ASIZE = 8;
  parameter IDLE_R =3;
  parameter IDLE_W=1; 
  
   


  // Model a queue for checking data

  //reg [DSIZE-1:0] verif_data_q[$];
  //reg [DSIZE-1:0] verif_wdata;


  
async_fifo_if bus_tb();
test test_inst(bus_tb);

async_fifo1 #(DSIZE, ASIZE) dut (
    .bus(bus_tb)
  );


// Coverage declarations
  covergroup fifo_coverage;
    option.per_instance = 1;
    coverpoint bus_tb.wdata {
      bins wdata_bin[] = {[8'h00:8'hFF]};
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
      bins wfull_bin = {0, 1};
    }
    coverpoint bus_tb.rempty {
      bins rempty_bin = {0, 1};
    }
  endgroup

  
    
  initial begin
   
    bus_tb.wclk = 1'b0;
    bus_tb.rclk = 1'b0;
       
  
    fork
      forever #10ns bus_tb.wclk = ~bus_tb.wclk;
      forever #35ns bus_tb.rclk = ~bus_tb.rclk;
    join
  end
    
 initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
initial begin 
fifo_coverage fifo_cov; // Instantiate the coverage group
fifo_cov=new();

     forever begin@(negedge bus_tb.wclk);
        fifo_cov.sample();

     end

  end

endmodule

 