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

// baeckler - 07-10-2006
//   revd 08-25-2006

module ecc_16bit_tb ();

// this should be the sum of encode and 
// decode registers
parameter TOTAL_LATENCY = 2;

parameter DATA_BITS = 16;
parameter TOTAL_BITS = 22;

reg [DATA_BITS-1:0] data_in,next_data_in;
wire [TOTAL_BITS-1:0] code_out;
reg [TOTAL_BITS-1:0] error_sig,next_error_sig;
wire [TOTAL_BITS-1:0] damaged_code;
wire [DATA_BITS-1:0] recovered_data;
wire no_err,err_corrected,err_fatal;

reg clk,rst;

///////////////////////
// encoder unit
///////////////////////
ecc_encode_16bit enc
(
	.d(data_in),
	.c(code_out)
);

///////////////////////
// insert optional error 
///////////////////////
reg [2:0] num_errors, next_num_errors;
assign damaged_code = code_out ^ error_sig;

///////////////////////
// decoder unit 
///////////////////////
ecc_decode_16bit dec 
(
	.clk(clk),
	.rst(rst),
	.c(damaged_code),
	.d(recovered_data),
	.no_err(no_err),
	.err_corrected(err_corrected),
	.err_fatal(err_fatal)
);
defparam dec .MIDDLE_REG = 1;
defparam dec .OUTPUT_REG = 1;


////////////////////////
// main control 
////////////////////////
reg fail;
reg [TOTAL_LATENCY:0] flushing;

initial begin
	clk = 0;
	rst = 0;
	num_errors = 0;
	error_sig = 0;
	data_in = 0;
	fail = 0;

	#10 rst = 1;
	#10 rst = 0;

	// wait for the pipe to fill
	#10
	if (!flushing[TOTAL_LATENCY]) begin
		@(posedge flushing[TOTAL_LATENCY]);
	end
	fail = 0;

	#10000000 if (!fail) $display ("PASS"); 
	else $display ("FAIL");
	$stop();
end

integer n = 0;
reg [6:0] which_bit;

////////////////////////
// new random stimulus
////////////////////////
always @(negedge clk or posedge rst) begin
	next_data_in = {$random,$random};
	
	// create an error signal with a few randomly
	// placed 1's.
	next_num_errors = $random;
	next_num_errors = next_num_errors % 5;

	next_error_sig = 0;
	for (n=0; n<next_num_errors; n=n+1)
	begin
		which_bit = $random;
		which_bit = which_bit % TOTAL_BITS;
		while (next_error_sig[which_bit]) 
		begin
			which_bit = (which_bit + 1) % TOTAL_BITS;	
		end
		next_error_sig[which_bit] = 1'b1;
	end
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
		num_errors <= 0;
		error_sig <= 0;
		data_in <= 0;
	end
	else begin
		num_errors <= next_num_errors;
		data_in <= next_data_in;
		error_sig <= next_error_sig;
	end
end

///////////////////////
// latency matching 
///////////////////////
reg [DATA_BITS-1:0] delayed_data [TOTAL_LATENCY:0];
reg [2:0] delayed_num_errors [TOTAL_LATENCY:0];
integer i ;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		flushing <= 1'b1;
	end
	else begin
		flushing <= flushing | (flushing << 1'b1);
		for (i=TOTAL_LATENCY; i>0; i=i-1) begin
			delayed_data[i] <= delayed_data[i-1];
			delayed_num_errors[i] <= delayed_num_errors[i-1];
		end
	end
end

always @(*) begin
	delayed_num_errors[0] = num_errors;
	delayed_data[0] = data_in;
end

///////////////////////////////
// capture and check results 
///////////////////////////////

integer wrong_bits = 0;
reg [DATA_BITS-1:0] recovered_error;

integer stats_3bit_pass = 0;
integer stats_3bit_one = 0;
integer stats_3bit_two = 0;

integer stats_4bit_pass = 0;
integer stats_4bit_one = 0;
integer stats_4bit_two = 0;

integer z;

always @(posedge clk or posedge rst) begin
	#20
		
	// count the number of wrong bits in the 
	// recovered data.
	wrong_bits = 0;
	recovered_error = delayed_data[TOTAL_LATENCY] ^ recovered_data;
	for (z=0;z<64;z=z+1)
	begin
		if (recovered_error[z]) wrong_bits = wrong_bits + 1;
	end

	#1
			
	if (delayed_num_errors[TOTAL_LATENCY] == 0) begin
		if (wrong_bits !== 0) fail = 1;
		if ({no_err,err_corrected,err_fatal} !== 3'b100) fail = 1;
	end
	else if (delayed_num_errors[TOTAL_LATENCY] == 1) begin
		// 1 bit errors need to be flagged and repaired
		if (wrong_bits !== 0) fail = 1;
		if ({no_err,err_corrected,err_fatal} !== 3'b010) fail = 1;
	end
	else if (delayed_num_errors[TOTAL_LATENCY] == 2) begin
		// 2 bit errors need to be detected
		// and not made any worse
		if (wrong_bits > 2) fail = 1;
		if ({no_err,err_corrected,err_fatal} !== 3'b001) fail = 1;
	end	
	else if (delayed_num_errors[TOTAL_LATENCY] == 3) begin
		// 3 bit errors need to be detected as parity error
		// they will be mistakenly corrected as 1 bit errors
		if ({no_err,err_corrected,err_fatal} == 3'b100) 
			stats_3bit_pass = stats_3bit_pass + 1;
		else if ({no_err,err_corrected,err_fatal} == 3'b010) 
			stats_3bit_one = stats_3bit_one + 1;
		else if ({no_err,err_corrected,err_fatal} == 3'b001) 
			stats_3bit_two = stats_3bit_two + 1;				
	end
	else begin
		// 4 + bit errors
		if ({no_err,err_corrected,err_fatal} == 3'b100) 
			stats_4bit_pass = stats_4bit_pass + 1;
		else if ({no_err,err_corrected,err_fatal} == 3'b010) 
			stats_4bit_one = stats_4bit_one + 1;
		else if ({no_err,err_corrected,err_fatal} == 3'b001) 
			stats_4bit_two = stats_4bit_two + 1;				
	end

	// early exit for failure
	if (fail) begin
		#100 $display ("Mismatch at time %d",$time);
		$stop();
	end
end

always begin
	#100 clk = ~clk;
end

endmodule