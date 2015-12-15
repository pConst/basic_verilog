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

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void panic (char * msg)
{
	fprintf (stdout,"PANIC: %s\n",msg);
	exit(1);
}

int pseudo_log2 (int val)
{
	int ret = 0;
	while (val > 0)
	{
		ret++;
		val >>= 1;
	}
	return (ret);
}

int const MAX_DISPLACE = 15;
int const PERIOD = 64;
int const WORD_LEN = 32;
int const HIST_WORDS = 2*MAX_DISPLACE + 1;
int const NUM_SEL = pseudo_log2 (HIST_WORDS-1);
int const CNTR_BITS = pseudo_log2 (PERIOD-1);

///////////////////////////////////////////////////////////

class SHIFT_REG 
{
public :
	SHIFT_REG(int b)
	{
		depth = b;
		data = new int[depth];
	}
	~SHIFT_REG()
	{
		delete data;
		data = NULL;
	}
	void shift_in (int val);
	void shift_in_reversed (int val);
	int shift_out ();
	void dump ();
	int par_read (int slot);
	void par_write (int slot, int val);
	int index_of_value (int val);

private :
	int * data;
	int depth;
};

void SHIFT_REG::shift_in (int val)
{
	int n = 0;
	for (n=depth-1; n>0; n--)
	{
		data[n] = data[n-1];
	}
	data[0] = val;
}

void SHIFT_REG::shift_in_reversed (int val)
{
	int n = 0;
	for (n=0; n<depth; n++)
	{
		data[n] = data[n+1];
	}
	data[depth-1] = val;
}


int SHIFT_REG::shift_out ()
{
	int n = data[depth-1];
	shift_in(-1);
	return (n);
}

void SHIFT_REG::dump ()
{
	int n = 0;
	for (n=0; n<depth; n++)
	{
		fprintf (stdout,"%3d ",data[n]);
	}
	fprintf (stdout,"\n");
}

int SHIFT_REG::par_read (int slot)
{
	if (slot < 0 || slot >= depth)
	{
		panic ("Read out of range");
	}
	return (data[slot]);
}

void SHIFT_REG::par_write (int slot, int val)
{
	if (slot < 0 || slot >= depth)
	{
		panic ("Read out of range");
	}
	data[slot] = val;
}

int SHIFT_REG::index_of_value (int val)
{
	int n = 0;
	for (n=0; n<depth; n++)
	{
		if (data[n] == val) return (n);
	}
	return (-1);
}

///////////////////////////////////////////////////////////

void build_scrambler 
(
	SHIFT_REG * indices,
	SHIFT_REG * data_stream
)
{
	int n = 0, k = 0;
	int sel_out = 0;
	bool any_late = false;
	int cycle = 0;
	int min_sel = 0;
	SHIFT_REG * shifter = NULL;

	shifter = new SHIFT_REG (2 * MAX_DISPLACE + 1);

	// initialize
	for (n=0;n<MAX_DISPLACE;n++)
	{
		shifter->shift_in (-1);
	}
	for (n=0;n<MAX_DISPLACE+1;n++)
	{
		shifter->shift_in (n);
	}
	//shifter->dump();

	// scramble
	for (n=MAX_DISPLACE+1; n<PERIOD+MAX_DISPLACE+1; n++)
	{
		// force it to recenter at the end of the period
		min_sel = 0;
		if (cycle >= (PERIOD-MAX_DISPLACE))
		{
			min_sel = MAX_DISPLACE+1 - (PERIOD-cycle);  
		}
		
		//fprintf (stdout,"round %d - select >= %d\n",
		//	cycle,min_sel);

		// select anything not -1
		sel_out = 2*MAX_DISPLACE;
		while ((sel_out < min_sel) || (shifter->par_read(sel_out) == -1))
		{
			sel_out = rand() % (2*MAX_DISPLACE);
		}
		    
		//shifter->dump();
		//fprintf (stdout,"// step %d - out[%d] = %d\n",
		//	cycle,sel_out,shifter->par_read(sel_out));
		
		// keep track
		data_stream->shift_in(shifter->par_read(sel_out));
		indices->shift_in(sel_out);
		cycle++;
		
		// advance
		shifter->par_write(sel_out,-1);
		shifter->shift_in (n);		
	}
	//shifter->dump();	
}

