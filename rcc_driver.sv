/*
* Driver communicates with the DUT at pin level.
* It receives the stimulus from the sequencer in form of transactions
* Within Driver synchroization betwen sequencer and driver takes place via handshaking
*/

class rcc_driver extends uvm_driver#(rcc_transaction);
	`uvm_component_utils(rcc_driver)

	// virtual interface declaration
	virtual rcc_if vif;

    uvm_analysis_port #(rcc_transaction) din_cov;
    uvm_analysis_port #(rcc_transaction) addrs_cov;

    rcc_transaction cov_din_tx;
    rcc_transaction cov_addr_tx;


	function new(string name, uvm_component parent);
		super.new(name, parent);

	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

            din_cov = new("din_cov", this);
            addrs_cov = new("addrs_cov", this);

            cov_din_tx = rcc_transaction::type_id::create("cov_din_tx", this);
            cov_addr_tx = rcc_transaction::type_id::create("cov_addr_tx", this);

	        // get the virtual interface handle that was stored in the uvm_config_db
	        // and assign it to the local vif field
		    if(!uvm_config_db#(virtual rcc_if)::get(this, "", "vif", vif))
			`uvm_fatal("No Vif", {"virtual interface must be set for: ", get_full_name(), ".vif"});

	endfunction: build_phase

  bit [3:0] g_address, digcnt, qcnt;
  bit [15:0] g_din;

	// using sequence_item_port connect with sequencer
	// get the transaction and then drive the DUT
	task run_phase(uvm_phase phase);

		reset(); // reset task
		forever
			begin

				rcc_transaction rcc_tx;
				seq_item_port.get_next_item(rcc_tx); // get the transaction from sequencer
				digcnt = rcc_tx.digcnt;
                               seq_item_port.item_done();

				repeat(digcnt)
					begin
						repeat(4) // wait for 4 clock edges //
					  		@(posedge vif.clk);

						g_address = 0;

                                           seq_item_port.get_next_item(rcc_tx); 
						g_din = rcc_tx.g_din;
					seq_item_port.item_done();

					cov_din_tx.g_din = g_din; // for din coverage
					din_cov.write(cov_din_tx);

						repeat(8) // for 8 registers write the data //
							begin

								write_it;
                                                              g_address = g_address +1;
							//if(rcc_tx.randomize())
							seq_item_port.get_next_item(rcc_tx);
                                                             //  g_din = rcc_tx.g_din;
							seq_item_port.item_done();

							seq_item_port.get_next_item(rcc_tx);
                                                               g_din = rcc_tx.g_din;
							seq_item_port.item_done();
							//$display("input: %h", g_din);
 								

                                		cov_din_tx.g_din = g_din; // for din coverage
                                		din_cov.write(cov_din_tx);
                                 

							end
                                		//cov_din_tx.g_din = g_din; // for din coverage
                                		//din_cov.write(cov_din_tx);
						write_it;
						g_address = 0;
                                         

						repeat(160)
						  @(posedge vif.clk);
					end //digcnt

					//if(rcc_tx.randomize())
                                   seq_item_port.get_next_item(rcc_tx);
					qcnt = rcc_tx.qcnt;
                                    seq_item_port.item_done();

					repeat(qcnt)
						begin
							repeat(4)
							  @(posedge vif.clk);

							g_address = 0;
							g_din = 0;

                                                       //seq_item_port.get_next_item(rcc_tx);
							//rcc_tx.g_din = g_din;
                                                      // seq_item_port.item_done();


							repeat(8)
								begin
								  write_it;
								  g_address = g_address +1;
								end

							write_it;
							g_address = 0;

							repeat(160)
							  @(posedge vif.clk);

						end //qcnt
					//seq_item_port.item_done(); // transaction complete

					end //forever loop

endtask // run_phase

	task write_it();
	@(posedge vif.clk);
	vif.address <= g_address;
	vif.din <= g_din;

 cov_addr_tx.g_address = g_address; // for addrs coverage
 addrs_cov.write(cov_addr_tx);

	@(posedge vif.clk);
	vif.rcc_clk <= 1;
	@(posedge vif.clk);
	vif.rcc_clk <= 0;
	@(posedge vif.clk);
	vif.din <= 'bz;
        endtask



  //bit [8:0] [15:0] temp;
  // reset task, Resets the interface signals to default/initial values
  task reset();

    vif.test_mode = 0;
    vif.scan_in0 = 0;
    vif.scan_in1 = 0;
    vif.scan_en = 0;

    vif.din = 16'h0000;
    vif.address = 4'h0;

    vif.rcc_clk = 1'b0;
    vif.reset = 1'b0;
// assertion checks
    //vif.dout = 8'haa;
   // vif.dout_flag = 1'b0;

    @(negedge vif.clk);
    @(negedge vif.clk);
    vif.reset = 1;

  $display("----------- RESET START------");
    @(negedge vif.clk);
    @(negedge vif.clk);

    vif.reset = 0;
  $display("------------ RESET ENDS-----------");
  endtask


endclass: rcc_driver


