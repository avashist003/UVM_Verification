/*
* test case for the RCC. It extends uvm_test base class
* 1) it drives the sequence by connecting the sequence with sequencer
* 2) create the env block
*/

class rcc_test extends uvm_test;
	//register the class name with uvm factory
	`uvm_component_utils(rcc_test)

	//instantiate the env
	rcc_environment rcc_env;

	function new(string name = "rcc_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new

	// UVM build_phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		rcc_env = rcc_environment::type_id::create(.name("rcc_env"), .parent(this));
	endfunction: build_phase

	// UVM run_phase
	task run_phase(uvm_phase phase);
		// declare instance of sequence
		rcc_sequence rcc_seq;
		// create the sequence
		rcc_seq = rcc_sequence::type_id::create("rcc_seq");
                 assert(rcc_seq.randomize());

		phase.raise_objection(.obj(this));
		// test will call start() method of the sequence to initialte the execution of the sequence
		// and the argument is the sequencer on which sequence is going to start
		rcc_seq.start(rcc_env.rcc_agnt.rcc_seqr, null);
		phase.drop_objection(.obj(this));

	endtask: run_phase
endclass: rcc_test
