## Advance UVM testbench with DPI integration, Assertions, Functional Coverage and Hierarchical Sequence

In this project a complete verification testbench architecture for a result character conversion chip is constructed.


![uvm_arch_v2](https://user-images.githubusercontent.com/13079690/69000332-b9e58000-089b-11ea-8f1e-323dc407b2ca.png)

- The testcase used for verification are the randomly generated input transactions for the DUT.
- Further the functional verification is performed by comparing the output of the DUT with that of reference model.
- To implement the reference model direct programming interface (DPI) functionality of SystemVerilog is used.
- The reference model is the software implementation of the DUT written using the C-programming language. 

# 100% Coverage Achieved for the DUT Verification

![UVM_Coverage_Netlist200](https://user-images.githubusercontent.com/13079690/69000386-d8984680-089c-11ea-9df2-3c81cf5377c3.png)

# Design Under test: RCC Unit used in DTMF Receiver

![uvm_dut](https://user-images.githubusercontent.com/13079690/69000445-bd7a0680-089d-11ea-8793-ee925c54bf82.png)
