`include "uvm_macros.svh"
`include "rcc_pkg.sv"
`include "rcc_if.sv"

module test;

    import uvm_pkg::*;

	// this package includes all our class definetion
    import rcc_pkg::*;


    import "DPI" function int sim_start_time();
    import "DPI" function void start_day_date();
    import "DPI" function void digit_gen_time(int dig_time);

    int sim_start;
    int sim_finish_time, execution_time;

	// instantiate the interface in top level module
    rcc_if intf();

    // coverage instance for coverage result display
    rcc_in_coverage cov_in;
    rcc_out_coverage cov_out;

	// connect the DUT with the interface
	results_conv top(
		          .clk(intf.clk),
		          .reset(intf.reset),
		          .test_mode(intf.test_mode),
		          .rcc_clk(intf.rcc_clk),
		          .address(intf.address),
		          .din(intf.din),
		          .digit_clk(intf.digit_clk),
		          .dout(intf.dout),
	`ifdef NETLIST
		          .dout_flag(intf.dout_flag),
		          .scan_in0(intf.scan_in0),
		          .scan_in1(intf.scan_in1),
		          .scan_en(intf.scan_en)
	`else
		          .dout_flag(intf.dout_flag)
	`endif
		         );


    rcc_assertions ass_rcc(intf);

	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		// we pass the virtual interface using config database
		uvm_config_db #(virtual rcc_if)::set(null, "*", "vif", intf);

		// execute the test
		run_test();
	end	

        initial begin
            $timeformat(-9, 2, "ns", 16);
            $set_coverage_db_name("results_conv");
            `ifdef SDFSCAN
               $sdf_annotate("sdf/results_cov_tsmc18_scan.sdf", test.top);
             `endif
        end

	initial begin
		intf.clk <= 1'b0;
	end

	always begin
		#25 intf.clk = ~intf.clk;
	end

// wall time
    initial begin
        sim_start = sim_start_time();
        $display("-----------------------------------------------------\n");

        $display("----------------SIMULATION STARTS AT: ----------------------------\n");
        start_day_date();
    end

// final block that is executed at the end of the simulation
// print other useful information like coverage results, finish wall time
    final begin
        sim_finish_time = sim_start_time();
        execution_time = sim_finish_time - sim_start;

         $display("-----------------------------------------------------\n");
        $display("Total Execution Time in days/hours/minutes/seconds is: ");
        digit_gen_time(execution_time);

     // print coverage at the end of simulation
        $display("din coverage for RTL = %f ", cov_in.din_rtl.get_coverage() );
        $display("address coverage for RTL = %f\n ", cov_in.addr_rtl.get_coverage());

        $display("RTL dout coverage for RTL = %f ", cov_out.output_coverage.cover_point_dout_rtl.get_coverage() );
        $display("Ref Model dout coverage for RTL = %f\n ", cov_out.output_coverage.cover_point_out_ref.get_coverage() );

        $display("dout cross coverage for RTL = %f ", cov_out.output_coverage.cross_rtl_ref_out.get_coverage() );

        $display("digit count cross coverage = %f\n ", cov_out.cross_digit_count.get_coverage() );

        $display("\n------------SIMULATION ENDS AT: -----------------");
        start_day_date();
        $display("----------------END------------------");
    end


endmodule
