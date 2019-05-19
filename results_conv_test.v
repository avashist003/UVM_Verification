
/*
 *
 * Author:  Mark A. Indovina
 *          Rochester, NY, USA
 *
 */


`timescale 1ns / 1ns

module test;

wire  digit_clk;

reg  clk, rcc_clk, reset, test_mode;

wire dout_flag;
wire [7:0]  dout;
wire [7:0]  dout_char = dout & 8'h7f ;

reg [3:0]  g_address, address, digcnt, qcnt;
reg [15:0]  g_din, din;
reg scan_in0, scan_in1, scan_en;

results_conv top (
                 .clk(clk),
                 .reset(reset),
                 .test_mode(test_mode),
                 .rcc_clk(rcc_clk),
                 .address(address),
                 .din(din),
                 .digit_clk(digit_clk),
                 .dout(dout),
`ifdef NETLIST
                 .dout_flag(dout_flag),
                 .scan_in0(scan_in0),
                 .scan_in1(scan_in1),
                 .scan_en(scan_en)
`else
                 .dout_flag(dout_flag)
`endif
             ) ;


initial
begin
    $timeformat(-9,2,"ns", 16);
`ifdef SDFSCAN
    $sdf_annotate("sdf/results_conv_tsmc18_scan.sdf", test.top);
`endif
    test_mode = 0;
    scan_in0 = 0;
    scan_in1 = 0;
    scan_en = 0;

    address[3:0] = 4'b0000;
    g_address[3:0] = 4'b0000;

    clk = 1'b0;
    din[15:0] = 16'b0000000000000000;
    g_din[15:0] = 16'b0000000000000000;

    rcc_clk = 1'b0;
    test_mode = 1'b0;
    reset = 1'b0;
    @(negedge clk) ;
    @(negedge clk) ;
    reset = 1'b1;
    @(negedge clk) ;
    @(negedge clk) ;
    reset = 1'b0;

    repeat (1024)
    begin
        digcnt = $random ;
        repeat (digcnt)
        begin
            repeat (4)
                @(posedge clk);
            g_address = 0 ;
            g_din = $random ;
            repeat (8)
            begin
                write_it ;
                g_address = g_address + 1 ;
                g_din = $random ;
            end
            write_it ;
            g_address = 0 ;
            repeat (160)
                @(posedge clk) ;
        end
        qcnt = $random ;
        repeat (qcnt)
        begin
            repeat (4)
                @(posedge clk);
            g_address = 0 ;
            g_din = 0 ;
            repeat (8)
            begin
                write_it ;
                g_address = g_address + 1 ;
            end
            write_it ;
            g_address = 0 ;
            repeat (160)
                @(posedge clk) ;
        end
    end
    $stop ;
end

always #25 clk = ~clk ;


always @(posedge digit_clk)
begin
    #0 ;
    $display( "Time: %t", $time, ", Digit Clock: %b", digit_clk, ", Digit: \"%c\"", dout, ", Dout Flag: %b", dout_flag );
end

task write_it ;
    begin
        @(posedge clk) ;
        address <= g_address ;
        din <= g_din ;
        @(posedge clk)
         rcc_clk <= 1 ;
        @(posedge clk)
         rcc_clk <= 0 ;
        @(posedge clk) ;
        din <= 'bz ;
    end
endtask

endmodule
