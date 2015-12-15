// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// baeckler - 2-16-2007

module des_tb ();

reg [63:0] plain;
reg [63:0] key;
reg [63:0] exp_c;
wire [63:0] actual_c;
wire [63:0] rebuilt_plain;

reg clk,rst,bug;

parameter PIPE_16A = 1'b0;
parameter PIPE_16B = 1'b0;
parameter PIPE_8A = 1'b0;
parameter PIPE_8B = 1'b0;

des d (.clk(clk),.rst(rst),.in(plain),.key(key),.out(actual_c),.salt(12'b0));

des u (.clk(clk),.rst(rst),.in(actual_c),.key(key),.out(rebuilt_plain),.salt(12'b0));
defparam u .DECRYPT = 1'b1;

defparam u .PIPE_16A = PIPE_16A;
defparam u .PIPE_16B = PIPE_16B;
defparam u .PIPE_8A = PIPE_8A;
defparam u .PIPE_8B = PIPE_8B;

defparam d .PIPE_16A = PIPE_16A;
defparam d .PIPE_16B = PIPE_16B;
defparam d .PIPE_8A = PIPE_8A;
defparam d .PIPE_8B = PIPE_8B;

initial begin
   clk = 0;
   rst = 0;
   bug = 0;
   #10 rst = 1;
   #10 rst = 0;
end

reg [191:0] stim [39:0];
initial begin
	//				key					plain				cipher
    stim[0] = 192'h0000000000000000_0000000000000000_8ca64de9c1b123a7;
    stim[1] = 192'he5c48d8397b26531_8ca64de9c1b123a7_5cf505a4e1feec12;
    stim[2] = 192'he5c48d8397b26531_5cf505a4e1feec12_b0140f4c955c0adc;
    stim[3] = 192'he5c48d8397b26531_b0140f4c955c0adc_003fe788c88e223a;
    stim[4] = 192'hb980fc9086559931_003fe788c88e223a_be69636adef9c2dd;
    stim[5] = 192'hb980fc9086559931_be69636adef9c2dd_ac7ac30637670dc7;
    stim[6] = 192'hb980fc9086559931_ac7ac30637670dc7_a6b9c8d6ff934423;
    stim[7] = 192'h7da2356fed460454_a6b9c8d6ff934423_492cd4a0e11a08f0;
    stim[8] = 192'h7da2356fed460454_492cd4a0e11a08f0_07c30a13c852f6e0;
    stim[9] = 192'h7da2356fed460454_07c30a13c852f6e0_e3349cc34acf4490;
    stim[10] = 192'h7480c63d2e7f2893_e3349cc34acf4490_25df12f428cd5994;
    stim[11] = 192'h7480c63d2e7f2893_25df12f428cd5994_44abaa7759807712;
    stim[12] = 192'h7480c63d2e7f2893_44abaa7759807712_9c7c42965dda2c27;
    stim[13] = 192'h90b49d87473d16aa_9c7c42965dda2c27_c7b1cfbb4e70afff;
    stim[14] = 192'h90b49d87473d16aa_c7b1cfbb4e70afff_2958b501302b8845;
    stim[15] = 192'h90b49d87473d16aa_2958b501302b8845_9101279b3aa464b4;
    stim[16] = 192'hbd92b8db9ed99623_9101279b3aa464b4_42b33eb2940e6b8f;
    stim[17] = 192'hbd92b8db9ed99623_42b33eb2940e6b8f_6e9c5d771eb4f448;
    stim[18] = 192'hbd92b8db9ed99623_6e9c5d771eb4f448_2c21562ec8bd8fc1;
    stim[19] = 192'h3e6305c8eab31217_2c21562ec8bd8fc1_c5da5fd4729055e6;
    stim[20] = 192'h3e6305c8eab31217_c5da5fd4729055e6_9977cf9c63ddb72b;
    stim[21] = 192'h3e6305c8eab31217_9977cf9c63ddb72b_e357a4f2642fc4fe;
    stim[22] = 192'h4140f1eea596f8d0_e357a4f2642fc4fe_5de11b8cb4289c39;
    stim[23] = 192'h4140f1eea596f8d0_5de11b8cb4289c39_4fe00b7bef6c08c8;
    stim[24] = 192'h4140f1eea596f8d0_4fe00b7bef6c08c8_7bc3b98550c2d375;
    stim[25] = 192'hef8bb2e4040b3b0e_7bc3b98550c2d375_a0046f2b0436098b;
    stim[26] = 192'hef8bb2e4040b3b0e_a0046f2b0436098b_3d54554d4a1e327c;
    stim[27] = 192'hef8bb2e4040b3b0e_3d54554d4a1e327c_65a266fe826dcce0;
    stim[28] = 192'he8b804a57b6d7ea8_65a266fe826dcce0_8d9bab910ea34e75;
    stim[29] = 192'he8b804a57b6d7ea8_8d9bab910ea34e75_35b55a6e6166b837;
    stim[30] = 192'he8b804a57b6d7ea8_35b55a6e6166b837_0f2cb27cfd7286b2;
    stim[31] = 192'ha5d94a1a45204a58_0f2cb27cfd7286b2_b3883906d3da3403;
    stim[32] = 192'ha5d94a1a45204a58_b3883906d3da3403_3332c4309364baf2;
    stim[33] = 192'ha5d94a1a45204a58_3332c4309364baf2_41bae5a84229919c;
    stim[34] = 192'h9c50de58508717da_41bae5a84229919c_cc6c11ec82b3b8b9;
    stim[35] = 192'h9c50de58508717da_cc6c11ec82b3b8b9_f7d3b864729b0ed4;
    stim[36] = 192'h9c50de58508717da_f7d3b864729b0ed4_8b25b86cd5c7ace2;
    stim[37] = 192'hdb653df3669ab30b_8b25b86cd5c7ace2_fe39696a27761ab6;
    stim[38] = 192'hdb653df3669ab30b_fe39696a27761ab6_ff3c1fe1f2cf3a9a;
    stim[39] = 192'hdb653df3669ab30b_ff3c1fe1f2cf3a9a_e6676daf0ef6b2ed;
end

reg [7:0] stim_index;
initial stim_index = 0;

integer i;
reg [7:0] latency;
initial latency = (PIPE_16A | PIPE_16B) ? 16 : ((PIPE_8A | PIPE_8B) ? 8 : 0);

reg stage_b;
initial stage_b = 1'b0;
always begin
 #100
 if (!stage_b) begin
   if (stim_index == 40) begin
      if (!bug) $display ("DES pass");
      else $display ("DES mismatch");
      stage_b = 1'b1;
   end
   #100
   {key,plain,exp_c} = stim[stim_index];
   clk = 1'b0;
   for (i=0; i<latency; i=i+1) begin : ticks_a
     #100 clk = 1'b1;
     #100 clk = 1'b0;
   end
   #100
   if (actual_c != exp_c) begin
      $display ("Encrypt not as expected");
      bug = 1'b1;
   end
   for (i=0; i<latency; i=i+1) begin : ticks_b
     #100 clk = 1'b1;
     #100 clk = 1'b0;
   end
   if (rebuilt_plain != plain) begin
      $display ("Decrypt not as expected");
      bug = 1'b1;
   end
   #100
   stim_index = stim_index + 1;
  end
end

wire [87:0] pout, pout2;
passwd_crypt pc (.clk(clk),.rst(rst),.salt("A3"),.pass("foobar12"),.out(pout),.super_round(),.des_round());
passwd_crypt pc2 (.clk(clk),.rst(rst),.salt("bz"),.pass({"apple",24'b0}),.out(pout2),.super_round(),.des_round());
always begin
#100
	if (stage_b) begin
		rst = 1'b1;
		#100 rst = 1'b0; clk = 1'b0;
		for (i=0; i<16*25; i=i+1) begin : ticks_pw
			 #100 clk = 1'b1;
			 #100 clk = 1'b0;
		end
        if (pout != "LvH7gb4dV5Y") begin
          $display ("passwd FAIL");
		  bug = 1'b1;
        end else $display ("passwd pass");
        if (pout2 != "UII.9RxX.0g") begin
          $display ("passwd2 FAIL");
          bug = 1'b1;
        end else $display ("passwd2 pass");
		#100 
		if (!bug) $display ("PASS");
		else $display ("Mismatch in DES behavior - test failed");
		$stop();
	end
end
endmodule

