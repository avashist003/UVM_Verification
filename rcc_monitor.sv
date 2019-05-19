// Monitor Class
// It receives the response from the DUT and converts the signal level response into transactions
// sends the transactions to various other testbench components

class rcc_monitor extends uvm_monitor;
	`uvm_component_utils(rcc_monitor)

	// declare the interface
	virtual rcc_if vif;
	rcc_transaction rcc_tx;

	// Analysis Ports
	uvm_analysis_port#(rcc_transaction) mon2ref;
	uvm_analysis_port#(rcc_transaction) mon2scb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

	mon2ref = new("mon2ref", this);
	mon2scb = new("mon2scb", this);

	// get the virtual interface handle from config database
	if(!uvm_config_db#(virtual rcc_if)::get(this, "", "vif", vif))
        `uvm_fatal("No Vif", {"virtual interface must be set for: ", get_full_name(), ".vif"});
	endfunction: build_phase

bit [15:0] array_data [9];
integer i= 0;
integer j;

	task run_phase(uvm_phase phase);
		fork
		sample_input();
		sample_output();
		join

	endtask


	task sample_input;
		forever
			begin
			rcc_transaction data_collect;
			data_collect = rcc_transaction::type_id::create("data_collect", this);
				@(posedge vif.rcc_clk)
					data_collect.g_din = vif.din;
				mon2ref.write(data_collect);

				
			end //forever loop
	endtask // sample_input

	task sample_output;
		forever
			begin

				rcc_transaction data_collect_out;
				data_collect_out = rcc_transaction::type_id::create("data_collect_out", this);

				@(posedge vif.digit_clk)
					data_collect_out.dout = vif.dout;
			// Send the data through analysis port
				mon2scb.write(data_collect_out);

				
			end //forever loop
	endtask // sample_output

endclass

