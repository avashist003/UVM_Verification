class rcc_in_coverage extends uvm_component;
    `uvm_component_utils(rcc_in_coverage)

    virtual rcc_if vif;

    uvm_analysis_export #(rcc_transaction) cov_din;
    uvm_analysis_export #(rcc_transaction) cov_addr;

    uvm_tlm_analysis_fifo #(rcc_transaction) cov_din_fifo;
    uvm_tlm_analysis_fifo #(rcc_transaction) cov_addr_fifo;

    rcc_transaction seq_din;
    rcc_transaction seq_addr;

    rcc_transaction seq_in;
    rcc_transaction seq_ad;

    covergroup din_rtl; // @(posedge vif.clk);
        cover_point_din_rtl: coverpoint seq_in.g_din {option.auto_bin_max = 65535;}
    endgroup

    covergroup addr_rtl; //@(posedge vif.rcc_clk);

        cover_point_addr_rtl: coverpoint seq_ad.g_address{ bins addrs_0 = {0};
                                                  bins addrs_1 = {1};
                                                  bins addrs_2 = {2};
                                                  bins addrs_3 = {3};
                                                  bins addrs_4 = {4};
                                                  bins addrs_5 = {5};
                                                  bins addrs_6 = {6};
                                                  bins addrs_7 = {7};
                                                  ignore_bins ig = {[8:15]};
                                                 }

    endgroup


    function new(string name = "", uvm_component parent);
        super.new(name, parent);
            din_rtl = new();
            addr_rtl = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

              if(!uvm_config_db#(virtual rcc_if)::get(this, "", "vif", vif))
	      `uvm_fatal("No Vif", {"virtual interface must be set for: ", get_full_name(), ".vif"});

            seq_in = rcc_transaction::type_id::create("seq_in", this);
            seq_ad = rcc_transaction::type_id::create("seq_ad", this);

            cov_din = new("cov_din", this);
            cov_addr = new("cov_addr", this);

            cov_din_fifo = new("cov_din_fifo", this);
            cov_addr_fifo = new("cov_addr_fifo", this);

            seq_din = rcc_transaction::type_id::create("seq_din", this);
            seq_addr = rcc_transaction::type_id::create("seq_addr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        cov_din.connect(cov_din_fifo.analysis_export);
        cov_addr.connect(cov_addr_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
            fork
                din_coverage();
                addr_coverage();
            join_none

    endtask

    task din_coverage;
        forever begin
        @(posedge vif.clk)
        cov_din_fifo.get(seq_din);
        seq_in.g_din = seq_din.g_din;
      //$display("cov input : %h\n", seq_in.g_din);
        din_rtl.sample();
       // $display("input cov: %f\n", din_rtl.get_coverage());
        end
    endtask

    task addr_coverage;
        forever begin
        @(posedge vif.rcc_clk)
        cov_addr_fifo.get(seq_addr);
        seq_ad.g_address = seq_addr.g_address;
        //$display("cov input : %h\n", seq_ad.g_address);
        addr_rtl.sample();
       // $display("input address cov: %f\n", addr_rtl.get_coverage());
       end

    endtask


endclass


