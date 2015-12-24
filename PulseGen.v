//--------------------------------------------------------------------------------
// PulseGen.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Генератор импульса
//  Работает начиная с low_wdth = 1, high_wdth = 1

module PulseGen(clk,nrst,low_wdth,high_wdth,rpt,start,busy,out);

input wire clk;
input wire nrst;

input wire [31:0] low_wdth;
input wire [31:0] high_wdth;
input wire rpt;

input wire start;	// Only first front matters
output reg busy = 0;
output reg out = 0;

reg rpt_buf = 0;
reg [31:0] max_low = 0;
reg [31:0] max_high = 0;
reg [31:0] cnt_low = 0;
reg [31:0] cnt_high = 0;

always @ (posedge clk) begin
	if (~nrst) begin   // one and only way to stop PulseGen is to reset it
	   rpt_buf <= 0;
	   max_low[31:0] <= 0;
	   max_high[31:0] <= 0;
	   cnt_low[31:0] <= 0;
	   cnt_high[31:0] <= 0;
	   busy <= 0;
       out <= 0;
	end
	else begin  // nrst
		if (~busy) begin
			if (start) begin  // buffering input values
				  busy <= 1;				  
				  
				  rpt_buf <= rpt;
				  max_low[31:0] <= low_wdth[31:0];
				  max_high[31:0] <= high_wdth[31:0];
				  cnt_low[31:0] <= 0;
				  cnt_high[31:0] <= 0;
			end
		end
		else begin
		      if (cnt_low[31:0] < (max_low[31:0]-1)) begin    // compensation for firs initialization cycle
		          out <= 0;
		          cnt_low[31:0] <= cnt_low[31:0] + 1;
		      end
		      else begin
                  out <= 1;
                  if (cnt_high[31:0] < max_high[31:0]) begin
                      cnt_high[31:0] <= cnt_high[31:0] + 1;
                  end
                  else begin                   
                       out <= 0;                     
					  if (rpt_buf) begin
                            cnt_low[31:0] <= 0;
                            cnt_high[31:0] <= 0;
                      end
                      else begin
                            busy <= 0;	// end of sequence
                      end
                  end   // cnt_high
		      end     // cnt_low
		end   // busy
	end    // nrst
end

endmodule