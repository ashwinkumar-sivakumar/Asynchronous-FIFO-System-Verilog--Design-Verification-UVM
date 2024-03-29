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


    

endmodule

 