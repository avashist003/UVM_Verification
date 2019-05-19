/*
* UVM has separate class hierarchy for data (stimulus)
*/

/*
* We use transactions to communicate between components
* Its a higher abstraction layer than signal level information
*/

// user defined transaction extends uvm_sequence_item
class rcc_transaction extends uvm_sequence_item;
	`uvm_object_utils(rcc_transaction)

	rand bit [15:0] g_din;
	rand bit [3:0] digcnt;
	rand bit [3:0] qcnt;
	bit [7:0] dout; // need for output checking
         bit [3:0] g_address;

	function new(string name = "");
		super.new(name);
	endfunction: new

endclass: rcc_transaction


//---------------------------------------------------------------------------------------//


/*
* After we have created the transaction, we will create a sequence
*/

class rcc_sequence_child extends uvm_sequence#(rcc_transaction);
	`uvm_object_utils(rcc_sequence_child)

    rcc_transaction rcc_tx;

	function new(string name = "");
		super.new(name);
	endfunction: new

// body defines the behavior of the sequence
	task body();

			  rcc_tx = rcc_transaction::type_id::create("rcc_tx");
		//repeat(9)
		//begin
			start_item(rcc_tx);
                        if(rcc_tx.randomize())
			//assert(rcc_tx.randomize());
			finish_item(rcc_tx);
			
		//end
	endtask: body

endclass: rcc_sequence_child


class rcc_sequencer extends uvm_sequencer#(rcc_transaction);
	`uvm_object_utils(rcc_sequencer)

	function new(string name = "");
		super.new(name);
	endfunction: new

endclass: rcc_sequencer


// this is top level sequenc that we start from uvm test class, which inturn creates 
//different sequence objects of child sequence. 

class rcc_sequence extends uvm_sequence#(rcc_transaction);
	`uvm_object_utils(rcc_sequence)

    //rcc_transaction rcc_tx;
    rcc_sequencer rcc_seqr; // handle to sequencer

	function new(string name = "");
		super.new(name);
	endfunction: new

// body defines the behavior of the sequence
	task body();

     forever begin
        rcc_sequence_child seq;
        seq = rcc_sequence_child::type_id::create("seq"); // create child sequence object

       if(!seq.randomize())
            `uvm_error(get_type_name(), "Failed to randomize sequence")
//$display("First here: %d \n", $time);
        seq.start(rcc_seqr, this);
//$display("end here: %d \n", $time);
      end
	endtask: body

endclass: rcc_sequence


