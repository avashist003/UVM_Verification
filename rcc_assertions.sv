/*
* Assertion module for the RCC block
*
*/


module rcc_assertions(rcc_if intf);


  always begin
    //forever begin
      @(posedge intf.clk)
        if(intf.reset == 1)
           assert (intf.dout == 8'hff)
           else
           //$stop;
           $display("ERROR: dout is not correctly initialized to reset value: %h", intf.dout);

        assert(intf.dout_flag == 1'b1)
        else
        $display("%b ERROR: dout_flag is not correctly initialized at reset", intf.dout_flag);

  end


// adding the concurrent assertions


    property din_rcc_clk;
      @(posedge intf.clk) 
        disable iff (intf.reset) $rose(intf.rcc_clk) |=> !$isunknown(intf.din);
    endproperty

   din_ckeck: assert property (din_rcc_clk) else begin
              $error("ERROR----------- din is unknown at rcc clock");
    end


// need to use non-overlapped operator //
/*    property digclk_doutflag;
      @(posedge intf.clk)
        disable iff (intf.reset) $changed(intf.dout_flag) |=> $rose(intf.digit_clk);
      endproperty

    dout_flag_check: assert property (digclk_doutflag) else begin
                    $error("ERROR-------------- digit clock %t", $time);
    end*/

endmodule //assertion