///////////////////////////////////////////////////////

void build_unscrambler 
(
	SHIFT_REG * data_stream,
	SHIFT_REG * indices
)
{
	int n = 0, k = 0;
	int sel_out = 0;
	SHIFT_REG * shifter = NULL;

	shifter = new SHIFT_REG (2 * MAX_DISPLACE + 1);

	// initialize
	for (n=0;n<MAX_DISPLACE;n++)
	{
		shifter->shift_in (-1);
	}
	for (n=0;n<MAX_DISPLACE+1;n++)
	{
		shifter->shift_in (data_stream->shift_out());
	}
	//shifter->dump();

	for (n=0; n<PERIOD; n++)
	{
		k = shifter->index_of_value (n);
		indices->shift_in(k);
		shifter->shift_in (data_stream->shift_out());
	}
}

///////////////////////////////////////////////////////

void latency_adjustment 
(
	SHIFT_REG * data,
	int bits_per_tick,
	int leading_samples
)
{
	// for bits per tick = 2
	//   bits 0,1 have no latency
	//   bits 2,3 need to rotate by 1
	//   bits 4,5 need to rotate by 2
	int n = 0;
	SHIFT_REG * bit_reg [32];
	unsigned int val = 0;
	int k = 0;
	int b = 0;
	
	for (n=0; n<32; n++)
	{
		bit_reg[n] = new SHIFT_REG (PERIOD);	
	}

	// decompose into bits
	for (k=0;k<PERIOD;k++)
	{
		val = data->shift_out();
		for (n=0; n<32; n++)
		{
			bit_reg[n]->shift_in ((val & 1) ? 1 : 0);
			val = val >> 1;			
		}
	}
	
	// skew bits for read mux latency
	// this saves some stall registers on the select path
	for (n=bits_per_tick; n<32; n+=bits_per_tick)
	{
		for (k=n; k<32; k++)
		{
			bit_reg[k]->shift_in_reversed (bit_reg[k]->par_read(0));			
		}
	}

	// put words back together
	for (k=0;k<PERIOD;k++)
	{
		val = 0;
		for (n=0; n<32; n++)
		{
			b = bit_reg[n]->shift_out();
			val |= (b << n);			
		}
		data->shift_in(val);
	}			

	// skew for history latency
	for (n=0; n<leading_samples; n++)
	{
		data->shift_in_reversed (data->par_read(0));			
				
	}
}

///////////////////////////////////////////////////////

