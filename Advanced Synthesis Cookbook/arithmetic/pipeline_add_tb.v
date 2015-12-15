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

// baeckler - 01-04-2007

module pipeline_add_tb ();
    parameter LS_WIDTH = 15;
    parameter MS_WIDTH = 20;
    parameter WIDTH = LS_WIDTH + MS_WIDTH;

    reg [WIDTH-1:0] a,b;
	reg rst,clk;
    wire [WIDTH-1:0] oa;
	reg first = 1'b1;

	// functional model
	reg [WIDTH-1:0] ob,ob_delay;
    always @(posedge clk or posedge rst) begin
		if (rst) begin
			ob_delay <= 0;
			ob <= 0;
		end 
		else begin
			ob_delay <= ob;
			ob <= a + b; 
		end
	end

	// DUT
    pipeline_add s (.clk(clk),.rst(rst),.a(a),.b(b),.o(oa));
        defparam s .LS_WIDTH = LS_WIDTH;
        defparam s .MS_WIDTH = MS_WIDTH;

	// run the clock and spin A and B data
    always begin
        #100 clk = ~clk;
	end
	always @(negedge clk) begin
		a = {$random,$random};
		b = {$random,$random}; 
	end
	
	// verify - ignore the very first tick while the 
	// pipe clears.
	always @(posedge clk) begin
		#10 if (!first && oa !== ob_delay) begin
           $display ("Mismatch at time %d",$time);
           $stop();
        end
    end

    initial begin
        clk = 0;
		rst = 0;
		#10 rst = 1;
		#10 rst = 0;
		@(posedge clk)
		@(negedge clk) first = 0;

		#1000000 $display ("PASS");
        $stop();
    end
endmodule