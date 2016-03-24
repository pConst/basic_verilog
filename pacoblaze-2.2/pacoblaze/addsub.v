
`define WIDTH 16

/* Two half adders to create a full one */
module addsub1(
	op, oc, y, a, b, c_in,
	c_out, h_out
);

input op, oc; // 0: add, 1: sub
output [`WIDTH-1:0] y;
input [`WIDTH-1:0] a, b;
input c_in;
output c_out;
output h_out;

wire [`WIDTH/2-1:0] yh, yl;

wire [`WIDTH/2-1:0]
	ah = a[`WIDTH-1:`WIDTH/2], al = a[`WIDTH/2-1:0];
wire [`WIDTH/2-1:0] bh, bl;
wire c =
	(!oc) ? 0 :
	(op) ? ~c_in : c_in;
wire d, e;

assign bh = (op) ? ~b[`WIDTH-1:`WIDTH/2] : b[`WIDTH-1:`WIDTH/2];
assign bl = (op) ? ~b[`WIDTH/2-1:0] : b[`WIDTH/2-1:0];

assign {d, yl} = al + bl + c;
assign {e, yh} = ah + bh + d;

assign h_out = (op) ? ~d : d;
assign c_out = (op) ? ~e : e;

assign y = {yh, yl};

endmodule

/*
=========================================================================
*                           HDL Synthesis                               *
=========================================================================

Synthesizing Unit <addsub1>.
    Related source file is "C:/src/pacoblaze/pacoblaze/addsub.v".
    Found 8-bit adder carry in/out for signal <$n0001>.
    Found 8-bit adder carry in/out for signal <$n0002>.
    Found 1-bit 4-to-1 multiplexer for signal <c>.
    Summary:
	inferred   2 Adder/Subtractor(s).
	inferred   1 Multiplexer(s).
Unit <addsub1> synthesized.


=========================================================================
HDL Synthesis Report

Macro Statistics
# Adders/Subtractors                                   : 2
 8-bit adder carry in/out                              : 2
# Multiplexers                                         : 1
 1-bit 4-to-1 multiplexer                              : 1

=========================================================================

=========================================================================
*                       Advanced HDL Synthesis                          *
=========================================================================


=========================================================================
Advanced HDL Synthesis Report

Macro Statistics
# Adders/Subtractors                                   : 2
 8-bit adder carry in/out                              : 2
# Multiplexers                                         : 1
 1-bit 4-to-1 multiplexer                              : 1

=========================================================================

=========================================================================
*                         Low Level Synthesis                           *
=========================================================================
Loading device for application Rf_Device from file '3s200.nph' in environment C:\Xilinx.

Optimizing unit <addsub1> ...

Mapping all equations...
Building and optimizing final netlist ...
Found area constraint ratio of 100 (+ 5) on block addsub1, actual ratio is 0.

=========================================================================
*                            Final Report                               *
=========================================================================
Final Results
RTL Top Level Output File Name     : addsub1.ngr
Top Level Output File Name         : addsub1
Output Format                      : NGC
Optimization Goal                  : Speed
Keep Hierarchy                     : NO

Design Statistics
# IOs                              : 53

Cell Usage :
# BELS                             : 67
#      LUT2                        : 34
#      LUT3                        : 1
#      MUXCY                       : 16
#      XORCY                       : 16
# IO Buffers                       : 53
#      IBUF                        : 35
#      OBUF                        : 18
=========================================================================

Device utilization summary:
---------------------------

Selected Device : 3s200pq208-5

 Number of Slices:                      19  out of   1920     0%
 Number of 4 input LUTs:                35  out of   3840     0%
 Number of bonded IOBs:                 53  out of    141    37%


=========================================================================
TIMING REPORT

NOTE: THESE TIMING NUMBERS ARE ONLY A SYNTHESIS ESTIMATE.
      FOR ACCURATE TIMING INFORMATION PLEASE REFER TO THE TRACE REPORT
      GENERATED AFTER PLACE-and-ROUTE.

Clock Information:
------------------
No clock signals found in this design

Timing Summary:
---------------
Speed Grade: -5

   Minimum period: No path found
   Minimum input arrival time before clock: No path found
   Maximum output required time after clock: No path found
   Maximum combinational path delay: 12.573ns

Timing Detail:
--------------
All values displayed in nanoseconds (ns)

=========================================================================
Timing constraint: Default path analysis
  Total number of paths / destination ports: 824 / 18
-------------------------------------------------------------------------
Delay:               12.573ns (Levels of Logic = 21)
  Source:            op (PAD)
  Destination:       c_out (PAD)

  Data Path: op to c_out
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     IBUF:I->O            19   0.715   1.403  op_IBUF (op_IBUF)
     LUT2:I1->O            1   0.479   0.976  bl<0>1 (bl<0>)
     LUT2:I0->O            1   0.479   0.000  addsub1_yl<0>lut (N4)
     MUXCY:S->O            1   0.435   0.000  addsub1_yl<0>cy (addsub1_yl<0>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yl<1>cy (addsub1_yl<1>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yl<2>cy (addsub1_yl<2>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yl<3>cy (addsub1_yl<3>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yl<4>cy (addsub1_yl<4>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yl<5>cy (addsub1_yl<5>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yl<6>cy (addsub1_yl<6>_cyo)
     MUXCY:CI->O           2   0.056   0.000  addsub1_yl<7>cy (d)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yh<0>cy (addsub1_yh<0>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yh<1>cy (addsub1_yh<1>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yh<2>cy (addsub1_yh<2>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yh<3>cy (addsub1_yh<3>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yh<4>cy (addsub1_yh<4>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yh<5>cy (addsub1_yh<5>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub1_yh<6>cy (addsub1_yh<6>_cyo)
     MUXCY:CI->O           1   0.265   0.976  addsub1_yh<7>cy (e)
     LUT2:I0->O            1   0.479   0.681  c_out1 (c_out_OBUF)
     OBUF:I->O                 4.909          c_out_OBUF (c_out)
    ----------------------------------------
    Total                     12.573ns (8.538ns logic, 4.035ns route)
                                       (67.9% logic, 32.1% route)
*/


/* Two separate adders */
module addsub2(
	op, oc, y, yl, a, b, c_in,
	c_out, h_out
);

input op, oc; // 0: add, 1: sub
output [`WIDTH-1:0] y;
input [`WIDTH-1:0] a, b;
input c_in;
output c_out;
output h_out;

output [`WIDTH/2-1:0] yl;