int main (void)
{
	SHIFT_REG * data_stream = NULL;
	SHIFT_REG * indices = NULL;
	SHIFT_REG * undo_indices = NULL;
	int n = 0;
	int val = 0, valb = 0;

//	srand(time(NULL));
	srand(123);
	
	indices = new SHIFT_REG (PERIOD);
	data_stream = new SHIFT_REG (PERIOD);
	undo_indices = new SHIFT_REG (PERIOD);
	
	// make scramble and unscramble patterns
	build_scrambler (indices,data_stream);
	build_unscrambler (data_stream,undo_indices);
	fprintf (stdout,"//");
	indices->dump();
	fprintf (stdout,"//");
	undo_indices->dump();

	// make verilog
	fprintf (stdout,"module word_stream_scramble (clk,rst,ena,din,dout,dout_valid);\n\n");

	fprintf (stdout,"`include \"log2.inc\"\n\n");	

	fprintf (stdout,"parameter WORD_LEN = %d;\n",WORD_LEN);
	fprintf (stdout,"parameter SCRAMBLE = 1'b1; // 0 for undo\n\n");

	fprintf (stdout,"localparam HIST_WORDS = %d;\n",HIST_WORDS);
	fprintf (stdout,"localparam PERIOD = %d;\n",PERIOD);
	fprintf (stdout,"localparam NUM_SEL = log2(HIST_WORDS-1);\n");
	fprintf (stdout,"localparam CNTR_BITS = log2(PERIOD-1);\n");
	fprintf (stdout,"localparam PAD_WORDS = (1<<NUM_SEL)-HIST_WORDS;\n\n");
	
	fprintf (stdout,"input clk,rst,ena;\n");
	fprintf (stdout,"input [WORD_LEN-1:0] din;\n");
	fprintf (stdout,"output [WORD_LEN-1:0] dout;\n");
	fprintf (stdout,"output dout_valid;\n\n");

	fprintf (stdout,"// din history shift register\n");
	fprintf (stdout,"reg [HIST_WORDS * WORD_LEN-1 : 0] history;\n");
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"    if (ena) begin\n");
	fprintf (stdout,"        if (rst) history <= 0;\n");
	fprintf (stdout,"        else history <= {history[(HIST_WORDS-1)*WORD_LEN-1:0],din};\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"// parallel access pipelined read mux\n");
	fprintf (stdout,"reg [NUM_SEL-1:0] sel;\n");
	fprintf (stdout,"pipelined_word_mux pwm (\n");
	fprintf (stdout,"    .clk(clk), .rst(rst),.ena(ena),\n");
	fprintf (stdout,"    .sel(sel),\n");
	fprintf (stdout,"    .din({{PAD_WORDS*WORD_LEN{1'b0}},history}),\n");
	fprintf (stdout,"    .dout(dout));\n");
	fprintf (stdout,"  defparam pwm .WORD_LEN = WORD_LEN;\n");
	fprintf (stdout,"  defparam pwm .NUM_WORDS_IN = HIST_WORDS+PAD_WORDS;\n");
	fprintf (stdout,"  defparam pwm .SEL_PER_LAYER = 2;\n");
	fprintf (stdout,"  defparam pwm .BALANCE_SELECTS = 1'b0;\n\n");

	fprintf (stdout,"// scrambling sequence counter\n");
	fprintf (stdout,"reg [CNTR_BITS-1:0] cntr;\n");
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"    if (ena) begin\n");
	fprintf (stdout,"       if (rst) cntr <= 0;\n");
	fprintf (stdout,"       else cntr <= cntr + 1'b1;\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"end\n\n");

	// latency adjustment - the lower order selects
	// have less latency than the higher order
	latency_adjustment (indices,2,MAX_DISPLACE);
	latency_adjustment (undo_indices,2,MAX_DISPLACE);

	fprintf (stdout,"// scramble pattern table to drive read select\n");
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"    if (ena) begin\n");
	fprintf (stdout,"        if (rst) sel <= 0;\n");
	fprintf (stdout,"        else begin\n");
	fprintf (stdout,"            case (cntr)\n");
	for (n=0; n<PERIOD; n++)
	{
		val = indices->shift_out();
		valb = undo_indices->shift_out();
		fprintf (stdout,"            %d'h%x : sel <= (SCRAMBLE ? %d'h%x : %d'h%x);\n",
				CNTR_BITS,n,NUM_SEL,val,NUM_SEL,valb);
	}
	fprintf (stdout,"            endcase\n");
	fprintf (stdout,"        end\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"// indicate (fresh) valid output data\n");
	fprintf (stdout,"reg dout_active, dout_valid;\n");
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"    if (ena & rst) begin\n");
	fprintf (stdout,"       dout_valid <= 1'b0;\n");
	fprintf (stdout,"       dout_active <= 1'b0;\n");
	fprintf (stdout,"    end else begin\n");
	fprintf (stdout,"       if (cntr == %d'h%x) dout_active <= 1'b1;\n",
									CNTR_BITS,MAX_DISPLACE+(CNTR_BITS/2) + (CNTR_BITS%2) - 1);
	fprintf (stdout,"       dout_valid <= dout_active & ena;\n"); 
	fprintf (stdout,"    end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"endmodule\n");

	return (0);
}
