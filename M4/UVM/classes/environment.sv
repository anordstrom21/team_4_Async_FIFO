class my_env extends uvm_env;

    // Register the class with the factory
    `uvm_component_utils(my_env)

    sequencer sequencer_h;
    driver driver_h;

    // Constructor with name and parent
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        // super.build_phase(phase);  Not included in Doulos Video
        sequencer_h  = sequencer::type_id::create("sequencer_h", this);
        driver_h     = driver::type_id::create("driver_h", this);
    endfunction : build_phase

    // Connect the driver to the sequencer
    function void connect_phase(uvm_phase phase);
        // super.connect_phase(phase);  Not included in Doulos Video
        driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
    endfunction : connect_phase

    // Run phase
    task run_phase(uvm_phase phase);
        // super.run_phase(phase);   Not included in Doulos Video

        // Add your test sequence and other testbench activities here

    endtask : run_phase

endclass
