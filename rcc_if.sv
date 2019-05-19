/*
* RCC interface
*/
interface rcc_if;

  bit reset, clk;

  bit rcc_clk;

  logic [3:0] address;

  logic [15:0] din;

  bit digit_clk;

  logic [7:0] dout;

  logic dout_flag;

  bit test_mode;

  bit scan_in0, scan_in1, scan_en;

  bit scan_out0, scan_out1;


endinterface:rcc_if


