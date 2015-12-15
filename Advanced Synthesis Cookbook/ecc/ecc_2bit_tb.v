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

// baeckler - 7-20-2006

module ecc_2bit_tb ();

reg [1:0] dat;
wire [5:0] code;
reg [5:0] err;
wire [5:0] damaged_code;
wire [1:0] recovered;
wire [2:0] err_flag;

// encode - corrupt - decode 
ecc_encode_2bit enc (.d(dat), .c(code));
assign damaged_code = code ^ err;
ecc_decode_2bit dec (.c(damaged_code),.d(recovered), .err_flag (err_flag));

integer n,i,j;

initial begin

	// test the four no-error cases
	for (n=0; n<4; n=n+1) begin
		dat = n[1:0];
		err = 0;
		#1
		// you must recover data and flag no-error
		if ((recovered !== dat) || (err_flag !== 3'b001)) begin
			$display ("Mismatch in no-error cases");
			$stop();
		end
	end

	// test the twenty four one-error cases
	for (n=0; n<4; n=n+1) begin
		for (i=0; i<6; i=i+1) begin
			dat = n[1:0];
			err = 1'b1 << i;
			#1
			// you must recover the data and flag correctly
			if ((recovered !== dat) || (err_flag !== 3'b010)) begin
				$display ("Mismatch in one-error cases");
				$stop();
			end
		end
	end

	// test the (144? but overlapping) two-error cases
	for (n=0; n<4; n=n+1) begin
		for (i=0; i<6; i=i+1) begin
			for (j=0; j<6; j=j+1) begin
				if (j != i) begin
					dat = n[1:0];
					err = 1'b1 << i;
					err = err | (1'b1 << j);
					#1
					// you must flag correctly
					if (err_flag !== 3'b100) begin
						$display ("Mismatch in two-error cases");
						$stop();
					end
				end
			end
		end
	end

	#10 $display ("PASS");
	$stop();
end
endmodule
