class my_env extends uvm_env;

    // Register the class with the factory
    `uvm_component_utils(my_env)

    // Constructor with name and parent
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Add your component instantiation and configuration here

    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        // Add your test sequence and other testbench activities here

    endtask

endclass

`endif // MY_ENVIRONMENT_SV