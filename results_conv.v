
/*
 *
 * Author:  Mark A. Indovina
 *          Rochester, NY, USA
 *
 */


module results_conv (
           clk,
           reset,
           rcc_clk,
           address,
           din,
           digit_clk,
           dout,
           dout_flag,
           test_mode,
           scan_in0,
           scan_in1,
           scan_en,
           scan_out0,
           scan_out1
       ) ;

/*
 *
 * Results Character Conversion (RCC)
 *  processes a computed frequency spectrum to
 *  determine if a valid DTMF digit can be found
 *
 */

input
    clk,                    // system clock
    reset,                  // system reset
    rcc_clk ;             // data input write strobe

input [3:0]
      address ;               // holding register address bus

input [15:0]
      din ;                   // data input bus

output
    digit_clk ;            // data output write strobe

output [7:0]
       dout ;                  // data output bus

output
    dout_flag ;             // data output change flag

input
    test_mode,		    // test mode control
    scan_in0,           // test scan mode data input, chain 1
    scan_in1,           // test scan mode data input, chain 2
    scan_en;            // test scan mode enable

output
    scan_out0,          // test scan mode data output, chain 1
    scan_out1;          // test scan mode data output, chain 2

reg
    digit_clk,
    dout_flag,
    go,
    gt,
    ok,
    clear_flag,
    seen_quiet,
    start_gt,
    gt_done,
    clear_gt,
    start_ct,
    ct_done,
    clear_ct;

reg [2:0]
    low,
    high ;

reg [4:0]
    state,
    save_state;

reg [2:0]
    gt_state,
    ct_state;

reg [7:0]
    dout,
    out_p1,    // two stage pipeline for digit/ quiet framing; I should
    out_p2;    //  have used dout as part of the pipeline to save area...

reg [15:0]
    r697,
    r770,
    r852,
    r941,
    r1209,
    r1336,
    r1477,
    r1633,
    low_mag,
    high_mag,
    opa,
    opb,
    opc,
    opd ;

