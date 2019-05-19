// Monitor takes the input from the reference model via a mailbox and checks DUT with ref. model
//

class rcc_out_coverage extends uvm_component;
	`uvm_component_utils(rcc_out_coverage)
	
	virtual rcc_if vif;
	
	uvm_analysis_export #(rcc_transaction) out_dut_cov;
    uvm_analysis_export #(rcc_transaction) out_ref_cov;

	uvm_tlm_analysis_fifo #(rcc_transaction) dut_cov_fifo;
	uvm_tlm_analysis_fifo #(rcc_transaction) ref_cov_fifo;
	
	rcc_transaction dut_trans_cov;
    rcc_transaction ref_trans_cov;
    
    bit count_min = 0;
    int watermark_count = 10;
    	
	bit [7:0] refmdl_dout;
	bit [7:0] rtl_dout;
    
      //declare coun for rtl digits
  int dut_1 = 0;
  int dut_2 = 0;
  int dut_3 = 0;
  int dut_a = 0;
  int dut_4 = 0;
  int dut_5 = 0;
  int dut_6 = 0;
  int dut_b = 0;
  int dut_7 = 0;
  int dut_8 = 0;
  int dut_9 = 0;
  int dut_c = 0;
  int dut_star = 0;
  int dut_0 = 0;
  int dut_pound = 0;
  int dut_d = 0;


  //declare coun for ref model digits
  int ref_1 = 0;
  int ref_2 = 0;
  int ref_3 = 0;
  int ref_a = 0;
  int ref_4 = 0;
  int ref_5 = 0;
  int ref_6 = 0;
  int ref_b = 0;
  int ref_7 = 0;
  int ref_8 = 0;
  int ref_9 = 0;
  int ref_c = 0;
  int ref_star = 0;
  int ref_0 = 0;
  int ref_pound = 0;
  int ref_d = 0;
    
    // coverage
 covergroup output_coverage; // @(posedge vif.digit_clk);

    cover_point_dout_rtl: coverpoint rtl_dout { bins dout_rtl_0 = {48}; // 48 is decimal 0
                                               bins dout_rtl_1 = {49};
                                               bins dout_rtl_2 = {50};
                                               bins dout_rtl_3 = {51};
                                               bins dout_rtl_4 = {52};
                                               bins dout_rtl_5 = {53};
                                               bins dout_rtl_6 = {54};
                                               bins dout_rtl_7 = {55};
                                               bins dout_rtl_8 = {56};
                                               bins dout_rtl_9 = {57};
                                               bins dout_rtl_a = {97};
                                               bins dout_rtl_b = {98};
                                               bins dout_rtl_c = {99};
                                               bins dout_rtl_d = {100};
                                               bins dout_rtl_star = {42};
                                               bins dout_rtl_pound = {35};
                                               ignore_bins ig_rtl = {[1:34], [36:41], [43:47], [58:96],[101:255]};
                                              }

      cover_point_out_ref: coverpoint refmdl_dout { bins out_ref_0 = {48};
                                               bins out_ref_1 = {49};
                                               bins out_ref_2 = {50};
                                               bins out_ref_3 = {51};
                                               bins out_ref_4 = {52};
                                               bins out_ref_5 = {53};
                                               bins out_ref_6 = {54};
                                               bins out_ref_7 = {55};
                                               bins out_ref_8 = {56};
                                               bins out_ref_9 = {57};
                                               bins out_ref_a = {97};
                                               bins out_ref_b = {98};
                                               bins out_ref_c = {99};
                                               bins out_ref_d = {100};
                                               bins out_ref_star = {42};
                                               bins out_ref_pound = {35};
                                               ignore_bins ig_ref = {[1:34], [36:41], [43:47], [58:96],[101:255]};
                                              }

       // cross coverage between ASCII digit produced by RTL and ref model
       cross_rtl_ref_out: cross cover_point_dout_rtl, cover_point_out_ref
       {
         bins cross_out_0 = binsof (cover_point_dout_rtl) intersect {48};
        bins cross_out_1 = binsof (cover_point_dout_rtl) intersect {49};
         bins cross_out_2 = binsof (cover_point_dout_rtl) intersect {50};
         bins cross_out_3 = binsof (cover_point_dout_rtl) intersect {51};
         bins cross_out_4 = binsof (cover_point_dout_rtl) intersect {52};
         bins cross_out_5 = binsof (cover_point_dout_rtl) intersect {53};
         bins cross_out_6 = binsof (cover_point_dout_rtl) intersect {54};
         bins cross_out_7 = binsof (cover_point_dout_rtl) intersect {55};
         bins cross_out_8 = binsof (cover_point_dout_rtl) intersect {56};
         bins cross_out_9 = binsof (cover_point_dout_rtl) intersect {57};
         bins cross_out_a = binsof (cover_point_dout_rtl) intersect {97};
         bins cross_out_b = binsof (cover_point_dout_rtl) intersect {98};
         bins cross_out_c = binsof (cover_point_dout_rtl) intersect {99};
         bins cross_out_d = binsof (cover_point_dout_rtl) intersect {100};
         bins cross_out_star = binsof (cover_point_dout_rtl) intersect {42};
         bins cross_out_pound = binsof (cover_point_dout_rtl) intersect {35};

        }

  endgroup //output_coverage



 // cross coverage for digit counts
  covergroup cross_digit_count; // @(posedge vif.digit_clk);

    cross_ref_1: coverpoint ref_1{option.auto_bin_max = 1;}
    cross_ref_2: coverpoint ref_2{option.auto_bin_max = 1;}
    cross_ref_3: coverpoint ref_3{option.auto_bin_max = 1;}
    cross_ref_4: coverpoint ref_4{option.auto_bin_max = 1;}
    cross_ref_5: coverpoint ref_5{option.auto_bin_max = 1;}
    cross_ref_6: coverpoint ref_6{option.auto_bin_max = 1;}
    cross_ref_7: coverpoint ref_7{option.auto_bin_max = 1;}
    cross_ref_8: coverpoint ref_8{option.auto_bin_max = 1;}
    cross_ref_9: coverpoint ref_9{option.auto_bin_max = 1;}
    cross_ref_0: coverpoint ref_0{option.auto_bin_max = 1;}
    cross_ref_a: coverpoint ref_a{option.auto_bin_max = 1;}
    cross_ref_b: coverpoint ref_b{option.auto_bin_max = 1;}
    cross_ref_c: coverpoint ref_c{option.auto_bin_max = 1;}
    cross_ref_d: coverpoint ref_d{option.auto_bin_max = 1;}
    cross_ref_star: coverpoint ref_star{option.auto_bin_max = 1;}
    cross_ref_pound: coverpoint ref_pound{option.auto_bin_max = 1;}


    cross_rtl_1: coverpoint dut_1{option.auto_bin_max = 1;}
    cross_rtl_2: coverpoint dut_2{option.auto_bin_max = 1;}
    cross_rtl_3: coverpoint dut_3{option.auto_bin_max = 1;}
    cross_rtl_4: coverpoint dut_4{option.auto_bin_max = 1;}
    cross_rtl_5: coverpoint dut_5{option.auto_bin_max = 1;}
    cross_rtl_6: coverpoint dut_6{option.auto_bin_max = 1;}
    cross_rtl_7: coverpoint dut_7{option.auto_bin_max = 1;}
    cross_rtl_8: coverpoint dut_8{option.auto_bin_max = 1;}
    cross_rtl_9: coverpoint dut_9{option.auto_bin_max = 1;}
    cross_rtl_0: coverpoint dut_0{option.auto_bin_max = 1;}
    cross_rtl_a: coverpoint dut_a{option.auto_bin_max = 1;}
    cross_rtl_b: coverpoint dut_b{option.auto_bin_max = 1;}
    cross_rtl_c: coverpoint dut_c{option.auto_bin_max = 1;}
    cross_rtl_d: coverpoint dut_d{option.auto_bin_max = 1;}
    cross_rtl_star: coverpoint dut_star{option.auto_bin_max = 1;}
    cross_rtl_pound: coverpoint dut_pound{option.auto_bin_max = 1;}


    digit_1: cross cross_ref_1, cross_rtl_1;
    digit_2: cross cross_ref_2, cross_rtl_2;
    digit_3: cross cross_ref_3, cross_rtl_3;
    digit_4: cross cross_ref_4, cross_rtl_4;
    digit_5: cross cross_ref_5, cross_rtl_5;
    digit_6: cross cross_ref_6, cross_rtl_6;
    digit_7: cross cross_ref_7, cross_rtl_7;
    digit_8: cross cross_ref_8, cross_rtl_8;
    digit_9: cross cross_ref_9, cross_rtl_9;
    digit_0: cross cross_ref_0, cross_rtl_0;
    digit_a: cross cross_ref_a, cross_rtl_a;
    digit_b: cross cross_ref_b, cross_rtl_b;
    digit_c: cross cross_ref_c, cross_rtl_c;
    digit_d: cross cross_ref_d, cross_rtl_d;
    digit_star: cross cross_ref_star, cross_rtl_star;
    digit_pound: cross cross_ref_pound, cross_rtl_pound;


  endgroup // cross_digit_count
    
    
    
    function new(string name= "", uvm_component parent);
		super.new(name, parent);
			output_coverage = new();
			cross_digit_count = new();
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
        	out_dut_cov = new("out_dut_cov", this);
        	out_ref_cov = new("out_ref_cov", this);

   			dut_cov_fifo = new("dut_cov_fifo", this);
			ref_cov_fifo = new("ref_cov_fifo", this);

			dut_trans_cov = rcc_transaction::type_id::create("dut_trans_cov", this);
			ref_trans_cov = rcc_transaction::type_id::create("ref_trans_cov", this);

	// get the virtual interface handle that was stored in the uvm_config_db
	// and assign it to the local vif field
			if(!uvm_config_db#(virtual rcc_if)::get(this, "", "vif", vif))
				`uvm_fatal("No Vif", {"virtual interface must be set for: ", get_full_name(), ".vif"});

	endfunction: build_phase
	
	function void connect_phase(uvm_phase phase);
		out_dut_cov.connect(dut_cov_fifo.analysis_export);
		out_ref_cov.connect(ref_cov_fifo.analysis_export);
	endfunction: connect_phase

  
  
	task run_phase(uvm_phase phase);
		forever begin
			@(posedge vif.digit_clk)
				dut_cov_fifo.get(dut_trans_cov);
                ref_cov_fifo.get(ref_trans_cov);
                
                rtl_dout = dut_trans_cov.dout;
                refmdl_dout = ref_trans_cov.dout;
                
              //  $display("rtl_dout; %c\n", rtl_dout);
               // $display("refmdl_dout; %c", refmdl_dout);
			
				if(rtl_dout == "1")      dut_1 += 1;
				else if(rtl_dout == "2") dut_2 += 1;
				else if(rtl_dout == "3") dut_3 += 1;
				else if(rtl_dout == "a") dut_a += 1;
				else if(rtl_dout == "4") dut_4 += 1;
				else if(rtl_dout == "5") dut_5 += 1;
				else if(rtl_dout == "6") dut_6 += 1;
				else if(rtl_dout == "b") dut_b += 1;
				else if(rtl_dout == "7") dut_7 += 1;
				else if(rtl_dout == "8") dut_8 += 1;
				else if(rtl_dout == "9") dut_9 += 1;
				else if(rtl_dout == "c") dut_c += 1;
				else if(rtl_dout == "*") dut_star += 1;
				else if(rtl_dout == "0") dut_0 += 1;
				else if(rtl_dout == "#") dut_pound += 1;
				else if(rtl_dout == "d") dut_d += 1;



				if(refmdl_dout == "1")      ref_1 += 1;
				else if(refmdl_dout == "2") ref_2 += 1;
				else if(refmdl_dout == "3") ref_3 += 1;
				else if(refmdl_dout == "a") ref_a += 1;
				else if(refmdl_dout == "4") ref_4 += 1;
				else if(refmdl_dout == "5") ref_5 += 1;
				else if(refmdl_dout == "6") ref_6 += 1;
				else if(refmdl_dout == "b") ref_b += 1;
				else if(refmdl_dout == "7") ref_7 += 1;
				else if(refmdl_dout == "8") ref_8 += 1;
				else if(refmdl_dout == "9") ref_9 += 1;
				else if(refmdl_dout == "c") ref_c += 1;
				else if(refmdl_dout == "*") ref_star += 1;
				else if(refmdl_dout == "0") ref_0 += 1;
				else if(refmdl_dout == "#") ref_pound += 1;
				else if(refmdl_dout == "d") ref_d += 1;
				
				cross_digit_count.sample;
				output_coverage.sample;


