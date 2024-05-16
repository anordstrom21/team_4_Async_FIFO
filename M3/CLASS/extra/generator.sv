class generator;

  virtual fifo_bfm bfm;

  function new (virtual fifo_bfm b);
    bfm = b;
  endfunction

  // Function to create random data to drive at fifo
  // Weighted to make 50% of values 0x00/0xFF
  // TODO: ? protected ? Do I need it? WHat does it do? 
  protected function logic [DATA_WIDTH-1:0] get_data();
    bit [1:0] zero_ones;
    zero_ones = $random;
    if (zero_ones == 2'b00)
      return 8'h00;
    else if (zero_ones == 2'b11)
      return 8'hFF;
    else
      return $random;
  endfunction : get_data


endclass