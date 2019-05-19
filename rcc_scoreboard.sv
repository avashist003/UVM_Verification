// Checker receives the output from the Ref. Model and the output from DUT
// It compares both the outputs
// In this way it perform DUT vs Ref model verification


class rcc_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(rcc_scoreboard)


	uvm_analysis_export #(rcc_transaction) out_dut;
    uvm_analysis_export #(rcc_transaction) out_ref;

	uvm_tlm_analysis_fifo #(rcc_transaction) dut_fifo;
	uvm_tlm_analysis_fifo #(rcc_transaction) ref_fifo;
	
	//logic [7:0] dut_output, ref_output;
	
	virtual rcc_if vif;
        
		rcc_transaction dut_trans;
        rcc_transaction ref_trans;

	function new(string name= "", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
        out_dut = new("out_dut", this);
        out_ref = new("out_ref", this);

   		dut_fifo		= new("dut_fifo", this);
		ref_fifo		= new("ref_fifo", this);

dut_trans = rcc_transaction::type_id::create("dut_trans", this);
ref_trans = rcc_transaction::type_id::create("ref_trans", this);

	// get the virtual interface handle that was stored in the uvm_config_db
	// and assign it to the local vif field
		if(!uvm_config_db#(virtual rcc_if)::get(this, "", "vif", vif))
			`uvm_fatal("No Vif", {"virtual interface must be set for: ", get_full_name(), ".vif"});

	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		out_dut.connect(dut_fifo.analysis_export);
		out_ref.connect(ref_fifo.analysis_export);
	endfunction: connect_phase

	
	task run_phase(uvm_phase phase);

	   forever begin

            @(posedge vif.digit_clk)

                dut_fifo.get(dut_trans);
                ref_fifo.get(ref_trans);

    // using assertion to check the ref model and dut output
            assert(dut_trans.dout == ref_trans.dout)
               // $display("SUCCESS %c %c %d \n", dut_trans.dout, ref_trans.dout, $time);
                    else
                        $error("ERROR %c %c %d \n", dut_trans.dout, ref_trans.dout, $time);
	    end// forever
            

	endtask

endclass

