class rcc_environment extends uvm_env;
	`uvm_component_utils(rcc_environment)

	rcc_agent       rcc_agnt;  // DUT out
        ref_pred        rcc_ref_pred; // Ref out
	rcc_scoreboard  rcc_scb;      // compare both outputs
        rcc_in_coverage    rcc_cov;
    rcc_out_coverage    rcc_out_cov;
        

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rcc_agnt = rcc_agent::type_id::create(.name("rcc_agnt"), .parent(this));
		rcc_scb  = rcc_scoreboard::type_id::create(.name("rcc_scb"), .parent(this));
		rcc_ref_pred  = ref_pred::type_id::create(.name("rcc_ref_pred"), .parent(this));
        rcc_cov  = rcc_in_coverage::type_id::create(.name("rcc_cov"), .parent(this));
        rcc_out_cov  = rcc_out_coverage::type_id::create(.name("rcc_out_cov"), .parent(this));

	endfunction: build_phase

	// Connect_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		rcc_agnt.mon2scb.connect(rcc_scb.out_dut);
		rcc_agnt.mon2ref.connect(rcc_ref_pred.analysis_export);
        rcc_ref_pred.ref2scb.connect(rcc_scb.out_ref);

        rcc_agnt.rcc_drvr.din_cov.connect(rcc_cov.cov_din); // coverage analysis connection
        rcc_agnt.rcc_drvr.addrs_cov.connect(rcc_cov.cov_addr); // coverage analysis connection

		rcc_agnt.mon2scb.connect(rcc_out_cov.out_dut_cov); // coverage analysis connection
        rcc_ref_pred.ref2scb.connect(rcc_out_cov.out_ref_cov); // coverage analysis connection

	endfunction

endclass: rcc_environment
