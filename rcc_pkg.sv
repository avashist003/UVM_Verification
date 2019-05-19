package rcc_pkg;
	import uvm_pkg::*;
//`include "rcc_assertions.sv"
	`include "rcc_sequencer.sv"
        `include "rcc_in_coverage.sv"
        `include "rcc_out_coverage.sv"
	`include "rcc_driver.sv"
	`include"rcc_monitor.sv"
	`include "rcc_agent.sv"
	`include "ref_pred.sv"
	`include "rcc_scoreboard.sv"
	`include "rcc_config.sv"
	`include "rcc_environment.sv"
	`include "rcc_test.sv"
        
endpackage: rcc_pkg
