//--------------------------------------------------------------------------------
// SimplePulseGen.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// ”прощенный генератор, 
// импульс одноразовый, однотактный

module SimplePulseGen(clk,nrst,low_wdth,start,busy,out);

input wire clk;
input wire nrst;

input wire [31:0] low_wdth;

input wire start;
output reg busy = 0;
output reg out = 0;

reg [31:0] max_low = 0;
reg [31:0] cnt_low = 0;

always @ (posedge clk) begin
	if (~nrst) begin   // one and only way to stop SimplePulseGen is to reset it
	   max_low[31:0] <= 0;
	   cnt_low[31:0] <= 0;
	   busy <= 0;
       out <= 0;
	end
	else begin  // nrst
		if (~busy) begin
                if (start) begin  // buffering input values
                      max_low[31:0] <= low_wdth[31:0];
                      cnt_low[31:0] <= 0;                  
                      busy <= 1;
                end
		end
		else begin
              if (cnt_low[31:0] < (max_low[31:0]-1)) begin    // compensation for firs initialization cycle
                  out <= 0;
                  cnt_low[31:0] <= cnt_low[31:0] + 1;
              end
              else begin
                  if (~out) begin
                      out <= 1;
                  end
                  else begin
                      busy <= 0;
                      out <= 0;
                  end    // out
              end     // cnt_low
		end   // busy
	end    // nrst
end

endmodule