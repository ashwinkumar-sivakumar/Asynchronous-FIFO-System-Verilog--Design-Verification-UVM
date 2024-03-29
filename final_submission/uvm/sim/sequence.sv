class fifo_base_sequence extends uvm_sequence;
  
  `uvm_object_utils(fifo_base_sequence)
  
  fifo_sequence_item pkt;
  static int uniq_id;
  logic[7:0] wdata;
  bit rrst_n,wrst_n;
int valuesRead;
  //string filename; 
  //filename = "test.txt";
  int file;
  function new(string name = "fifo_base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  task body();
    `uvm_info("TEST_SEQ", "Inside task body!", UVM_HIGH)
    
     pkt = fifo_sequence_item::type_id::create("pkt");
    // Open the trace file
    
    file = $fopen("test.txt", "r");
    if (file == 0) begin
      //`uvm_error("TEST_SEQ", $sformatf("Failed to open file '%s' for reading", "test.txt"))
      return;
    end
    
    // Perform directed test cases
    while (!$feof(file)) begin
      start_item(pkt);
      valuesRead = $fscanf(file, "%h %b %b", wdata, wrst_n, rrst_n);
        assert(!$isunknown(wdata)) else
      `uvm_error("ASSERTION", "This is error inducing testcase, Data has bits with x or z");
      // Read wdata from the trace file
      
      //$fscanf(file,"%h %b %b", wdata,wrst_n,rrst_n);
        // Modify uniq_id field
      pkt.wrst_n = wrst_n;
      pkt.rrst_n = rrst_n;
      if(pkt.wrst_n==1)
         pkt.uniq_id = ++uniq_id;
         pkt.wdata = wdata; 
     
      
      
      
      if (pkt.uniq_id == 1) begin
        pkt.print();
        `uvm_info("TEST SEQUENCE", $sformatf("Directed Test: Inputs wdata=%h, uniq_id=%d", pkt.wdata, pkt.uniq_id), UVM_LOW)
         
      end
      
      finish_item(pkt);
    end
    
    // Close the file
    $fclose(file);
  endtask: body
  
endclass: fifo_base_sequence

  
 
  
  
  


class fifo_test_sequence extends fifo_base_sequence;
  
  `uvm_object_utils(fifo_test_sequence)
  fifo_sequence_item pkt;
  function new(string name = "fifo_test_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
   task body();
    `uvm_info("BASE_SEQ", "Inside task body!", UVM_HIGH)
    pkt = fifo_sequence_item::type_id::create("pkt");
    
    repeat(30) begin
      start_item(pkt);
     // pkt.reset();
      pkt.uniq_id = uniq_id++;
     
      pkt.randomize();// with {wrst_n == 1;};
       pkt.wrst_n = 1;
      pkt.rrst_n = 1;
      if(pkt.uniq_id ==1) begin
      pkt.print();
      `uvm_info("SEQUENCE", $sformatf("Inputs wdata= %h, uniq_id=%d", pkt.wdata,pkt.uniq_id), UVM_LOW)
      end
      finish_item(pkt);
    end
    
  endtask:body
  
endclass: fifo_test_sequence