/*$display("--------- dut_1  count     = %d", dut_1 );
$display("--------- dut_2  count     = %d",  dut_2 );
$display("--------- dut_3  count     = %d",  dut_3 );
$display("--------- dut_a  count     = %d",  dut_a );
$display("--------- dut_4  count     = %d",  dut_4 );
$display("--------- dut_5  count     = %d",  dut_5 );
$display("--------- dut_6  count     = %d",  dut_6 );
$display("--------- dut_b  count     = %d",  dut_b );
$display("--------- dut_7  count     = %d",  dut_7 );
$display("--------- dut_8  count     = %d",  dut_8 );
$display("--------- dut_9  count     = %d",  dut_9 );
$display("--------- dut_c  count     = %d",  dut_c );
$display("--------- dut_d  count     = %d",  dut_d );
$display("--------- dut_star count   = %d",  dut_star );
$display("--------- dut_0 count      = %d",  dut_0 );
$display("--------- dut_pound count  = %d\n",  dut_pound );

$display("--------- Count from REF Model ---------------\n");
      
$display("--------- ref_1  count     = %d",  ref_1 );
$display("--------- ref_2  count     = %d",  ref_2 );
$display("--------- ref_3  count     = %d",  ref_3 );
$display("--------- ref_a  count     = %d",  ref_a );
$display("--------- ref_4  count     = %d",  ref_4 );
$display("--------- ref_5  count     = %d",  ref_5 );
$display("--------- ref_6  count     = %d", ref_6 );
$display("--------- ref_b  count     = %d",  ref_b );
$display("--------- ref_7  count     = %d", ref_7 );
$display("--------- ref_8  count     = %d", ref_8 );
$display("--------- ref_9  count     = %d",  ref_9 );
$display("--------- ref_c  count     = %d",  ref_c );
$display("--------- ref_d  count     = %d",  ref_d );
$display("--------- ref_star count   = %d",  ref_star );
$display("--------- ref_0 count      = %d",  ref_0 );
$display("--------- ref_pound count  = %d",  ref_pound );*/

//$display("--------- dut_9  count     = %d",  dut_9 );
// Watermark check


      if(dut_1 >= watermark_count && dut_2 >= watermark_count && dut_3 >= watermark_count && dut_4 >= watermark_count && dut_5 >= watermark_count && dut_6 >= watermark_count && dut_7 >= watermark_count &&dut_8 >= watermark_count && dut_9 >= watermark_count && dut_0 >= watermark_count && dut_a >= watermark_count && dut_b >= watermark_count && dut_c >= watermark_count && dut_d >= watermark_count && dut_star >= watermark_count && dut_pound >= watermark_count) 

begin

             count_min = 1;

end

    if(count_min)
    begin

      $display("------Watermark of", " %d ",watermark_count, "reached for every digit----------");
      $finish;

    end
			
			end// forever
		
	endtask



endclass