wire [`WIDTH/2-1:0]
	al = a[`WIDTH/2-1:0];
wire [`WIDTH-1:0] bs;
wire [`WIDTH/2-1:0] bl;
wire c =
	(!oc) ? 0 :
	(op) ? ~c_in : c_in;
wire d, e;

assign bl = (op) ? ~b[`WIDTH/2-1:0] : b[`WIDTH/2-1:0];
assign bs = (op) ? ~b : b;

assign {d, yl} = al + bl + c;
assign {e, y} = a + bs + c;

assign h_out = (op) ? ~d : d;
assign c_out = (op) ? ~e : e;

endmodule


/*
=========================================================================
*                           HDL Synthesis                               *
=========================================================================

Synthesizing Unit <addsub2>.
    Related source file is "C:/src/pacoblaze/pacoblaze/addsub.v".
    Found 16-bit adder carry in/out for signal <$n0001>.
    Found 8-bit adder carry in/out for signal <$n0002>.
    Found 1-bit 4-to-1 multiplexer for signal <c>.
    Summary:
	inferred   2 Adder/Subtractor(s).
	inferred   1 Multiplexer(s).
Unit <addsub2> synthesized.


=========================================================================
HDL Synthesis Report

Macro Statistics
# Adders/Subtractors                                   : 2
 16-bit adder carry in/out                             : 1
 8-bit adder carry in/out                              : 1
# Multiplexers                                         : 1
 1-bit 4-to-1 multiplexer                              : 1

=========================================================================

=========================================================================
*                       Advanced HDL Synthesis                          *
=========================================================================


=========================================================================
Advanced HDL Synthesis Report

Macro Statistics
# Adders/Subtractors                                   : 2
 16-bit adder carry in/out                             : 1
 8-bit adder carry in/out                              : 1
# Multiplexers                                         : 1
 1-bit 4-to-1 multiplexer                              : 1

=========================================================================

=========================================================================
*                         Low Level Synthesis                           *
=========================================================================
Loading device for application Rf_Device from file '3s200.nph' in environment C:\Xilinx.

Optimizing unit <addsub2> ...

Mapping all equations...
Building and optimizing final netlist ...
Found area constraint ratio of 100 (+ 5) on block addsub2, actual ratio is 1.

=========================================================================
*                            Final Report                               *
=========================================================================
Final Results
RTL Top Level Output File Name     : addsub2.ngr
Top Level Output File Name         : addsub2
Output Format                      : NGC
Optimization Goal                  : Speed
Keep Hierarchy                     : NO

Design Statistics
# IOs                              : 61

Cell Usage :
# BELS                             : 91
#      LUT2                        : 34
#      LUT3                        : 9
#      MUXCY                       : 24
#      XORCY                       : 24
# IO Buffers                       : 61
#      IBUF                        : 35
#      OBUF                        : 26
=========================================================================

Device utilization summary:
---------------------------

Selected Device : 3s200pq208-5

 Number of Slices:                      23  out of   1920     1%
 Number of 4 input LUTs:                43  out of   3840     1%
 Number of bonded IOBs:                 61  out of    141    43%


=========================================================================
TIMING REPORT

NOTE: THESE TIMING NUMBERS ARE ONLY A SYNTHESIS ESTIMATE.
      FOR ACCURATE TIMING INFORMATION PLEASE REFER TO THE TRACE REPORT
      GENERATED AFTER PLACE-and-ROUTE.

Clock Information:
------------------
No clock signals found in this design

Timing Summary:
---------------
Speed Grade: -5

   Minimum period: No path found
   Minimum input arrival time before clock: No path found
   Maximum output required time after clock: No path found
   Maximum combinational path delay: 12.955ns

Timing Detail:
--------------
All values displayed in nanoseconds (ns)

=========================================================================
Timing constraint: Default path analysis
  Total number of paths / destination ports: 1012 / 26
-------------------------------------------------------------------------
Delay:               12.955ns (Levels of Logic = 21)
  Source:            op (PAD)
  Destination:       c_out (PAD)

  Data Path: op to c_out
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     IBUF:I->O            27   0.715   1.721  op_IBUF (op_IBUF)
     LUT2:I1->O            2   0.479   1.040  bs<0>1 (bs<0>)
     LUT2:I0->O            1   0.479   0.000  addsub2_y<0>lut (N4)
     MUXCY:S->O            1   0.435   0.000  addsub2_y<0>cy (addsub2_y<0>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<1>cy (addsub2_y<1>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<2>cy (addsub2_y<2>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<3>cy (addsub2_y<3>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<4>cy (addsub2_y<4>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<5>cy (addsub2_y<5>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<6>cy (addsub2_y<6>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<7>cy (addsub2_y<7>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<8>cy (addsub2_y<8>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<9>cy (addsub2_y<9>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<10>cy (addsub2_y<10>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<11>cy (addsub2_y<11>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<12>cy (addsub2_y<12>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<13>cy (addsub2_y<13>_cyo)
     MUXCY:CI->O           1   0.056   0.000  addsub2_y<14>cy (addsub2_y<14>_cyo)
     MUXCY:CI->O           1   0.265   0.976  addsub2_y<15>cy (e)
     LUT2:I0->O            1   0.479   0.681  c_out1 (c_out_OBUF)
     OBUF:I->O                 4.909          c_out_OBUF (c_out)
    ----------------------------------------
    Total                     12.955ns (8.538ns logic, 4.418ns route)
                                       (65.9% logic, 34.1% route)
*/