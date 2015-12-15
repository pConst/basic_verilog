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

module compare_tb ();

parameter WIDTH = 64;
parameter CONST_X = 64'h123456781234567a;

wire a,b,c,d,e;
reg [WIDTH-1:0] dat;
reg fail;

less_than_const ca (.dat(dat),.out(a));
	defparam ca .WIDTH = WIDTH;
	defparam ca .METHOD = 0;
	defparam ca .CONST_VAL = CONST_X;
less_than_const cb (.dat(dat),.out(b));
	defparam cb .WIDTH = WIDTH;
	defparam cb .METHOD = 1;
	defparam cb .CONST_VAL = CONST_X;
less_than_const cc (.dat(dat),.out(c));
	defparam cc .WIDTH = WIDTH;
	defparam cc .METHOD = 2;
	defparam cc .CONST_VAL = CONST_X;
less_than_const cd (.dat(dat),.out(d));
	defparam cd .WIDTH = WIDTH;
	defparam cd .METHOD = 3;
	defparam cd .CONST_VAL = CONST_X;
less_than_const ce (.dat(dat),.out(e));
	defparam ce .WIDTH = WIDTH;
	defparam ce .METHOD = 4;
	defparam ce .CONST_VAL = CONST_X;

parameter WIDTH_2 = 9;
parameter CONST_Y = 9'b100101010;

wire q,r,s,t,u;
reg [WIDTH_2-1:0] dat_2;

less_than_const da (.dat(dat_2),.out(q));
	defparam da .WIDTH = WIDTH_2;
	defparam da .METHOD = 0;
	defparam da .CONST_VAL = CONST_Y;
less_than_const db (.dat(dat_2),.out(r));
	defparam db .WIDTH = WIDTH_2;
	defparam db .METHOD = 1;
	defparam db .CONST_VAL = CONST_Y;
less_than_const dc (.dat(dat_2),.out(s));
	defparam dc .WIDTH = WIDTH_2;
	defparam dc .METHOD = 2;
	defparam dc .CONST_VAL = CONST_Y;
less_than_const dd (.dat(dat_2),.out(t));
	defparam dd .WIDTH = WIDTH_2;
	defparam dd .METHOD = 3;
	defparam dd .CONST_VAL = CONST_Y;
less_than_const de (.dat(dat_2),.out(u));
	defparam de .WIDTH = WIDTH_2;
	defparam de .METHOD = 4;
	defparam de .CONST_VAL = CONST_Y;

reg over;
wire w,x,y,z;
parameter UPPER = 9'b011001001;
parameter LOWER = 9'b000010010;

over_under oa (.dat(dat_2),.over(over),.out(w));
	defparam oa .WIDTH = WIDTH_2;
	defparam oa .METHOD = 0;
	defparam oa .UPPER_BOUND = UPPER;
	defparam oa .LOWER_BOUND = LOWER;
over_under ob (.dat(dat_2),.over(over),.out(x));
	defparam ob .WIDTH = WIDTH_2;
	defparam ob .METHOD = 1;
	defparam ob .UPPER_BOUND = UPPER;
	defparam ob .LOWER_BOUND = LOWER;
over_under oc (.dat(dat_2),.over(over),.out(y));
	defparam oc .WIDTH = WIDTH_2;
	defparam oc .METHOD = 2;
	defparam oc .UPPER_BOUND = UPPER;
	defparam oc .LOWER_BOUND = LOWER;
over_under od (.dat(dat_2),.over(over),.out(z));
	defparam od .WIDTH = WIDTH_2;
	defparam od .METHOD = 3;
	defparam od .UPPER_BOUND = UPPER;
	defparam od .LOWER_BOUND = LOWER;

wire ww,xx,yy,zz;

parameter UPPER_3 = 8'b11001001;
parameter LOWER_3 = 8'b00010010;

over_under pa (.dat(dat_2),.over(over),.out(ww));
	defparam pa .WIDTH = WIDTH_2-1;
	defparam pa .METHOD = 0;
	defparam pa .UPPER_BOUND = UPPER_3;
	defparam pa .LOWER_BOUND = LOWER_3;
over_under pb (.dat(dat_2),.over(over),.out(xx));
	defparam pb .WIDTH = WIDTH_2-1;
	defparam pb .METHOD = 1;
	defparam pb .UPPER_BOUND = UPPER_3;
	defparam pb .LOWER_BOUND = LOWER_3;
over_under pc (.dat(dat_2),.over(over),.out(yy));
	defparam pc .WIDTH = WIDTH_2-1;
	defparam pc .METHOD = 2;
	defparam pc .UPPER_BOUND = UPPER_3;
	defparam pc .LOWER_BOUND = LOWER_3;
over_under pd (.dat(dat_2),.over(over),.out(zz));
	defparam pd .WIDTH = WIDTH_2-1;
	defparam pd .METHOD = 3;
	defparam pd .UPPER_BOUND = UPPER_3;
	defparam pd .LOWER_BOUND = LOWER_3;


initial begin
	dat = 0;
	dat_2 = 0;
	over = 0;
	fail = 0;

	#100000 if (!fail) $display ("PASS");
	$stop();
end

always begin
  #50 dat = {$random,$random};
		dat_2 = $random;
		over = $random;

  #50 if  (a !== b || a !== c || a !== d || a!= e) begin
		$display ("Mismatch in cx series at time %d",$time);
		fail = 1;
	end

	if  (q !== r || q !== s || q !== t || q != u) begin
		$display ("Mismatch in dx series at time %d",$time);
		fail = 1;
	end

	if  (w !== x || w !== y || w !== z) begin
		$display ("Mismatch in ox series at time %d",$time);
		fail = 1;
	end

	if  (ww !== xx || ww !== yy || ww !== zz) begin
		$display ("Mismatch in px series at time %d",$time);
		fail = 1;
	end

end

endmodule