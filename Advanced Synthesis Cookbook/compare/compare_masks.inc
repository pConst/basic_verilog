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

function [15:0] dcb_less_const_mask;
	input [2:0] const_val;
	integer n;
	begin
		for (n=0; n<16; n=n+1)
		begin
			// (n >> 1)	because the LSB A is unused
			dcb_less_const_mask[n] = ((n>>1) < const_val) ? 1 : 0;
		end
	end
endfunction

function [15:0] dcb_eq_const_mask;
	input [2:0] const_val;
	integer n;
	begin
		for (n=0; n<16; n=n+1)
		begin
			// (n >> 1)	because the LSB A is unused
			dcb_eq_const_mask[n] = ((n>>1) == const_val) ? 1 : 0;
		end
	end
endfunction

function [15:0] dc_eq_const_mask;
	input [1:0] const_val;
	integer n;
	begin
		for (n=0; n<16; n=n+1)
		begin
			// (n >> 2)	because the LSB A,B both unused
			dc_eq_const_mask[n] = ((n>>2) == const_val) ? 1 : 0;
		end
	end
endfunction

function [15:0] dc_greater_const_mask;
	input [1:0] const_val;
	integer n;
	begin
		for (n=0; n<16; n=n+1)
		begin
			// (n >> 2)	because the LSB A,B both unused
			dc_greater_const_mask[n] = ((n>>2) > const_val) ? 1 : 0;
		end
	end
endfunction

function [15:0] dc_ge_const_mask;
	input [1:0] const_val;
	integer n;
	begin
		for (n=0; n<16; n=n+1)
		begin
			// (n >> 2)	because the LSB A,B both unused
			dc_ge_const_mask[n] = ((n>>2) >= const_val) ? 1 : 0;
		end
	end
endfunction

function [15:0] dc_less_const_mask;
	input [1:0] const_val;
	integer n;
	begin
		for (n=0; n<16; n=n+1)
		begin
			// (n >> 2)	because the LSB A,B both unused
			dc_less_const_mask[n] = ((n>>2) < const_val) ? 1 : 0;
		end
	end
endfunction
