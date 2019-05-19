// class that receives the data from agent and pass it to C-reference model
// and gets output returned from C-ref model

    // dpi imports
    import "DPI-C" function int input_arg( int array[8]);


class ref_pred extends uvm_subscriber #(rcc_transaction);
    `uvm_component_utils(ref_pred)

    // Analysis port for sending the ref model output to scoreboard
    uvm_analysis_port#(rcc_transaction) ref2scb;

    integer i= 0;
    integer j = 0;
    integer array_data[8];
    integer ref_out;


        rcc_transaction ref_output;
//ref_output = rcc_transaction::type_id::create("ref_output", this);

    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ref2scb = new("ref2scb", this);

ref_output = rcc_transaction::type_id::create("ref_output", this);

    endfunction


    function void write(rcc_transaction t);


		if(i <= 7) array_data[i] = t.g_din;

		    i = i+1;

		if(i == 9) 
	    	begin
       			ref_out = input_arg(array_data);
//$display("-------ref_out : %c\n", ref_out);
                ref_output.dout = ref_out;
ref2scb.write(ref_output);
    // send the ref_out to scoreboard
   //ref2scb.write(ref_out);
	            i = 0;
		        for(j = 0; j< 8; j++)
                    begin
		                array_data[j] = 0;
		            end
            end

    endfunction

   /*task run_phase(uvm_phase phase);
   
   //      forever begin
//$display("----------array_data = %h", array_data[0]);
//$display("----------------HERE---------------------\n");
//$display("-----------------------ref_out: %c \n", ref_out);
         ref2scb.write(ref_output);
        // end
    endtask */


endclass


/*------ debug --------------------------------------
$display("----------array_data = %h", array_data[0]);
$display("----------array_data = %h", array_data[1]);
$display("----------array_data = %h", array_data[2]);
$display("----------array_data = %h", array_data[3]);
$display("----------array_data = %h", array_data[4]);
$display("----------array_data = %h", array_data[5]);
$display("----------array_data = %h", array_data[6]);
$display("----------array_data = %h", array_data[7]);
//$display("----------array_data = %h", array_data[8]);
--------------------------------------------------------*/
