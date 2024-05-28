class sequencer extends uvm_sequencer #(transaction);
    `uvm_component_utils(sequencer)

    // Add your code here

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        // Add your code here
    endtask

endclass