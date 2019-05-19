/*

*/

class rcc_agent extends uvm_agent;
	`uvm_component_utils(rcc_agent)

	uvm_analysis_port #(rcc_transaction) mon2ref;
	uvm_analysis_port #(rcc_transaction) mon2scb;

	rcc_sequencer rcc_seqr;
	rcc_driver rcc_drvr;
	rcc_monitor rcc_mtr;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon2ref = new("mon2ref", this);
		mon2scb = new("mon2scb", this);

		rcc_seqr = rcc_sequencer::type_id::create(.name("rcc_seqr"), .parent(this));
		rcc_drvr = rcc_driver::type_id::create(.name("rcc_drvr"), .parent(this));
		rcc_mtr = rcc_monitor::type_id::create(.name("rcc_mtr"), .parent(this));

	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		// connect the analysis port of monitor to analysis port of agent
		rcc_mtr.mon2ref.connect(mon2ref);
		rcc_mtr.mon2scb.connect(mon2scb);

		// connect driver seq_item_port to sequencer seq_item_export
		rcc_drvr.seq_item_port.connect(rcc_seqr.seq_item_export);

	endfunction: connect_phase

endclass: rcc_agent
