class my_test extends uvm_test;

    // Register the class with the factory 
    `uvm_component_utils(my_test);

    my_env env;

    // Define the constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction
  
  
    // Override the run_phase() method
    task run_phase(uvm_phase phase);
       phase.raise_objection(this);

        #10; // Example -> Consume some arbitrary time

        // UVM Macro to report a message
        // 1st argument: The type name of the component
        // 2nd argument: The message to report
        // 3rd argument: The verbosity level
        `uvm_info(get_type_name(), "Hello, World!", UVM_MEDIUM);

        phase.drop_objection(this); 
    endtask
  
endclass