`include "include/results_conv.h"

wire flag_reset = (reset | clear_flag) & !test_mode ;

always @(negedge rcc_clk or posedge flag_reset)
    if (flag_reset)
        go <= 0 ;
    else
        go <= address[3] ;

always @(negedge rcc_clk)
case (address[3:0])
    `R_697  : r697  <= din ;
    `R_770  : r770  <= din ;
    `R_852  : r852  <= din ;
    `R_941  : r941  <= din ;
    `R_1209 : r1209 <= din ;
    `R_1336 : r1336 <= din ;
    `R_1477 : r1477 <= din ;
    `R_1633 : r1633 <= din ;
endcase

always @(posedge reset or posedge clk)
begin : rcc_machine
    if (reset)
    begin
        digit_clk 		<= 0 ;
        dout_flag 		<= 1 ;
        clear_flag 	<= 0 ;
        seen_quiet 	<= 1 ;
        out_p1 		<= 0 ;
        out_p2 		<= 8'hff ;
        low			<= 0 ;
        high 			<= 0 ;
        low_mag		<= 0 ;
        high_mag		<= 0 ;
        opa			<= 0 ;
        opb			<= 0 ;
        opc			<= 0 ;
        opd			<= 0 ;
        start_gt		<= 0 ;
        clear_gt		<= 0 ;
        start_ct		<= 0 ;
        clear_ct		<= 0 ;
        dout 			<= 8'hff ;
        state			<= `IDLE ;
        save_state		<= `IDLE ;
    end
    else
    begin
        case (state)
            `IDLE : begin
                if (go)
                begin
                    low 		<= 3'b100 ;
                    high 		<= 3'b100 ;
                    clear_flag 	<= 1 ;
                    out_p2 		<= out_p1 ;  // digit pipeline
                    //gt_comp( r697, r770, r852, r941 ) ;
                    opa <= r697 ;
                    opb <= r770 ;
                    opc <= r852 ;
                    opd <= r941 ;
                    start_gt <= 1 ;
                    save_state 	<= `F1 ;
                    state 	<= `GT_WAIT ;
                end
                else
                begin
                    state	<= `IDLE ;
                end
            end
            `F1 : begin
                clear_flag 	<= 0 ;
                if (gt)
                begin
                    low 	<= {1'b0, `V_697} ;
                    low_mag <= r697 ;
                end
                //gt_comp( r770, r697, r852, r941 ) ;
                opa <= r770 ;
                opb <= r697 ;
                opc <= r852 ;
                opd <= r941 ;
                start_gt <= 1 ;
                save_state 	<= `F2 ;
                state 	<= `GT_WAIT ;
            end
            `F2 : begin
                if (gt)
                begin
                    low 	<= {1'b0, `V_770} ;
                    low_mag <= r770 ;
                end
                //gt_comp( r852, r697, r770, r941 ) ;
                opa <= r852 ;
                opb <= r697 ;
                opc <= r770 ;
                opd <= r941 ;
                start_gt <= 1 ;
                save_state 	<= `F3 ;
                state 	<= `GT_WAIT ;
            end
            `F3 : begin
                if (gt)
                begin
                    low 	<= {1'b0, `V_852} ;
                    low_mag <= r852 ;
                end
                //gt_comp( r941, r697, r770, r852 ) ;
                opa <= r941 ;
                opb <= r697 ;
                opc <= r770 ;
                opd <= r852 ;
                start_gt <= 1 ;
                save_state 	<= `F4 ;
                state 	<= `GT_WAIT ;
            end
            `F4 : begin
                if (gt)
                begin
                    low 	<= {1'b0, `V_941} ;
                    low_mag <= r941 ;
                end
                //gt_comp( r1209, r1336, r1477, r1633 ) ;
                opa <= r1209 ;
                opb <= r1336 ;
                opc <= r1477 ;
                opd <= r1633 ;
                start_gt <= 1 ;
                save_state 	<= `F5 ;
                state 	<= `GT_WAIT ;
            end
            `F5 : begin
                if (gt)
                begin
                    high 	 <= {1'b0, `V_1209} ;
                    high_mag <= r1209 ;
                end
                //gt_comp( r1336, r1209, r1477, r1633 ) ;
                opa <= r1336 ;
                opb <= r1209 ;
                opc <= r1477 ;
                opd <= r1633 ;
                start_gt <= 1 ;
                save_state 	<= `F6 ;
                state 	<= `GT_WAIT ;
            end
            `F6 : begin
                if (gt)
                begin
                    high 	 <= {1'b0, `V_1336} ;
                    high_mag <= r1336 ;
                end
                //gt_comp( r1477, r1209, r1336, r1633 ) ;
                opa <= r1477 ;
                opb <= r1209 ;
                opc <= r1336 ;
                opd <= r1633 ;
                start_gt <= 1 ;
                save_state 	<= `F7 ;
                state 	<= `GT_WAIT ;
            end
            `F7 : begin
                if (gt)
                begin
                    high 	<= {1'b0, `V_1477} ;
                    high_mag<= r1477 ;
                end
                //gt_comp( r1633, r1209, r1336, r1477 ) ;
                opa <= r1633 ;
                opb <= r1209 ;
                opc <= r1336 ;
                opd <= r1477 ;
                start_gt <= 1 ;
                save_state 	<= `F8 ;
                state 	<= `GT_WAIT ;
            end
            `F8 : begin
                if (gt)
                begin
                    high 	 <= {1'b0, `V_1633} ;
                    high_mag <= r1633 ;
                end
                state 	 <= `CHECK ;
            end
            // did we find both frequencies?
            `CHECK : begin
                if (!low[2] && !high[2])
                begin
                    //check_twist( low_mag, high_mag ) ;
                    opa <= low_mag ;
                    opb <= high_mag ;
                    start_ct <= 1 ;
                    save_state 	<= `OK ;
                    state 	<= `CT_WAIT ;
                end
                else
                begin
                    out_p1 <= `NO_DIGIT ;
                    state <= `CHARACTER ;
                end
            end

            `OK : begin
                if (ok)
                begin
                    case ({low[1:0], high[1:0]})
                        key_1[3:0]     : out_p1 <= val_key_1 ;
                        key_2[3:0]     : out_p1 <= val_key_2 ;
                        key_3[3:0]     : out_p1 <= val_key_3 ;
                        key_a[3:0]     : out_p1 <= val_key_a ;
                        key_4[3:0]     : out_p1 <= val_key_4 ;
                        key_5[3:0]     : out_p1 <= val_key_5 ;
                        key_6[3:0]     : out_p1 <= val_key_6 ;
                        key_b[3:0]     : out_p1 <= val_key_b ;
                        key_7[3:0]     : out_p1 <= val_key_7 ;
                        key_8[3:0]     : out_p1 <= val_key_8 ;
                        key_9[3:0]     : out_p1 <= val_key_9 ;
                        key_c[3:0]     : out_p1 <= val_key_c ;
                        key_star[3:0]  : out_p1 <= val_key_star ;
                        key_0[3:0]     : out_p1 <= val_key_0 ;
                        key_pound[3:0] : out_p1 <= val_key_pound ;
                        key_d[3:0]     : out_p1 <= val_key_d ;
                        default        : out_p1 <= `NO_DIGIT ;
                    endcase
                    state 	<= `CHARACTER ;
                end
                else
                begin
                    out_p1 <= `NO_DIGIT ;
                    state <= `CHARACTER ;
                end
            end
            // should we output a new digit?
            //  need to see two frames worth for timing...
            `CHARACTER : begin
                if (out_p1 == out_p2)
                begin
                    // quiet tone?
                    if (out_p2 == `NO_DIGIT)
                    begin
                        seen_quiet 	<= 1 ;
                        state <= `IDLE ;
                    end
                    else
                    begin
                        if (seen_quiet)
                        begin
                            seen_quiet 	<= 0 ;
                            state	<= `P1 ;
                        end
                        else
                            state <= `IDLE ;
                    end
                end
                else
                    state <= `IDLE ;
            end
            // toggle msb for each new char...
            `P1 : begin
                dout 		<= { 1'b0, out_p2[6:0] } ;
                dout_flag 	<= ~dout_flag ;
                state	<= `P2 ;
            end
            `P2 : begin
                digit_clk <= 1 ;
                state	<= `P3 ;
            end
            `P3 : begin
                digit_clk <= 0 ;
                state	<= `IDLE ;
            end
            // wait for greater_than to finish
            `GT_WAIT : begin
                if (gt_done)
                begin
                    start_gt <= 0 ;
                    clear_gt <= 1 ;
                    state <= `GT_FINISH ;
                end
                else
                    state <= `GT_WAIT ;
            end
            `GT_FINISH : begin
                clear_gt <= 0 ;
                state <= save_state ;
            end
            // wait for check_twist to finish
            `CT_WAIT : begin
                if (ct_done)
                begin
                    start_ct <= 0 ;
                    clear_ct <= 1 ;
                    state <= `CT_FINISH ;
                end
                else
                    state <= `CT_WAIT ;
            end
            `CT_FINISH : begin
                clear_ct <= 0 ;
                state <= save_state ;
            end
            default : 	state 	<= `IDLE ;
        endcase
    end
end // rcc_machine

//
// 16 bit "greater-than" comparision
// we'll build our own pipelined comparitor here
// (we want to force resource sharring...)
//

reg [16:0]
    cmpb,
    cmpc,
    cmpd ;

always @(posedge reset or posedge clk)
begin : gt_comp
    if (reset)
    begin
        cmpb 	<= 0 ;
        cmpc 	<= 0 ;
        cmpd 	<= 0 ;
        gt 		<= 0 ;
        gt_done	<= 0 ;
        gt_state  <= `GT_IDLE ;
    end
    else
    begin
        case (gt_state)
            `GT_IDLE : begin
                if (start_gt)
                    gt_state <= `GEN_B ;
                else
                    gt_state <= `GT_IDLE ;
            end
            `GEN_B : begin
                cmpb <= opb - opa ;
                gt_state <= `GEN_C ;
            end
            `GEN_C : begin
                cmpc <= opc - opa ;
                gt_state <= `GEN_D ;
            end
            `GEN_D : begin
                cmpd <= opd - opa ;
                gt_state <= `GT ;
            end
            `GT : begin
                gt <= cmpb[16] & cmpc[16] & cmpd[16] ;
                gt_state <= `GT_DONE ;
            end
            `GT_DONE : begin
                gt_done <= 1 ;
                gt_state <= `GT_CLEAR ;
            end
            `GT_CLEAR : begin
                if (clear_gt)
                begin
                    gt_done <= 0 ;
                    gt_state <= `GT_IDLE ;
                end
                else
                    gt_state <= `GT_CLEAR ;
            end
            default : 	gt_state <= `GT_IDLE ;
        endcase
    end
end

//
// check the twist between the frequencies,
// constrain to +/- 12dB for the now...
//

reg [16:0]
    cmpf,
    cmpr ;

always @(posedge reset or posedge clk)
begin : check_twist
    if (reset)
    begin
        cmpf 	<= 0 ;
        cmpr 	<= 0 ;
        ok 		<= 0 ;
        ct_done	<= 0 ;
        ct_state  <= `CT_IDLE ;
    end
    else
    begin
        case (ct_state)
            `CT_IDLE : begin
                if (start_ct)
                    ct_state <= `GEN_F ;
                else
                    ct_state <= `GT_IDLE ;
            end
            `GEN_F : begin
                cmpf <= opa - opb ;
                ct_state <= `GEN_R ;
            end
            `GEN_R : begin
                if (cmpf[16])   // high freq is larger
                begin
                    cmpf <= opa - {2'b0, opb[15:2]} ;
                    cmpr <= opb - opa ;
                    ct_state <= `CT ;
                end
                else            // low freq is larger
                begin
                    cmpf <= opb - {2'b0, opa[15:2]} ;
                    cmpr <= opa - opb ;
                    ct_state <= `CT ;
                end
            end
            `CT : begin
                ok <= (~cmpf[16]) && (~cmpr[16]) ;
                ct_state <= `CT_DONE ;
            end
            `CT_DONE : begin
                ct_done <= 1 ;
                ct_state <= `CT_CLEAR ;
            end
            `CT_CLEAR : begin
                if (clear_ct)
                begin
                    ct_done <= 0 ;
                    ct_state <= `CT_IDLE ;
                end
                else
                    ct_state <= `CT_CLEAR ;
            end
            default :	ct_state <= `CT_IDLE ;
        endcase
    end
end

endmodule // results_conv
