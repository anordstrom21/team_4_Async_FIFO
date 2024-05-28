class my_test extends uvm_test;

    // Register the class with the factory 
    `uvm_component_utils(my_test);

    my_env environment_h;

    // Define the constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment_h = my_env::type_id::create("environment_h", this);
    endfunction
  
  
    // Override the run_phase() method
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        fifo_sequence sequence_h;
        sequence_h = fifo_sequence::type_id::create("sequence_h");

        if (!sequence_h.randomize())
            `uvm_error("RANDOMIZE", "Failed to randomize sequence")

        sequence_h.starting_phase = phase;

        sequence_h.start(environment_h.sequencer_h);
        #10; // Example -> Consume some arbitrary time

        // UVM Macro to report a message
        // 1st argument: The type name of the component
        // 2nd argument: The message to report
        // 3rd argument: The verbosity level
        `uvm_info(get_type_name(), "Hello, World!", UVM_MEDIUM);

        phase.drop_objection(this); 
    endtask
  
endclass