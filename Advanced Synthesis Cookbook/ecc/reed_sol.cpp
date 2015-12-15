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

// baeckler - 08-01-2006

#include <stdio.h>
#include <stdlib.h>

int const MAX_SIZE = 256; // 2^symbol size

///////////////////////////////////////////

int gf_mult (
	int bits,
	int a,
	int b,
	int mod_poly
)
{
	int result = 0;
	
	while (b != 0)
	{
		if ((b & 1) != 0)
		{
			result ^= a;
		}
		a = a << 1;		
		if ((a & (1<<bits)) != 0) a ^= mod_poly;
		b = b >> 1;
	}
	return (result);
}

///////////////////////////////////////////

// XOR all of the bits of this integer
int reduce_xor (int dat)
{
	int result = 0;
	while (dat != 0)
	{
		result ^= (dat & 1);
		dat >>= 1;
	}
	return (result);
}

///////////////////////////////////////////

void build_gf_const_mult (
	int symbol_size,
	int const_val,
	int mod_poly
)
{
	int table [MAX_SIZE];
	int xor_ins = 0;
	int i = 0,j=0;
	bool first = false;
	
	// build a cheat sheet
	for (i=0; i<(1<<symbol_size); i++)
	{
		table [i] = gf_mult (symbol_size,i,const_val,mod_poly);
	}
	
	// start writing verilog
	fprintf (stdout,"module gf_mult_by_%02x (i,o);\n",const_val);
	fprintf (stdout,"input [%d:0] i;\n",symbol_size-1);
	fprintf (stdout,"output [%d:0] o;\n",symbol_size-1);
	fprintf (stdout,"wire [%d:0] o;\n",symbol_size-1);
	
	for (i=0; i<symbol_size; i++)
	{
		fprintf (stdout,"  assign o[%d] = ",i);

		// Each out should be an XOR of data inputs.
		// figure out which ones.
		xor_ins = 0;
		for (j = 0; j<symbol_size; j++)
		{
			// does toggling input J toggle output I?
			if ((table[0] & (1<<i)) != (table[(1<<j)] & (1<<i)))
			{
				xor_ins |= (1<<j);
			}
		}

		// sanity check that everything was works properly
		for (j=0; j<(1<<symbol_size); j++)
		{
			if ((reduce_xor (j & xor_ins) << i) !=
				(table[j] & (1<<i)))
			{
				fprintf (stdout,"Error while building const GF mult\n");
				fprintf (stdout,"  the space parameters may not be valid?\n");
				exit(1);
			}
		}		

		// dump it out
		first = true;
		for (j=0; j<symbol_size; j++)
		{
			if ((xor_ins & (1<<j)) != 0)
			{
				if (!first) fprintf (stdout,"^");
				fprintf (stdout,"i[%d]",j);
				first = false;
			}
		}
		fprintf (stdout,";\n");
	}		
	fprintf (stdout,"endmodule\n\n");
}
	
///////////////////////////////////////////

void build_gf_general_mult (
	int symbol_size,
	int mod_poly
)
{
	int table [MAX_SIZE];
	int i = 0, j=0, q = 0;
	int fbk = 0;
	bool first = true;
	int const lut_size = 6;

	fprintf (stdout,"\n///////////////////////////////////////////\n\n");

	// start writing verilog
	fprintf (stdout,"// Galois field multiplier, %d by %d modulus 0x%x\n",
		symbol_size,symbol_size,mod_poly);
	fprintf (stdout,"module gf_mult (a,b,o);\n");
	fprintf (stdout,"input [%d:0] a;\n",symbol_size-1);
	fprintf (stdout,"input [%d:0] b;\n",symbol_size-1);
	fprintf (stdout,"output [%d:0] o;\n",symbol_size-1);
	fprintf (stdout,"wire [%d:0] o /* synthesis keep */;\n",symbol_size-1);
	
	fprintf (stdout,"parameter METHOD = 2;\n\n");
	
	fprintf (stdout,"generate\n");

	////////////////////////////////////////////////
	// method 0 - powers of A then conditional sum
	////////////////////////////////////////////////
	fprintf (stdout,"    if (METHOD == 0) begin\n");
	fprintf (stdout,"        // Build A,2A,4A,.. with modulus\n");

	for (i=0; i<symbol_size; i++)
	{
		table[i] = 1<<i;
	}

	// do the powers of a
	for (i=0; i<symbol_size; i++)
	{
		// dump alpha i
		fprintf (stdout,"        wire [%d:0] a_%d;\n",symbol_size-1,i);
		fprintf (stdout,"        assign a_%d = {",i);
		for (j=symbol_size-1; j>=0; j--)
		{
			fprintf (stdout,"^(a & %d'h%x)",symbol_size,table[j]);
			if (j != 0) fprintf (stdout,",");
		}
		fprintf (stdout,"};\n\n");
	
		// update to the next power
		fbk = table[symbol_size-1];
		for (j=symbol_size-1; j>0; j--)
		{
			table[j] = table[j-1];
		}	
		table[0] = 0;
		for (j=symbol_size-1; j>=0; j--)
		{
			if ((mod_poly & (1<<j)) != 0)
			{
				table[j] ^= fbk;
			}
		}	
	}

	// combine based on b's
	fprintf (stdout,"        // Conditional sum based on the B bits\n");
	fprintf (stdout,"        assign o = \n");
	for (i=0; i<symbol_size; i++)
	{
		fprintf (stdout,"        ({%d{b[%d]}} & a_%d)",symbol_size,i,i); 	
		if (i!=symbol_size-1) fprintf (stdout," ^");
		if (i != symbol_size-1) fprintf (stdout,"\n");
	}
	fprintf (stdout,";\n\n");
	
	fprintf (stdout,"    end\n");

	////////////////////////////////////////////////
	// method 1 - shifted ANDs then fix the modulus
	////////////////////////////////////////////////
	fprintf (stdout,"    else if (METHOD == 1) begin\n");
	fprintf (stdout,"        // Build shifted sum of A&B0, A&B1... no modulus\n");
	fprintf (stdout,"        wire [%d:0] full_sum;\n",symbol_size*2-2);
	fprintf (stdout,"        assign full_sum = \n");
	for (i=0; i<symbol_size; i++)
	{
		fprintf (stdout,"            ");
		if (i != 0) fprintf (stdout,"{");
		fprintf (stdout,"({%d{b[%d]}} & a)",symbol_size,i,i); 	
		if (i != 0) fprintf (stdout,",%d'b0}",i);
		if (i!=symbol_size-1) fprintf (stdout," ^");
		if (i != symbol_size-1) fprintf (stdout,"\n");
	}
	fprintf (stdout,";\n\n");
	fprintf (stdout,"        // Modulus out the terms with out-of-range order\n");
	fprintf (stdout,"        assign o = \n");
	fprintf (stdout,"           full_sum[%d:0] ^\n",symbol_size-1);
	
	fbk = mod_poly & ((1<<symbol_size)-1);
	for (i=symbol_size; i<2*symbol_size-1; i++)
	{	
		fprintf (stdout,"           ({%d{full_sum[%d]}} & %d'h%x)",
				symbol_size,i,symbol_size,
				fbk);
		if (i==(2*symbol_size-2)) fprintf (stdout,";\n");
		else fprintf (stdout," ^\n");

		// advance the feedback pattern
		fbk = fbk << 1;
		if ((fbk & (1<<symbol_size)) != 0) fbk ^= mod_poly;
	}
	fprintf (stdout,"    end\n");
	
	////////////////////////////////////////////////
	// method 2 - explict AND array
	////////////////////////////////////////////////
	fprintf (stdout,"    else if (METHOD == 2) begin\n");
	fprintf (stdout,"        // Build explicit array of AND gates\n");
	fprintf (stdout,"        wire [%d:0] and_terms;\n",
			symbol_size * symbol_size -1);
	fprintf (stdout,"        assign and_terms = {\n");
	for (i=0; i<symbol_size; i++)
	{
		fprintf (stdout,"            ");
		fprintf (stdout,"({%d{b[%d]}} & a)",symbol_size,symbol_size-1-i); 	
		if (i!=symbol_size-1) fprintf (stdout,",");
		if (i != symbol_size-1) fprintf (stdout,"\n");
	}
	fprintf (stdout,"};\n\n");

	// build the equivalent of the full sum with no modulus
	//bool helper_tab[2*symbol_size][symbol_size*symbol_size];
	bool helper_tab[MAX_SIZE][MAX_SIZE];
	int signal_use [MAX_SIZE];
	bool helper_bin[MAX_SIZE][MAX_SIZE];
	int helper_bins_used = 0;
	bool adding_terms = true;
	bool resolved = false;
	int h = 0;


	if (MAX_SIZE < symbol_size*symbol_size) 
	{
		fprintf (stdout,"ERROR - raise MAX_SIZE\n");
		exit(1);
	}
	for (i=0; i<2*symbol_size; i++)
	{
		for (j=0; j<symbol_size*symbol_size; j++)
		{
			helper_tab[i][j] = false;
		}
	}
	for (i=0; i<symbol_size; i++)
	{
		for (j=0; j<symbol_size; j++)
		{
			helper_tab[j+i][i*symbol_size+j] = true;
		}
	}

	// modulus the out of range bits down
	fbk = mod_poly & ((1<<symbol_size)-1);
	for (i=symbol_size; i<2*symbol_size-1; i++)
	{	
		for (j=0; j<symbol_size; j++)
		{
			if ((fbk & (1 << j)) != 0)
			{
				for (q=0; q<symbol_size*symbol_size; q++)
				{
					helper_tab[j][q] ^= helper_tab[i][q];
				}
			}
		}

		// advance the feedback pattern
		fbk = fbk << 1;
		if ((fbk & (1<<symbol_size)) != 0) fbk ^= mod_poly;
	}
	
	// work on the output equations
	for (i=0; i<symbol_size; i++)
	{
		first = true;
		adding_terms = true;
		helper_bins_used = 0;
		while (adding_terms)
		{
			adding_terms = false;

			// find the number of checks for each input A/B
			//   they would normally be symmetric 
			for (j=0; j<2*symbol_size; j++)
			{
				signal_use[j] = 0;
			}
			for (j=0; j<symbol_size*symbol_size; j++)
			{
				if (helper_tab[i][j])
				{
					signal_use[symbol_size+(j/symbol_size)] += 1;
					signal_use[j%symbol_size] += 1;
				}
			}	

			// figure out which signal is most popular
			q = 0;		
			for (j=1; j<2*symbol_size; j++)
			{
				if (signal_use[j] > signal_use[q])
				{
					q = j;
				}
			}
		
			// find the AND terms using the most popular signal
			for (j=0; j<symbol_size*symbol_size; j++)
			{
				helper_bin[helper_bins_used][j] = false;
				if (helper_tab[i][j])
				{
					if ((j%symbol_size == q) ||
						((j/symbol_size+symbol_size) == q))
					{
						// move the signal from the output table
						// to a new helper bin
						helper_bin[helper_bins_used][j] = true;
						helper_tab[i][j] = false;
						adding_terms = true;
					}
				}
			}

			// see if this can be merged with any previous helper
			resolved = false;
			for (h=0;h<helper_bins_used && !resolved;h++)
			{
				// map the signal use of the newest helper
				for (j=0;j<symbol_size*2;j++)
				{
					signal_use[j] = 0;
				}
				for (j=0;j<symbol_size*symbol_size;j++)
				{
					if (helper_bin[helper_bins_used][j])	
					{
						signal_use [j%symbol_size] = 1;
						signal_use [j/symbol_size+symbol_size] = 1;
					}
					if (helper_bin[h][j])	
					{
						signal_use [j%symbol_size] = 1;
						signal_use [j/symbol_size+symbol_size] = 1;
					}
				}
				
				// count total signal use on the merge candidate
				q = 0;
				for (j=0;j<symbol_size*2;j++)
				{
					if (signal_use[j]) q++;
				}

				if (q <= lut_size) 
				{
					// accept the merge - add some terms to helper H
					for (j=0;j<symbol_size*symbol_size;j++)
					{
						if (helper_bin[helper_bins_used][j])
						{
							helper_bin[h][j] = true;
						}
					}					
					resolved = true;
				}					
				else 
				{
					// these two helpers won't fit together
				}
			}
			
			// if unable to merge then take a new helper slot
			if (!resolved)
			{
				helper_bins_used++;
			}
		}
		
		// spit out the helpers
		for (h=0; h<helper_bins_used; h++)
		{
			fprintf (stdout,"       wire o%d_helper%d = ",i,h);
			first = true;
			for (j=0;j<symbol_size*symbol_size;j++)
			{
				if (helper_bin[h][j])
				{
					if (!first) fprintf (stdout," ^");
					first = false;
					fprintf (stdout,"\n");
					fprintf (stdout,"           and_terms[%d] /* B[%d] A[%d] */",
						j,j/symbol_size,j%symbol_size);
				}
			}
			fprintf (stdout," /* synthesis keep */;\n\n");
		}

		// output is the xor of the helpers
		fprintf (stdout,"       assign o[%d] = \n",i);
		for (h=0; h<helper_bins_used; h++)
		{
			if (h != 0) fprintf (stdout," ^\n");
			fprintf (stdout,"         o%d_helper%d",i,h);			
		}		
		fprintf (stdout,";\n\n");
	}
	fprintf (stdout,"    end\n");
	fprintf (stdout,"endgenerate\n");
	fprintf (stdout,"endmodule\n\n");
}

///////////////////////////////////////////

void build_gf_inverse (
	int symbol_size,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int alpha [MAX_SIZE];
	int i,j;
	
	// build up the values of alpha^(i) mod poly
	alpha[0] = 1;
	for (i=1; i<=n; i++)
	{
		alpha[i] = gf_mult (symbol_size,alpha[i-1],2,mod_poly);
	}

	fprintf (stdout,"\n///////////////////////////////////////////\n\n");

	fprintf (stdout,"module gf_inverse (i,o);\n");
	fprintf (stdout,"input [%d:0] i;\n",symbol_size-1);
	fprintf (stdout,"output [%d:0] o;\n",symbol_size-1);
	fprintf (stdout,"reg [%d:0] o /* synthesis keep */;\n",symbol_size-1);

	fprintf (stdout,"  always @(i) begin\n");
	fprintf (stdout,"     case (i)\n");
	fprintf (stdout,"       %d'h0: o=%d'h0;\n",symbol_size,symbol_size);
	for (i=0; i<n; i++)
	{
		fprintf (stdout,"       %d'h%x: o=%d'h%x;\n",symbol_size,
			alpha[i],symbol_size,alpha[(n-i)%n]);
	}
	fprintf (stdout,"     endcase\n");
	fprintf (stdout,"   end\n");
	fprintf (stdout,"endmodule\n\n");
}

///////////////////////////////////////////

void build_gf_divide (
	int symbol_size
)
{
	fprintf (stdout,"\n///////////////////////////////////////////\n\n");

	fprintf (stdout,"module gf_divide (n,d,o);\n");
	fprintf (stdout,"input [%d:0] n;\n",symbol_size-1);
	fprintf (stdout,"input [%d:0] d;\n",symbol_size-1);
	fprintf (stdout,"output [%d:0] o;\n",symbol_size-1);
	fprintf (stdout,"wire [%d:0] o;\n\n",symbol_size-1);

	fprintf (stdout,"wire [%d:0] d_inv;\n",symbol_size-1);
	fprintf (stdout,"gf_inverse divi (.i(d),.o(d_inv));\n");
	fprintf (stdout,"gf_mult divm (.a(n),.b(d_inv),.o(o));\n\n");

	fprintf (stdout,"endmodule\n\n");
}

///////////////////////////////////////////

void build_gf_math_tb (
	int symbol_size
)
{
	fprintf (stdout,"\n//////////////////////////////////////////\n");
	fprintf (stdout,"// GF mult / div correctness testbench \n");
	fprintf (stdout,"//////////////////////////////////////////\n\n");

	fprintf (stdout,"module gf_math_tb();\n");
	fprintf (stdout,"reg fail = 1'b0;\n");
	fprintf (stdout,"reg [%d:0] a,b;\n",symbol_size-1);
	fprintf (stdout,"wire [%d:0] om0,om1,om2,om3,om4,om5,om6,oi0,oi1;\n\n",symbol_size-1);

	fprintf (stdout,"// multipliers - (all equivalent)\n");
	fprintf (stdout,"gf_mult m0 (.a(a),.b(b),.o(om0));\n");
	fprintf (stdout,"gf_mult m1 (.a(a),.b(b),.o(om1));\n");
	fprintf (stdout,"gf_mult m2 (.a(b),.b(a),.o(om2));\n");
	fprintf (stdout,"gf_mult m3 (.a(b),.b(a),.o(om3));\n");
	fprintf (stdout,"gf_mult m6 (.a(a),.b(b),.o(om6));\n");
	fprintf (stdout,"defparam m0 .METHOD = 0;\n");
	fprintf (stdout,"defparam m1 .METHOD = 1;\n");
	fprintf (stdout,"defparam m2 .METHOD = 0;\n");
	fprintf (stdout,"defparam m3 .METHOD = 1;\n");
	fprintf (stdout,"defparam m6 .METHOD = 2;\n\n");

	fprintf (stdout,"// mult. inverse\n");
	fprintf (stdout,"gf_inverse i0 (.i(a),.o(oi0));\n");
	fprintf (stdout,"gf_inverse i1 (.i(b),.o(oi1));\n\n");
	
	fprintf (stdout,"// pseudo divide\n");
	fprintf (stdout,"gf_mult m4 (.a(om0),.b(oi0),.o(om4));\n");
	fprintf (stdout,"defparam m4 .METHOD = 0;\n");
	fprintf (stdout,"gf_mult m5 (.a(om0),.b(oi1),.o(om5));\n");
	fprintf (stdout,"defparam m5 .METHOD = 0;\n\n");
	
	fprintf (stdout,"// verify\n");
	fprintf (stdout,"always begin\n");
	fprintf (stdout,"  #10\n");
	fprintf (stdout,"  a = $random;\n");
	fprintf (stdout,"  b = $random;\n");
	fprintf (stdout,"  #10\n");
	fprintf (stdout,"  if (om0 !== om1) fail = 1;\n");
	fprintf (stdout,"  if (om0 !== om2) fail = 1;\n");
	fprintf (stdout,"  if (om0 !== om3) fail = 1;\n");
	fprintf (stdout,"  if (om0 !== om6) fail = 1;\n");
	fprintf (stdout,"  if (om4 !== b && a !== 0) fail = 1;\n");
	fprintf (stdout,"  if (om5 !== a && b !== 0) fail = 1;\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"initial begin\n");
	fprintf (stdout,"  #1000000 if (!fail) begin\n");
	fprintf (stdout,"    $display (\"PASS\");\n");
	fprintf (stdout,"    $stop();\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"    $display (\"FAIL\");\n");
	fprintf (stdout,"    $stop();\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"endmodule\n\n");
	
}

///////////////////////////////////////////

void build_encoder (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	int alpha [MAX_SIZE];
	int g [MAX_SIZE];
	int i,j;
	int const b = 0;

	bool found = false;

	fprintf (stdout,"// Reed Solomon\n");
	fprintf (stdout,"// N = %d (symbols per code word)\n",n);
	fprintf (stdout,"// K = %d (data symbols)\n",k);
	fprintf (stdout,"// t = %d (# of errors corrected)\n",t);
	fprintf (stdout,"// 2t = %d (# of check symbols)\n",2*t);
	fprintf (stdout,"// m = %d (bits per symbol)\n\n",symbol_size);

	// build up the values of alpha^(i) mod poly
	alpha[0] = 1;
	for (i=1; i<=n; i++)
	{
		alpha[i] = gf_mult (symbol_size,alpha[i-1],2,mod_poly);
	}
	
	fprintf (stdout,"\n");
	for (i=0; i<=n; i++)
	{
		fprintf (stdout,"// alpha ^ %d = %02x\n",i,alpha[i]);
	}

	// build up the generator poly - product of alphas 1..2*t 
	for (i=0; i<(n-k+1); i++)
	{
		g[i] = 0;
	}
	
	g[0] = 1;
	for (i=1; i<(n-k+1); i++)
	{
		for (j=n-k; j>0; j--)
		{
			g[j] = gf_mult (symbol_size,g[j],alpha[i-1+b],mod_poly) ^
					g[j-1];
		}
		g[0] = gf_mult (symbol_size,g[0],alpha[i-1+b],mod_poly);
	}

	fprintf (stdout,"\n");
	for (i=0; i<(n-k+1); i++)
	{
		fprintf (stdout,"// gen_poly [%d] = %02x\n",i,g[i]);
	}

	fprintf (stdout,"\n");
		
	// build a full rack of GF constant multipliers
	for (i=1; i<=n; i++)
	{
		build_gf_const_mult (symbol_size,i,mod_poly);
	}
	
	fprintf (stdout,"\n///////////////////////////////////////////\n\n");

	// main encoder
	fprintf (stdout,"// first din zeros the accumulator on the first data symbol\n");
	fprintf (stdout,"// shift is for reading out the parity register, overrides\n");
	fprintf (stdout,"//   the first_din signal\n");
	fprintf (stdout,"module encoder (clk,rst,shift,ena,first_din,din,parity);\n");
	fprintf (stdout,"input clk,rst,shift,ena,first_din;\n");
	fprintf (stdout,"input [%d:0] din;\n",symbol_size-1);
	fprintf (stdout,"output [%d:0] parity;\n",t*2*symbol_size-1);
	fprintf (stdout,"reg [%d:0] parity;\n\n",t*2*symbol_size-1);

	fprintf (stdout,"  wire [%d:0] feedback;\n",symbol_size-1);
	fprintf (stdout,"  assign feedback = din ^ (first_din ? %d'b0 : parity[%d:%d]);\n\n",
			symbol_size,
			t*2*symbol_size-1,
			t*2*symbol_size-symbol_size);
	
	fprintf (stdout,"  wire [%d:0] gen_fn;\n",t*2*symbol_size-1);
	for (i=0; i<(n-k); i++)
	{
		fprintf (stdout,"  gf_mult_by_%02x m%d (.i(feedback),.o(gen_fn[%d:%d]));\n"
				,g[i],i,(i+1)*symbol_size-1,i*symbol_size);
	}
	fprintf (stdout,"\n");

	fprintf (stdout,"  always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"    if (rst) begin\n");
	fprintf (stdout,"      parity <= 0;\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"    else if (ena) begin\n");
	fprintf (stdout,"      parity <= ((!shift & first_din) ? %d'b0 : (parity << %d)) ^\n",
		t*2*symbol_size,symbol_size);
	fprintf (stdout,"             (shift ? %d'b0 : gen_fn);\n",
		t*2*symbol_size,symbol_size);
	fprintf (stdout,"    end\n");
	fprintf (stdout,"  end\n");
	
	fprintf (stdout,"endmodule\n\n");
	
}

///////////////////////////////////////////

void build_syndrome_flat (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	int alpha [MAX_SIZE];
	int const b = 0;

	int i,j;
	int mult_num = 0;

	fprintf (stdout,"\n///////////////////////////////////////////\n\n");

	// build up the values of alpha^(i) mod poly
	alpha[0] = 1;
	for (i=1; i<=n; i++)
	{
		alpha[i] = gf_mult (symbol_size,alpha[i-1],2,mod_poly);
	}

	fprintf (stdout,"// No latency syndrome computation\n");
	fprintf (stdout,"module syndrome_flat (rx_data,syndrome);\n");
	fprintf (stdout,"input [%d:0] rx_data;\n",n * symbol_size-1);
	fprintf (stdout,"output [%d:0] syndrome;\n",2*t*symbol_size-1);
	fprintf (stdout,"wire [%d:0] syndrome;\n\n",2*t*symbol_size-1);

	for (i=0; i<2*t; i=i+1)
	{
		fprintf (stdout,"\n// syndrome %d\n",i);
		fprintf (stdout,"  wire [%d:0] syn_%d_tmp;\n",n*symbol_size-1,i);
		for (j=0; j<n; j=j+1)
		{
			fprintf (stdout,"  gf_mult_by_%02x m%d (.i(rx_data[%d:%d]),.o(syn_%d_tmp[%d:%d]));\n"
				,alpha[((i+b)*j)%n],
				mult_num,
				(j+1)*symbol_size-1,j*symbol_size,
				i,
				(j+1)*symbol_size-1,j*symbol_size);
			mult_num++;
		}
		
		fprintf (stdout,"  assign syndrome[%d:%d] =",(i+1)*symbol_size-1,i*symbol_size);
		for (j=0; j<n; j=j+1)
		{
			if ((j % 3) == 0) fprintf (stdout,"\n      ");
			fprintf (stdout,"syn_%d_tmp[%d:%d]",i,(j+1)*symbol_size-1,j*symbol_size);
			if (j != n-1) fprintf (stdout," ^ ");			
		}
		fprintf (stdout,";\n");
	}
	fprintf (stdout,"\nendmodule\n\n");
}

///////////////////////////////////////////

void build_syndrome_round (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	int alpha [MAX_SIZE];
	int const b = 0;

	int i,j;
	int mult_num = 0;

	fprintf (stdout,"\n///////////////////////////////////////////\n\n");

	// build up the values of alpha^(i) mod poly
	alpha[0] = 1;
	for (i=1; i<=n; i++)
	{
		alpha[i] = gf_mult (symbol_size,alpha[i-1],2,mod_poly);
	}
	
	fprintf (stdout,"// 1 cycle per data symbol syndrome computation\n");
	fprintf (stdout,"// on the last cycle skip the mult, just XOR\n");
	fprintf (stdout,"module syndrome_round (rx_data,syndrome_in,syndrome_out,skip_mult);\n");
	fprintf (stdout,"input [%d:0] rx_data;\n",symbol_size-1);
	fprintf (stdout,"input [%d:0] syndrome_in;\n",2*t*symbol_size-1);
	fprintf (stdout,"input skip_mult;\n");
	fprintf (stdout,"output [%d:0] syndrome_out;\n",2*t*symbol_size-1);
	
	for (i=0; i<2*t; i=i+1)
	{
		fprintf (stdout,"\n// syndrome %d\n",i);
		fprintf (stdout,"  wire [%d:0] syn_%d_in;\n",symbol_size-1,i);
		fprintf (stdout,"  wire [%d:0] syn_%d_mult;\n",symbol_size-1,i);
		fprintf (stdout,"  assign syn_%d_in = rx_data ^ syndrome_in[%d:%d];\n",
				i,(i+1)*symbol_size-1,i*symbol_size);
		fprintf (stdout,"  gf_mult_by_%02x sm%d (.i(syn_%d_in),.o(syn_%d_mult));\n",
				alpha[i],
				i,i,i);
		fprintf (stdout,"  assign syndrome_out [%d:%d] = (skip_mult ? \n",
				(i+1)*symbol_size-1,i*symbol_size);
		fprintf (stdout,"         syn_%d_in : syn_%d_mult);\n",i,i);      
		fprintf (stdout,"\n");
	}

	fprintf (stdout,"\nendmodule\n\n");
}

///////////////////////////////////////////

void build_syndrome_tb (
	int symbol_size,
	int data_symbols
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	int i = 0;

	fprintf (stdout,"\n///////////////////////////////////////////\n\n");
	fprintf (stdout,"// PROBLEM - the iterative unit isn't exercised well\n");
	fprintf (stdout,"module syndrome_tb ();\n");
	fprintf (stdout,"reg [%d:0] din;\n",symbol_size-1);
	fprintf (stdout,"reg clk,clk_ena,tx_ena,rst,first_din;\n");
	fprintf (stdout,"wire [%d:0] parity;\n",symbol_size*2*t-1);
	fprintf (stdout,"reg [%d:0] tx_buffer;\n",k*symbol_size-1);
	fprintf (stdout,"wire [%d:0] tx_data = {tx_buffer,parity};\n",n*symbol_size-1);
	fprintf (stdout,"reg [%d:0] err;\n",n*symbol_size-1);
	fprintf (stdout,"wire [%d:0] rx_data = tx_data ^ err;\n",n*symbol_size-1);

	fprintf (stdout,"wire [%d:0] syndrome;\n",symbol_size*2*t-1);
	fprintf (stdout,"reg [%d:0] syndrome_reg;\n",symbol_size*2*t-1);
	fprintf (stdout,"wire [%d:0] next_syndrome_reg;\n\n",symbol_size*2*t-1);

	fprintf (stdout,"// iterative encoder\n");
	fprintf (stdout,"encoder enc (.clk(clk & tx_ena),.ena(1'b1),.shift(1'b0),.rst(rst),.first_din(first_din),.din(din),.parity(parity));\n\n");
	
	fprintf (stdout,"// flat and iterative syndrome generators\n");
	fprintf (stdout,"reg [%d:0] par;\n",symbol_size-1);
	fprintf (stdout,"reg sending_data;\n");
	fprintf (stdout,"syndrome_flat syn_f (.rx_data(rx_data),.syndrome(syndrome));\n");
	fprintf (stdout,"syndrome_round syn_r (.rx_data(sending_data ? din : par),.syndrome_in(syndrome_reg),");
	fprintf (stdout,"	.syndrome_out(next_syndrome_reg),.skip_mult(1'b0));\n\n");

	fprintf (stdout,"initial begin\n");
	fprintf (stdout,"  clk = 0;\n");
	fprintf (stdout,"  rst = 0;\n");
	fprintf (stdout,"  tx_ena = 1'b1;\n");
	fprintf (stdout,"  clk_ena = 1'b1;\n");
	fprintf (stdout,"  sending_data = 1'b1;\n");
	fprintf (stdout,"  first_din = 1'b1;\n");
	fprintf (stdout,"  #10 rst = 1;\n");
	fprintf (stdout,"  #10 rst = 0;\n");
	fprintf (stdout,"  @(posedge clk) syndrome_reg <= 0; // cheating\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"always begin\n");
	fprintf (stdout,"  #100 if (clk_ena) clk = ~clk;\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"always @(negedge clk) begin\n");
	fprintf (stdout,"  din <= $random;\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"  if (tx_ena) tx_buffer <= (tx_buffer << %d) | din;\n",symbol_size);
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) syndrome_reg <= 0;\n");
	fprintf (stdout,"  else syndrome_reg <= next_syndrome_reg;\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"integer i;\n");
	fprintf (stdout,"initial begin\n\n");
	
	fprintf (stdout,"  // start the TX of a new word\n");
	fprintf (stdout,"  #100\n");
	fprintf (stdout,"  @(negedge clk);\n");
	fprintf (stdout,"  err = 0;\n");
	fprintf (stdout,"  first_din = 1'b1;\n");
	fprintf (stdout,"  @(posedge clk);\n");
	fprintf (stdout,"  @(negedge clk);\n");
	fprintf (stdout,"  first_din = 1'b0;\n");
	fprintf (stdout,"  for (i=0; i<%d; i=i+1) begin\n",k-1);
	fprintf (stdout,"    @(posedge clk);\n");
	fprintf (stdout,"    @(negedge clk);\n");
	fprintf (stdout,"  end\n\n");
	
	fprintf (stdout,"  // stop the TX, RX gets more cycle of data..\n");
	fprintf (stdout,"  tx_ena = 1'b0;\n");
	fprintf (stdout,"  sending_data = 1'b0;\n");
	
	fprintf (stdout,"  // give the RX the rest of the parity symbols..\n");
	for (i=0; i<2*t;i=i+1)
	{
		fprintf (stdout,"  par = parity [%d:%d];\n",
			2*t*symbol_size-1-i*symbol_size,
			2*t*symbol_size-1-i*symbol_size-(symbol_size-1));
		fprintf (stdout,"  @(posedge clk);\n");
		fprintf (stdout,"  @(negedge clk);\n");
	}
	fprintf (stdout,"  clk_ena = 1'b0;\n");
	fprintf (stdout,"\n");
	fprintf (stdout,"  // Check the syndromes of the uncorrupted data\n");
	fprintf (stdout,"  $display (\"tx data %%x\",tx_data);\n");
	fprintf (stdout,"  $display (\"  pure rx data %%x\",rx_data);\n");
	fprintf (stdout,"  $display (\"  flat syndrome %%x\",syndrome);\n");
	fprintf (stdout,"  if (syndrome !== 0) begin\n");
	fprintf (stdout,"    $display (\"Error : correct code has a non-zero syndrome\");\n");
	fprintf (stdout,"    $stop();\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  $display (\"  round syndrome %%x\",syndrome_reg);\n");
	fprintf (stdout,"  if (syndrome_reg !== 0) begin\n");
	fprintf (stdout,"    $display (\"Error : correct code has a non-zero syndrome\");\n");
	fprintf (stdout,"    $stop();\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"\n");	
	fprintf (stdout,"  // Corrupt, and make sure it gets detected\n");
	fprintf (stdout,"  #10 err = 1'b1;\n");
	fprintf (stdout,"  for (i=0; i<%d; i=i+1) begin\n",n*symbol_size);
	fprintf (stdout,"    #10\n");
	fprintf (stdout,"    $display (\"  corrupted rx data %%x\",rx_data);\n");
	fprintf (stdout,"    $display (\"  syndrome %%x\",syndrome);\n");
	fprintf (stdout,"    if (syndrome == 0) begin\n");
	fprintf (stdout,"      $display (\"Error : incorrect code has zero syndrome\");\n");
	fprintf (stdout,"      $stop();\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"    err = err << 1;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  $display (\"PASS\");\n");
	fprintf (stdout,"  $stop();\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"endmodule\n");
}

///////////////////////////////////////////

int log_2 (int n)
{
	int lg = 0;
	while (n!=0)
	{
		n >>= 1;
		lg++;
	}
	return (lg);
}

///////////////////////////////////////////

void build_error_loc_poly (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;

	int i = 0;
	int mult_num = 0;

	fprintf (stdout,"\n///////////////////////////////////////////\n");
	fprintf (stdout,"// Error Location poly computation\n");
	fprintf (stdout,"//   1 tick per round version\n");
	fprintf (stdout,"///////////////////////////////////////////\n\n");
	
	fprintf (stdout,"// initial ELP_in is 1 at word 0 (meaning 1)\n");
	fprintf (stdout,"// initial correction is 1 at word 1 (meaning x)\n");
	fprintf (stdout,"// step = 1..2t\n");
	fprintf (stdout,"// This is using the Berlekamp method\n");
	fprintf (stdout,"module error_loc_poly_round (step,order_in,order_out,elp_in,elp_out,step_syndrome,\n");
	fprintf (stdout,"          correction_in,correction_out);\n");
	fprintf (stdout,"input [%d:0] step;\n",log_2(2*t)-1);
	fprintf (stdout,"input [%d:0] order_in;\n",log_2(2*t-1)-1);
	fprintf (stdout,"output [%d:0] order_out;\n",log_2(2*t-1)-1);
	fprintf (stdout,"input [%d:0] elp_in;\n",symbol_size*2*t-1);
	fprintf (stdout,"output [%d:0] elp_out;\n",symbol_size*2*t-1);
	fprintf (stdout,"input [%d:0] step_syndrome;\n",symbol_size*2*t-1);
	fprintf (stdout,"input [%d:0] correction_in;\n",symbol_size*2*t-1);
	fprintf (stdout,"output [%d:0] correction_out;\n\n",symbol_size*2*t-1);
	
	fprintf (stdout,"reg [%d:0] order_out;\n",log_2(2*t-1)-1);
	fprintf (stdout,"reg [%d:0] correction_out;\n\n",symbol_size*2*t-1);
	fprintf (stdout,"wire [%d:0] discrepancy;\n\n",symbol_size-1);
	
	fprintf (stdout,"wire [%d:0] disc_mult;\n",symbol_size*2*t-1);
	for (i=0; i<2*t; i=i+1)
	{
		fprintf (stdout,"gf_mult m%d (.a(elp_in[%d:%d]),.b(step_syndrome[%d:%d]),.o(disc_mult[%d:%d]));\n",
			mult_num,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size
		);
		mult_num++;
	}

	fprintf (stdout,"\nassign discrepancy = \n");
	for (i=0; i<2*t; i=i+1)
	{
		fprintf (stdout,"    disc_mult [%d:%d]",
			(i+1)*symbol_size-1,i*symbol_size);
		if (i != 2*t-1) 
		{
			fprintf (stdout," ^");
		}			
		fprintf (stdout,"\n");
	}
	fprintf (stdout,";\n\n");

	fprintf (stdout,"wire [%d:0] disc_mult_correction;\n",symbol_size*2*t-1);

	for (i=0; i<2*t; i=i+1)
	{
		fprintf (stdout,"gf_mult m%d (.a(discrepancy),"
			".b(correction_in[%d:%d]),.o(disc_mult_correction[%d:%d]));\n",
			mult_num,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size
		);
		mult_num++;
	}

	fprintf (stdout,"\nassign elp_out = elp_in ^ disc_mult_correction;\n\n");

	fprintf (stdout,"// build the elp divided by the discrepancy\n");
	fprintf (stdout,"//  by inverse then multiply...\n");
	fprintf (stdout,"wire [%d:0] inv_discrepancy;\n",symbol_size-1);
	fprintf (stdout,"gf_inverse id (.i(discrepancy),.o(inv_discrepancy));\n\n");

	fprintf (stdout,"wire [%d:0] elp_div_disc;\n",symbol_size*2*t-1);
	for (i=0; i<2*t; i=i+1)
	{
		fprintf (stdout,"gf_mult d%d (.a(elp_in[%d:%d]),"
			".b(inv_discrepancy),.o(elp_div_disc[%d:%d]));\n",
			mult_num,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size
		);
		mult_num++;
	}

	fprintf (stdout,"\n");
	fprintf (stdout,"// update the order and correction poly\n");
	fprintf (stdout,"always @(*) begin\n");
	fprintf (stdout,"  if ((|discrepancy) && ((order_in << 1) < step)) begin\n");
	fprintf (stdout,"    order_out = step - order_in;\n");
	fprintf (stdout,"    correction_out = {elp_div_disc[%d:%d],%d'b0};\n",
			symbol_size*2*t-1-symbol_size,
			0,
			symbol_size);
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"    order_out = order_in;\n");
	fprintf (stdout,"    correction_out = {correction_in[%d:%d],%d'b0} ;\n",
			symbol_size*2*t-1-symbol_size,
			0,
			symbol_size);
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"endmodule\n");
}

///////////////////////////////////////////

void build_error_loc_poly_multi_step (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;

	int i = 0;
	int mult_num = 0;

	fprintf (stdout,"\n/////////////////////////////////////////////////\n");
	fprintf (stdout,"// Error Location poly computation\n");
	fprintf (stdout,"//   Multiple ticks per round version\n");
	fprintf (stdout,"///////////////////////////////////////////////////\n\n");
	
	fprintf (stdout,"// initial ELP_in is 1 at word 0 (meaning 1)\n");
	fprintf (stdout,"// initial correction is 1 at word 1 (meaning x)\n");
	fprintf (stdout,"// step = 1..2t\n");
	fprintf (stdout,"// This is using the Berlekamp method\n");
	fprintf (stdout,"module error_loc_poly_round_multi_step (step,order_in,order_out,elp_in,elp_out,step_syndrome,\n");
	fprintf (stdout,"          correction_in,correction_out,clk,rst,sync,elpr_wait);\n");
	fprintf (stdout,"input [%d:0] step;\n",log_2(2*t)-1);
	fprintf (stdout,"input [%d:0] order_in;\n",log_2(2*t-1)-1);
	fprintf (stdout,"output [%d:0] order_out;\n",log_2(2*t-1)-1);
	fprintf (stdout,"input [%d:0] elp_in;\n",symbol_size*2*t-1);
	fprintf (stdout,"output [%d:0] elp_out;\n",symbol_size*2*t-1);
	fprintf (stdout,"input [%d:0] step_syndrome;\n",symbol_size*2*t-1);
	fprintf (stdout,"input [%d:0] correction_in;\n",symbol_size*2*t-1);
	fprintf (stdout,"output [%d:0] correction_out;\n\n",symbol_size*2*t-1);
	
	fprintf (stdout,"input clk,rst,sync;\n");
	fprintf (stdout,"output elpr_wait;\n\n");

	fprintf (stdout,"reg [%d:0] order_out;\n",log_2(2*t-1)-1);
	fprintf (stdout,"reg [%d:0] correction_out;\n\n",symbol_size*2*t-1);
	fprintf (stdout,"wire [%d:0] discrepancy;\n\n",symbol_size-1);

	fprintf (stdout,"// state 0 : (upper) discrepancy_reg <= ^ (elp_in * step_syn)\n");
	fprintf (stdout,"// state 1 : (lower) discrepancy_reg <= ^ (elp_in * step_syn)\n");
	fprintf (stdout,"// state 2 : (upper) disc_cor_reg <= (dicrepancy_reg * correction)\n");
	fprintf (stdout,"// state 3 : (lower) disc_cor_reg <= (dicrepancy_reg * correction)\n");
	fprintf (stdout,"// state 4 : (upper) elp_div_disc_reg <= elp_in * inverse discrepancy\n");
	fprintf (stdout,"// state 5 : (lower) elp_div_disc_reg <= elp_in * inverse discrepancy\n");
	fprintf (stdout,"// state 6 : settling time\n");
	
	fprintf (stdout,"reg [6:0] wait_state;\n\n");
		
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) wait_state <= 7'b1;\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"    if (sync) wait_state <= 7'b000001;\n");
	fprintf (stdout,"    else wait_state <= {wait_state[5:0],wait_state[6]};\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"assign elpr_wait = !wait_state[6];\n\n");

	fprintf (stdout,"wire [%d:0] mult_in_a, mult_in_b, mult_o, disc_inv_repeat;\n",symbol_size*t-1);
	fprintf (stdout,"wire [%d:0] disc_inv_mux;\n",symbol_size-1);
	fprintf (stdout,"assign disc_inv_repeat = {%d{disc_inv_mux}};\n\n",t);
	
	fprintf (stdout,"// multi purpose Galois mult (half size)\n");
//printf (stdout,"assign mult_in_a = ((wait_state[0] || wait_state[1] || wait_state[4] || wait_state[5]) ? elp_in : correction_in);\n");
//printf (stdout,"assign mult_in_b = ((wait_state[0] || wait_state[1]) ? step_syndrome : disc_inv_repeat);\n");
	
	fprintf (stdout,"wire [%d:0] elp_in_hi, elp_in_lo, correction_in_hi, correction_in_lo;\n",symbol_size*t-1);
	fprintf (stdout,"wire [%d:0] step_syndrome_hi, step_syndrome_lo;\n",symbol_size*t-1);
	fprintf (stdout,"assign {step_syndrome_hi,step_syndrome_lo} = step_syndrome;\n");
	fprintf (stdout,"assign {elp_in_hi,elp_in_lo} = elp_in;\n");
	fprintf (stdout,"assign {correction_in_hi,correction_in_lo} = correction_in;\n\n");

	fprintf (stdout,"assign mult_in_a = (wait_state[0] | wait_state[4]) ? elp_in_hi :\n");
	fprintf (stdout,"                   (wait_state[1] | wait_state[5]) ? elp_in_lo :\n");
	fprintf (stdout,"                   (wait_state[2]) ? correction_in_hi :\n");
	fprintf (stdout,"                   correction_in_lo;\n");
	fprintf (stdout,"assign mult_in_b = (wait_state[0]) ? step_syndrome_hi :\n");
	fprintf (stdout,"                   (wait_state[1]) ? step_syndrome_lo :\n");
	fprintf (stdout,"                   disc_inv_repeat;\n\n");

	for (i=0; i<t; i=i+1)
	{
		fprintf (stdout,"gf_mult m%d (.a(mult_in_a[%d:%d]),.b(mult_in_b[%d:%d]),.o(mult_o[%d:%d]));\n",
			mult_num,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size
		);
		mult_num++;
	}
	fprintf (stdout,"\n");

	fprintf (stdout,"// XOR the mult output words together for the discrepancy\n");
	fprintf (stdout,"assign discrepancy = \n");
	for (i=0; i<t; i=i+1)
	{
		fprintf (stdout,"    mult_o [%d:%d]",
			(i+1)*symbol_size-1,i*symbol_size);
		if (i != t-1) 
		{
			fprintf (stdout," ^");
		}			
		fprintf (stdout,"\n");
	}
	fprintf (stdout,";\n\n");

	fprintf (stdout,"reg [%d:0] discrepancy_reg;\n",symbol_size-1);
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) discrepancy_reg <= 0;\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"    if (wait_state[0]) discrepancy_reg <= discrepancy;\n");
	fprintf (stdout,"    else if (wait_state[1]) discrepancy_reg <= discrepancy ^ discrepancy_reg;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"\n// XOR the mult output words with ELP in for ELP out\n");
	fprintf (stdout,"reg [%d:0] disc_cor_reg;\n",2*t*symbol_size-1);
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) disc_cor_reg <= 0;\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"     if (wait_state[2]) disc_cor_reg[%d:%d] <= mult_o;\n",
							2*t*symbol_size-1,
							t*symbol_size);
	fprintf (stdout,"     else if (wait_state[3]) disc_cor_reg[%d:0] <= mult_o;\n",
							t*symbol_size);
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	fprintf (stdout,"assign elp_out = elp_in ^ disc_cor_reg;\n\n");

	fprintf (stdout,"// Capture the mult out directly for ELP divided by discrepancy\n");
	fprintf (stdout,"reg [%d:0] elp_div_disc_reg;\n",symbol_size*2*t-1);
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) elp_div_disc_reg <= 0;\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"     if (wait_state[4]) elp_div_disc_reg[%d:%d] <= mult_o;\n",
							2*t*symbol_size-1,
							t*symbol_size);
	fprintf (stdout,"     else if (wait_state[5]) elp_div_disc_reg[%d:0] <= mult_o;\n",
							t*symbol_size);
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"// build the mult inverse of the discrepancy\n");
	fprintf (stdout,"wire [%d:0] inv_discrepancy_wire;\n",symbol_size-1);
	fprintf (stdout,"reg [%d:0] inv_discrepancy;\n",symbol_size-1);
	fprintf (stdout,"gf_inverse id (.i(discrepancy_reg),.o(inv_discrepancy_wire));\n\n");
	
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) inv_discrepancy <= %d'b0;\n",symbol_size);
	fprintf (stdout,"  else inv_discrepancy <= inv_discrepancy_wire;\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"// offer the discrepancy or inverse to the multiplier\n");
	fprintf (stdout,"assign disc_inv_mux = ((wait_state[4] || wait_state[5]) ? inv_discrepancy : discrepancy_reg);\n");
		
	fprintf (stdout,"// update the order and correction poly\n");
	fprintf (stdout,"always @(*) begin\n");
	fprintf (stdout,"  if ((|discrepancy_reg) && ((order_in << 1) < step)) begin\n");
	fprintf (stdout,"    order_out = step - order_in;\n");
	fprintf (stdout,"    correction_out = {elp_div_disc_reg[%d:%d],%d'b0};\n",
			symbol_size*2*t-1-symbol_size,
			0,
			symbol_size);
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"    order_out = order_in;\n");
	fprintf (stdout,"    correction_out = {correction_in[%d:%d],%d'b0} ;\n",
			symbol_size*2*t-1-symbol_size,
			0,
			symbol_size);
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"endmodule\n");
}

///////////////////////////////////////////

void build_error_loc_poly_roots (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	int powers = 0;

	int i = 0;

	fprintf (stdout,"\n///////////////////////////////////////////\n");
	fprintf (stdout,"// Error location poly root finder\n");
	fprintf (stdout,"///////////////////////////////////////////\n\n");
	
	fprintf (stdout,"// Fixable problems will have the degree of the ELP\n");
	fprintf (stdout,"// less than or equal to t (%d)\n",t);
	fprintf (stdout,"// This is using the Chien search method\n");
	fprintf (stdout,"module error_loc_poly_roots (elp_in,elp_out,match);\n");
	fprintf (stdout,"input [%d:0] elp_in;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"output [%d:0] elp_out;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"output match;\n\n");

	fprintf (stdout,"wire [%d:0] q;\n",symbol_size-1);
	
	powers = 1;
	for (i=0; i<=t; i++)
	{
		fprintf (stdout,"  gf_mult_by_%02x rp%d (.i(elp_in[%d:%d]),.o(elp_out[%d:%d]));\n",
			powers,
			i,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size);

		powers = gf_mult (symbol_size,powers,2,mod_poly);
	}
	fprintf (stdout,"\n");
	
	fprintf (stdout,"  assign q = \n");
	for (i=0; i<=t; i=i+1)
	{
		fprintf (stdout,"   elp_out [%d:%d]",
			(i+1)*symbol_size-1,i*symbol_size);
		if (i != t) 
		{
			fprintf (stdout," ^");
		}			
		fprintf (stdout,"\n");
	}
	fprintf (stdout,";\n\n");

	fprintf (stdout,"assign match = ~|q;\n\n");

	fprintf (stdout,"endmodule\n");
	
}

///////////////////////////////////////////

void build_error_mag_poly (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	
	int i = 0;
	int mult_num = 0;

	fprintf (stdout,"\n///////////////////////////////////////////\n");
	fprintf (stdout,"// Error magnitude poly computation\n");
	fprintf (stdout,"///////////////////////////////////////////\n\n");
	
	fprintf (stdout,"module error_mag_poly_round (step_elp,syndrome,emp_term);\n");
	fprintf (stdout,"input [%d:0] step_elp;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"input [%d:0] syndrome;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"output [%d:0] emp_term;\n",symbol_size-1);
	
	fprintf (stdout,"wire [%d:0] mag_mult;\n",symbol_size*(t+1)-1);
	for (i=0; i<=t; i=i+1)
	{
		fprintf (stdout,"gf_mult m%d (.a(step_elp[%d:%d]),.b(syndrome[%d:%d]),.o(mag_mult[%d:%d]));\n",
			mult_num,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size
		);
		mult_num++;
	}

	fprintf (stdout,"\nassign emp_term = \n");
	for (i=0; i<=t; i=i+1)
	{
		fprintf (stdout,"    mag_mult [%d:%d]",
			(i+1)*symbol_size-1,i*symbol_size);
		if (i != t) 
		{
			fprintf (stdout," ^");
		}			
		fprintf (stdout,"\n");
	}
	fprintf (stdout,";\n\n");

	fprintf (stdout,"endmodule\n\n");
}

///////////////////////////////////////////

void build_error_value (
	int symbol_size,
	int data_symbols,
	int mod_poly
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	int powers = 0;

	int i = 0;

	fprintf (stdout,"\n///////////////////////////////////////////\n");
	fprintf (stdout,"// Error Value computation\n");
	fprintf (stdout,"///////////////////////////////////////////\n\n");
	
	fprintf (stdout,"// deriv_term is ELP'(alpha^-j) / alpha^j\n");
	fprintf (stdout,"// error position indicates symbols with actual errors\n");
	fprintf (stdout,"// error_value will have the invert pattern to correct bad symbols\n");
	fprintf (stdout,"module error_value_round (emp_in,emp_out,deriv_term,error_pos,error_val);\n");
	fprintf (stdout,"input [%d:0] emp_in;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"output [%d:0] emp_out;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"input [%d:0] deriv_term;\n",symbol_size-1);
	fprintf (stdout,"input error_pos;\n");
	fprintf (stdout,"output [%d:0] error_val;\n\n",symbol_size-1);

	fprintf (stdout,"wire [%d:0] q,r;\n",symbol_size-1);
	
	powers = 1;
	for (i=0; i<=t; i++)
	{
		fprintf (stdout,"  gf_mult_by_%02x rp%d (.i(emp_in[%d:%d]),.o(emp_out[%d:%d]));\n",
			powers,
			i,
			(i+1)*symbol_size-1,i*symbol_size,
			(i+1)*symbol_size-1,i*symbol_size);

		powers = gf_mult (symbol_size,powers,2,mod_poly);
	}
	fprintf (stdout,"\n");
	
	fprintf (stdout,"  assign q = \n");
	for (i=0; i<=t; i=i+1)
	{
		fprintf (stdout,"   emp_out [%d:%d]",
			(i+1)*symbol_size-1,i*symbol_size);
		if (i != t) 
		{
			fprintf (stdout," ^");
		}			
		fprintf (stdout,"\n");
	}
	fprintf (stdout,";\n\n");

	fprintf (stdout,"// r will be the correction if the symbol is actually\n");
	fprintf (stdout,"// wrong, and garbage if it's correct.  Apply as appro\n");
	fprintf (stdout,"gf_divide evd (.n(q),.d(deriv_term),.o(r));\n\n");

	fprintf (stdout,"assign error_val = {%d{error_pos}} & r;\n\n",symbol_size);

	fprintf (stdout,"endmodule\n");
	
}

///////////////////////////////////////////

void build_flat_decoder (
	int symbol_size,
	int data_symbols
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;

	int i=0;
	int h = 0; 
	bool first = true;

	fprintf (stdout,"\n//////////////////////////////////////////////\n");
	fprintf (stdout,"// Complete decoder - no latency version\n");
	fprintf (stdout,"\n//////////////////////////////////////////////\n");
	fprintf (stdout,"module flat_decoder(rx_data,rx_data_corrected);\n\n");
	
	fprintf (stdout,"input [%d:0] rx_data;\n",symbol_size*n-1);
	fprintf (stdout,"output [%d:0] rx_data_corrected;\n\n",symbol_size*n-1);
	
	fprintf (stdout,"wire [%d:0] syndrome;\n",symbol_size*2*t-1);
	fprintf (stdout,"syndrome_flat syn (.rx_data(rx_data),.syndrome(syndrome));\n\n");
	
	fprintf (stdout,"//////////////////////////////\n");
	fprintf (stdout,"// build error location poly\n");
	fprintf (stdout,"//////////////////////////////\n");

	for (i=0; i<=2*t; i++)
	{
		fprintf (stdout,"wire [%d:0] order_%d;\n",log_2(2*t-1)-1,i);
		fprintf (stdout,"wire [%d:0] elp_%d;\n",2*t*symbol_size-1,i);
		fprintf (stdout,"wire [%d:0] step_syn_%d;\n",2*t*symbol_size-1,i);
		fprintf (stdout,"wire [%d:0] correction_%d;\n",2*t*symbol_size-1,i);
	}
	
	fprintf (stdout,"\nassign order_0 = 0;\n");
	fprintf (stdout,"assign correction_0 = 1 << %d;\n",symbol_size);
	fprintf (stdout,"assign step_syn_0 = syndrome[%d:0];\n",symbol_size-1);
	fprintf (stdout,"assign elp_0 = 1;\n\n");

	for (i=0; i<2*t; i++)
	{
		if (i!=0)
		{
			fprintf (stdout,"assign step_syn_%d = {step_syn_%d,syndrome[%d:%d]};\n",
				i,i-1,(i+1)*symbol_size-1,i*symbol_size);
		}

		fprintf (stdout,"error_loc_poly_round r%d (.step(%d),.order_in(order_%d),\n",i,i+1,i);
		fprintf (stdout,"   .order_out(order_%d),.elp_in(elp_%d),.elp_out(elp_%d),\n",
				i+1,i,i+1);
		fprintf (stdout,"   .step_syndrome(step_syn_%d),\n",i);
		fprintf (stdout,"   .correction_in(correction_%d),.correction_out(correction_%d));\n\n",
				i,i+1);
	}

	fprintf (stdout,"wire [%d:0] elp;\n",2*t*symbol_size-1);
	fprintf (stdout,"assign elp = elp_%d;\n\n",2*t);
	
	for (i=0; i<=t+1; i++)
	{
		fprintf (stdout,"wire [%d:0] step_elp_%d;\n",(t+1)*symbol_size-1,i);
	}

	fprintf (stdout,"//////////////////////////////\n");
	fprintf (stdout,"// build error mag poly\n");
	fprintf (stdout,"//////////////////////////////\n");

	fprintf (stdout,"wire [%d:0] emp;\n\n",(t+1)*symbol_size-1);
	fprintf (stdout,"assign step_elp_0 = elp[%d:0];\n",symbol_size-1);
	
	for (i=0; i<=t; i++)
	{
		if (i!=0)
		{
			fprintf (stdout,"assign step_elp_%d = {step_elp_%d,elp[%d:%d]};\n",
				i,i-1,(i+1)*symbol_size-1,i*symbol_size);
		}

		fprintf (stdout,"error_mag_poly_round m%d (.step_elp(step_elp_%d),\n",i,i);
		fprintf (stdout,"    .syndrome(syndrome),.emp_term(emp[%d:%d]));\n\n",
			(i+1)*symbol_size-1,i*symbol_size);		
	}

	fprintf (stdout,"//////////////////////////////\n");
	fprintf (stdout,"// Find roots of ELP\n");
	fprintf (stdout,"//////////////////////////////\n\n");

	fprintf (stdout,"wire [%d:0] root_match;\n",n-1);
	fprintf (stdout,"wire [%d:0] elprt_0 = elp[%d:0];\n",
		symbol_size*(t+1)-1,symbol_size*(t+1)-1);

	for (i=0;i<n;i++)
	{
		fprintf (stdout,"wire [%d:0] elprt_%d;\n",symbol_size*(t+1)-1,i+1);
		fprintf (stdout,"error_loc_poly_roots elpr%d (.elp_in(elprt_%d),\n",i,i);
		fprintf (stdout,"     .elp_out(elprt_%d),.match(root_match[%d]));\n\n",i+1,i);
	}

	fprintf (stdout,"//////////////////////////////\n");
	fprintf (stdout,"// Find the correction values\n");
	fprintf (stdout,"//////////////////////////////\n\n");

	fprintf (stdout,"wire [%d:0] val_emp_0 = emp[%d:0];\n",
		symbol_size*(t+1)-1,symbol_size*(t+1)-1);
	fprintf (stdout,"wire [%d:0] error_val;\n\n",symbol_size*n-1);

	for (i=0;i<n;i++)
	{
		fprintf (stdout,"wire [%d:0] val_emp_%d;\n",symbol_size*(t+1)-1,i+1);
		fprintf (stdout,"wire [%d:0] sum_of_odds_%d =\n",symbol_size-1,i+1);
		first = true;	
		for (h=symbol_size; h<symbol_size*(t+1); h+=(2*symbol_size))
		{
			if (!first) fprintf (stdout," ^\n");
			fprintf (stdout,"     elprt_%d[%d:%d]",i+1,h+symbol_size-1,h);
			first = false;
		}
		fprintf (stdout,";\n\n");

		fprintf (stdout,"error_value_round evr%d (.emp_in(val_emp_%d),\n",i,i);
		fprintf (stdout,"     .emp_out(val_emp_%d),\n",i+1);
		fprintf (stdout,"     .deriv_term(sum_of_odds_%d),\n",i+1);
		fprintf (stdout,"     .error_pos(root_match[%d]),\n",i);
		fprintf (stdout,"     .error_val(error_val[%d:%d]));\n\n",
							symbol_size*(i+1)-1,symbol_size*i);
	}

	fprintf (stdout,"//////////////////////////////\n");
	fprintf (stdout,"// Apply correction values\n");
	fprintf (stdout,"//////////////////////////////\n\n");

	for (i=0;i<n;i++)
	{
		fprintf (stdout,"assign rx_data_corrected[%d:%d] = rx_data[%d:%d] ^ error_val[%d:%d];\n",
			symbol_size*(i+1)-1,symbol_size*i,
			symbol_size*(i+1)-1,symbol_size*i,
			symbol_size*((n-1-i)+1)-1,symbol_size*(n-1-i)
		);
	}
	
	fprintf (stdout,"endmodule\n");
}


///////////////////////////////////////////

void build_flat_decoder_tb (
	int symbol_size,
	int data_symbols
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;

	fprintf (stdout,"\n///////////////////////////////////////////\n\n");
	
	fprintf (stdout,"module flat_decoder_tb ();\n");
	fprintf (stdout,"reg [%d:0] din;\n",symbol_size-1);
	fprintf (stdout,"reg clk,rst,first_din;\n");
	fprintf (stdout,"wire [%d:0] parity;\n",symbol_size*2*t-1);
	fprintf (stdout,"reg [%d:0] tx_buffer;\n",k*symbol_size-1);
	fprintf (stdout,"wire [%d:0] tx_data = {tx_buffer,parity};\n",n*symbol_size-1);
	fprintf (stdout,"reg [%d:0] err;\n",n*symbol_size-1);
	fprintf (stdout,"wire [%d:0] rx_data = tx_data ^ err;\n",n*symbol_size-1);

	fprintf (stdout,"wire [%d:0] rx_data_corrected;\n\n",symbol_size*n-1);
	
	fprintf (stdout,"encoder enc (.clk(clk),.ena(1'b1),.rst(rst),.shift(1'b0),.first_din(first_din),.din(din),.parity(parity));\n\n");
	fprintf (stdout,"flat_decoder fd (.rx_data(rx_data),.rx_data_corrected(rx_data_corrected));\n\n");
	
	fprintf (stdout,"initial begin\n");
	fprintf (stdout,"  clk = 0;\n");
	fprintf (stdout,"  rst = 0;\n");
	fprintf (stdout,"  first_din = 1'b1;\n");
	fprintf (stdout,"  #10 rst = 1;\n");
	fprintf (stdout,"  #10 rst = 0;\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"always begin\n");
	fprintf (stdout,"  #1000 clk = ~clk;\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"always @(negedge clk) begin\n");
	fprintf (stdout,"  din = $random;\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"  tx_buffer = (tx_buffer << %d) | din;\n",symbol_size);
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"integer i;\n");
	fprintf (stdout,"initial begin\n");
	fprintf (stdout,"  #100\n");
	fprintf (stdout,"  @(negedge clk);\n");
	fprintf (stdout,"  err = 0;\n");
	fprintf (stdout,"  first_din = 1'b1;\n");
	fprintf (stdout,"  @(posedge clk);\n");
	fprintf (stdout,"  @(negedge clk);\n");
	fprintf (stdout,"  first_din = 1'b0;\n");
	fprintf (stdout,"  for (i=0; i<%d; i=i+1) begin\n",k-1);
	fprintf (stdout,"    @(posedge clk);\n");
	fprintf (stdout,"    @(negedge clk);\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  $display (\"tx data %%x\",tx_data);\n");
	fprintf (stdout,"  $display (\"  correct rx data %%x\",rx_data);\n");
	fprintf (stdout,"  $display (\"    rx_data_corrected %%x\",rx_data_corrected);\n");
	fprintf (stdout,"  if (rx_data_corrected !== tx_data) begin\n");
	fprintf (stdout,"    $display (\"Error : correct data was fixed incorrectly?\");\n");
	fprintf (stdout,"    $stop();\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  #1 err = 1'b1;\n");
	fprintf (stdout,"  for (i=0; i<%d; i=i+1) begin\n",n*symbol_size);
	fprintf (stdout,"    #1\n");
	fprintf (stdout,"    $display (\"  rx data with error%%x\",rx_data);\n");
	fprintf (stdout,"    $display (\"    rx_data_corrected %%x\",rx_data_corrected);\n");
	fprintf (stdout,"    if (rx_data_corrected !== tx_data) begin\n");
	fprintf (stdout,"      $display (\"Error : data was not corrected\");\n");
	fprintf (stdout,"      $stop();\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"    err = err << 1;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  $display (\"PASS\");\n");
	fprintf (stdout,"  $stop();\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"endmodule\n");

}	

///////////////////////////////////////

void build_reed_sol_tx (
	int symbol_size,
	int data_symbols
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;

	fprintf (stdout,"\n///////////////////////////////////////////\n");
	fprintf (stdout,"// Iterative TX unit\n");
	fprintf (stdout,"///////////////////////////////////////////\n\n");
		
	fprintf (stdout,"module reed_sol_tx (\n");
	fprintf (stdout,"   clk,rst,\n");
	fprintf (stdout,"   first_din,din,din_valid,ready_for_din,\n");
	fprintf (stdout,"   dout,dout_valid\n");
	fprintf (stdout,");\n\n");

	fprintf (stdout,"input clk,rst;\n");
	fprintf (stdout,"input first_din;  // 1 for the first symbol of each word\n");
	fprintf (stdout,"input [%d:0] din; // most significant symbol first\n",
			symbol_size-1);
	fprintf (stdout,"input din_valid;		// din data is valid\n");
	fprintf (stdout,"output ready_for_din;  // din will be accepted\n");
	fprintf (stdout,"output [%d:0] dout;        // TX data out\n",symbol_size-1);
	fprintf (stdout,"output dout_valid;         // TX data is valid\n");
	fprintf (stdout,"\n");
	
	
	fprintf (stdout,"reg [%d:0] dout;\n",symbol_size-1);
	fprintf (stdout,"reg dout_valid,ready_for_din;\n\n");
	
	fprintf (stdout,"reg [%d:0] symbol_cntr;\n\n",log_2(n-1)-1);
	
	fprintf (stdout,"wire enc_ena;\n");
	fprintf (stdout,"wire [%d:0] parity;\n\n",2*t*symbol_size-1);
	
	fprintf (stdout,"assign enc_ena = !ready_for_din | din_valid;\n");
	fprintf (stdout,"encoder enc (.clk(clk),.rst(rst),.ena(enc_ena),.shift(!ready_for_din),\n");
	fprintf (stdout,"   .first_din(first_din),.din(din),.parity(parity));\n\n");
	
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) begin\n");
	fprintf (stdout,"      symbol_cntr <= 0;\n");
	fprintf (stdout,"      ready_for_din <= 1'b1;\n");
	fprintf (stdout,"      dout_valid <= 1'b0;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"      if (ready_for_din) begin\n");
	fprintf (stdout,"          if (din_valid) begin\n");
	fprintf (stdout,"              // Pass the data symbols along\n");
	fprintf (stdout,"              dout <= din;\n");
	fprintf (stdout,"              dout_valid <= 1'b1;\n");
	fprintf (stdout,"              symbol_cntr <= symbol_cntr + 1'b1;\n");
	fprintf (stdout,"              if (symbol_cntr == %d) begin\n",k-1);
	fprintf (stdout,"                 // data is complete, start sending parity next\n");
	fprintf (stdout,"                 ready_for_din <= 1'b0;\n");
	fprintf (stdout,"              end\n");
	fprintf (stdout,"          end\n");
	fprintf (stdout,"          else begin\n");
	fprintf (stdout,"              // I want more data, it's not available yet\n");
	fprintf (stdout,"              dout_valid <= 1'b0;\n");
	fprintf (stdout,"          end\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"      else begin\n");
	fprintf (stdout,"          // Send the parity symbols\n");
	fprintf (stdout,"          symbol_cntr <= symbol_cntr + 1'b1;\n");
	fprintf (stdout,"          dout <= parity[%d:%d];\n",
									2*t*symbol_size-1,2*t*symbol_size-symbol_size);
	fprintf (stdout,"          dout_valid <= 1'b1;\n");
	fprintf (stdout,"          if (symbol_cntr == %d) begin\n",n-1);
	fprintf (stdout,"              // parity almost complete, request more data\n");
	fprintf (stdout,"              ready_for_din <= 1'b1;\n");
	fprintf (stdout,"              symbol_cntr <= 0;\n");
	fprintf (stdout,"          end\n");
	fprintf (stdout,"      end\n");	
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n");	

	fprintf (stdout,"endmodule\n");	

}

///////////////////////////////////////

void build_reed_sol_rx (
	int symbol_size,
	int data_symbols
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;
	
	int h = 0;
	bool first = true;

	fprintf (stdout,"\n///////////////////////////////////////////\n");
	fprintf (stdout,"// Iterative RX unit\n");
	fprintf (stdout,"///////////////////////////////////////////\n\n");
	
	fprintf (stdout,"module reed_sol_rx (\n");
	fprintf (stdout,"   clk,rst,\n");
	fprintf (stdout,"   first_din,din,din_valid,ready_for_din,\n");
	fprintf (stdout,"   dout,dout_valid,corrected_bits,failure\n");
	fprintf (stdout,");\n\n");

	fprintf (stdout,"input clk,rst;\n");
	fprintf (stdout,"input first_din;  // 1 for the first symbol of each word\n");
	fprintf (stdout,"input [%d:0] din; // most significant symbol first\n",
			symbol_size-1);
	fprintf (stdout,"input din_valid;		  // din data is valid\n");
	fprintf (stdout,"output ready_for_din;    // din will be accepted\n");
	fprintf (stdout,"output [%d:0] dout;        // Corrected data out\n",symbol_size-1);
	fprintf (stdout,"output dout_valid;         // data out available\n");
	fprintf (stdout,"output [%d:0] corrected_bits;   // bits changed to fix dout\n",symbol_size-1);
	fprintf (stdout,"output failure;            // too many errors to correct this symbol\n");
	
	fprintf (stdout,"\n");
	
	
	fprintf (stdout,"reg [%d:0] dout;\n",symbol_size-1);
	fprintf (stdout,"reg [%d:0] corrected_bits;\n",symbol_size-1);
	fprintf (stdout,"reg dout_valid,ready_for_din,failure;\n\n");
	
	fprintf (stdout,"reg [%d:0] symbol_cntr;\n\n",log_2(n-1)-1);
	
	fprintf (stdout,"/////////////////////////////////\n");
	fprintf (stdout,"// syndrome computation\n");
	fprintf (stdout,"/////////////////////////////////\n");
	fprintf (stdout,"reg [%d:0] syndrome;\n",2*t*symbol_size-1);
	fprintf (stdout,"wire [%d:0] next_syndrome;\n",2*t*symbol_size-1);
	fprintf (stdout,"reg syndrome_ready,leading_syndrome_ready;\n\n");

	fprintf (stdout,"wire syndrome_ena = ready_for_din & din_valid;\n");
	fprintf (stdout,"syndrome_round sr (.rx_data (din),\n");
	fprintf (stdout,"       .syndrome_in(first_din ? %d'b0 : syndrome),\n",2*t*symbol_size);
	fprintf (stdout,"       .syndrome_out(next_syndrome),\n");
	fprintf (stdout,"       .skip_mult(leading_syndrome_ready)\n");
	fprintf (stdout,");\n\n");
	
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) begin\n");
	fprintf (stdout,"    syndrome <= %d'b0;\n",2*t*symbol_size);
	fprintf (stdout,"    syndrome_ready <= 1'b0;\n");
	fprintf (stdout,"    leading_syndrome_ready <= 1'b0;\n");
	fprintf (stdout,"    symbol_cntr <= 0;\n");
	fprintf (stdout,"    ready_for_din <= 1'b1;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"    if (syndrome_ena) begin\n");
	fprintf (stdout,"        syndrome <= next_syndrome;\n");
	fprintf (stdout,"        if (symbol_cntr == %d) begin\n",n-1);
	fprintf (stdout,"            // syndrome is complete\n");
	fprintf (stdout,"            // accept more immediately, and signal syn ready\n");
	fprintf (stdout,"            ready_for_din <= 1'b1;\n");
	fprintf (stdout,"            syndrome_ready <= 1'b1;\n");
	fprintf (stdout,"            leading_syndrome_ready <= 1'b0;\n");
	fprintf (stdout,"            symbol_cntr <= 0;\n");
	fprintf (stdout,"        end\n");
	fprintf (stdout,"        else begin\n");
	fprintf (stdout,"            if (symbol_cntr == %d) begin\n",n-2);
	fprintf (stdout,"               leading_syndrome_ready <= 1'b1;\n");
	fprintf (stdout,"            end\n");
	fprintf (stdout,"            symbol_cntr <= symbol_cntr + 1'b1;\n");
	fprintf (stdout,"            syndrome_ready <= 1'b0;\n");
	fprintf (stdout,"        end\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	
	fprintf (stdout,"////////////////////////////////////////\n");
	fprintf (stdout,"// Error location poly computation\n");
	fprintf (stdout,"////////////////////////////////////////\n\n");

	fprintf (stdout,"reg [%d:0] step;\n",log_2(2*t)-1);
	fprintf (stdout,"reg [%d:0] order;\n",log_2(2*t-1)-1);
	fprintf (stdout,"wire [%d:0] next_order;\n",log_2(2*t-1)-1);
	fprintf (stdout,"reg [%d:0] elp;\n",symbol_size*2*t-1);
	fprintf (stdout,"wire [%d:0] next_elp;\n",symbol_size*2*t-1);
	fprintf (stdout,"reg [%d:0] step_syndrome;\n",symbol_size*2*t-1);
	fprintf (stdout,"reg [%d:0] saved_syndrome;\n",symbol_size*2*t-1);
	fprintf (stdout,"reg [%d:0] correction;\n",symbol_size*2*t-1);
	fprintf (stdout,"wire [%d:0] next_correction;\n\n",symbol_size*2*t-1);
	fprintf (stdout,"wire elp_ena = 1'b1;\n");
	fprintf (stdout,"reg last_syndrome_ready;\n");
	fprintf (stdout,"reg elp_ready;\n");
	fprintf (stdout,"reg first_elp;\n");
	fprintf (stdout,"wire final_elp = (step == %d) ? 1'b1 : 1'b0;\n",2*t);

	fprintf (stdout,"wire elpr_wait;\n\n");
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) first_elp <= 1'b0;\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"    if (leading_syndrome_ready) first_elp <= 1'b1;\n");
	fprintf (stdout,"    else if (!elpr_wait) first_elp <= 1'b0;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"error_loc_poly_round_multi_step elpr (\n");
	fprintf (stdout,"    .step(step),\n",log_2(2*t));
	fprintf (stdout,"    .order_in(order),\n",log_2(2*t-1));
	fprintf (stdout,"    .order_out(next_order),\n");
	fprintf (stdout,"    .elp_in(elp),\n",symbol_size*2*t);
	fprintf (stdout,"    .elp_out(next_elp),\n");
	fprintf (stdout,"    .step_syndrome(step_syndrome),\n");
	fprintf (stdout,"    .correction_in(correction),\n");
	fprintf (stdout,"    .clk(clk),.rst(rst),.sync(leading_syndrome_ready),\n");
	fprintf (stdout,"    .elpr_wait(elpr_wait),\n");
	fprintf (stdout,"    .correction_out(next_correction));\n");
	
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) begin\n");
	fprintf (stdout,"      step <= 0;\n");
	fprintf (stdout,"      order <= 0;\n");
	fprintf (stdout,"      correction <= 0;\n");
	fprintf (stdout,"      step_syndrome <= 0;\n");
	fprintf (stdout,"      elp_ready <= 1'b0;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else if (elp_ena) begin\n");
	fprintf (stdout,"      if (leading_syndrome_ready) begin\n");
	fprintf (stdout,"         step <= 1;\n");
	fprintf (stdout,"         order <= 0;\n");
	fprintf (stdout,"         correction <= {%d'b1,%d'b0};\n",
								symbol_size*2*t-symbol_size,symbol_size);
	fprintf (stdout,"         elp <= %d'b1;\n",symbol_size*2*t);
	fprintf (stdout,"         step_syndrome <= {%d'b0,next_syndrome[%d:0]};\n",
								symbol_size*(2*t-1),symbol_size-1);
	fprintf (stdout,"         elp_ready <= 1'b0;\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"      else if (!elpr_wait & first_elp) begin\n");
	fprintf (stdout,"         saved_syndrome <= syndrome;\n");
	fprintf (stdout,"         step_syndrome <= {%d'b0,syndrome[%d:0],syndrome[%d:%d]};\n",
								2*t*symbol_size - (2*symbol_size),
								symbol_size-1,
								2*symbol_size-1,
								symbol_size);
	fprintf (stdout,"         step <= 2;\n");
	fprintf (stdout,"         correction <= next_correction;\n");
	fprintf (stdout,"         order <= next_order;\n");
	fprintf (stdout,"         elp <= next_elp;\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"      else if (!elpr_wait & !elp_ready) begin\n");
	fprintf (stdout,"         step <= step + 1'b1;\n");
	fprintf (stdout,"         step_syndrome <= {step_syndrome[%d:0],saved_syndrome[%d:%d]};\n",
								2*t*symbol_size - 1 - symbol_size,
								symbol_size*3-1,
								symbol_size*2);
	fprintf (stdout,"         saved_syndrome <= {saved_syndrome [%d:0],saved_syndrome[%d:%d]};\n",
								symbol_size-1,
								2*t*symbol_size-1,
								symbol_size);
	fprintf (stdout,"         correction <= next_correction;\n");
	fprintf (stdout,"         order <= next_order;\n");
	fprintf (stdout,"         elp <= next_elp;\n");
	fprintf (stdout,"         if (final_elp) elp_ready <= 1'b1;\n",2*t);
	fprintf (stdout,"      end\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"/////////////////////////////////////////////\n");
	fprintf (stdout,"// Error magnitude poly computation\n");
	fprintf (stdout,"//   error mag poly has terms 0..v-1 for v errors\n");
	fprintf (stdout,"//   derived from the syndrome (S0..Sv-1) and \n");
	fprintf (stdout,"//   the ELP (0..v-1)\n");
	fprintf (stdout,"/////////////////////////////////////////////\n\n");
	
	fprintf (stdout,"reg [%d:0] step_elp;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"reg [%d:0] elp_mirror;\n",symbol_size*2*t-1);
	fprintf (stdout,"wire [%d:0] emp_term;\n",symbol_size-1);
	fprintf (stdout,"reg [%d:0] emp;\n",symbol_size*t-1);
	fprintf (stdout,"reg emp_ready;\n");
	fprintf (stdout,"wire emp_ena = 1'b1;\n");
	fprintf (stdout,"reg [%d:0] emp_cntr;\n\n",log_2(t)-1);
	fprintf (stdout,"wire final_emp = (emp_cntr == %d) ? 1'b1 : 1'b0;\n",t-1);

	fprintf (stdout,"error_mag_poly_round empr (\n");
	fprintf (stdout,"    .step_elp(step_elp),\n");
	fprintf (stdout,"    .syndrome(saved_syndrome[%d:%d]),\n",
							symbol_size*(t+1)-1+symbol_size,
							symbol_size);
	fprintf (stdout,"    .emp_term(emp_term));\n\n");
	
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) begin\n");
	fprintf (stdout,"      emp <= 0;\n");
	fprintf (stdout,"      emp_ready <= 0;\n");
	fprintf (stdout,"      step_elp <= 0;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else if (emp_ena) begin\n");
	fprintf (stdout,"      if (final_elp) begin\n");
	fprintf (stdout,"         // mirror the low ELP register during the last ELP computation\n");
	fprintf (stdout,"         elp_mirror <= next_elp[%d:0];\n",
								symbol_size*(t+1)-1);
	fprintf (stdout,"         step_elp <= {%d'b0,next_elp[%d:0]};\n",
								symbol_size*(t+1)-symbol_size,
								symbol_size-1);
	fprintf (stdout,"         emp_ready <= 1'b0;\n");
	fprintf (stdout,"         emp_cntr <= 0;\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"      else if (!emp_ready) begin\n");
	fprintf (stdout,"         emp_cntr <= emp_cntr + 1'b1;\n");
	fprintf (stdout,"         step_elp <= {step_elp[%d:0],elp_mirror[%d:%d]};\n",
								symbol_size*(t+1)-symbol_size-1,
								2*symbol_size-1,
								symbol_size);
	fprintf (stdout,"         elp_mirror <= elp_mirror >> %d;\n",symbol_size);
	fprintf (stdout,"         if (final_emp) emp_ready <= 1'b1;\n",t-1);
	fprintf (stdout,"         emp <= {emp_term,emp[%d:%d]};\n",
								symbol_size*t-1,symbol_size);
	fprintf (stdout,"      end\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"///////////////////////////////////////////////\n");
	fprintf (stdout,"// ELP Roots (bad symbols in the word)\n");
	fprintf (stdout,"// and Error values (bad bits in the symbol)\n");
	fprintf (stdout,"///////////////////////////////////////////////\n\n");

	fprintf (stdout,"reg [%d:0] root_step_elp;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"wire [%d:0] next_root_step_elp;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"wire root_match;\n");
	fprintf (stdout,"reg last_root_match;\n");
	fprintf (stdout,"reg last_emp_ready;\n");
	fprintf (stdout,"reg [%d:0] root_cntr;\n",log_2(k)-1);
	fprintf (stdout,"reg roots_pending;\n");
	fprintf (stdout,"wire root_ena = 1'b1;\n\n");
	
	fprintf (stdout,"// generate a pulse when the new EMP is available\n");
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) last_emp_ready <= 1'b0;\n");
	fprintf (stdout,"  else last_emp_ready <= emp_ready;\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"// find the roots of the error location poly.\n");
	fprintf (stdout,"// The ELP will be stable before the EMP is ready\n");
	fprintf (stdout,"error_loc_poly_roots root (\n");
	fprintf (stdout,"    .elp_in(root_step_elp),\n");
	fprintf (stdout,"	 .elp_out(next_root_step_elp),\n");
	fprintf (stdout,"    .match(root_match));\n\n");

	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) begin\n");
	fprintf (stdout,"      last_root_match <= 0;\n");
	fprintf (stdout,"      root_step_elp <= 0;\n");
	fprintf (stdout,"      root_cntr <= 0;\n");
	fprintf (stdout,"      roots_pending <= 0;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else if (root_ena) begin\n");
	fprintf (stdout,"      if (final_emp) begin\n");
	fprintf (stdout,"         // while waiting for the the last EMP, load the ELP\n");
	fprintf (stdout,"         root_step_elp <= elp[%d:0];\n",
								symbol_size*(t+1)-1);
	fprintf (stdout,"         root_cntr <= 0;\n");
	fprintf (stdout,"         roots_pending <= 1'b1;\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"      else begin\n");
	fprintf (stdout,"         if (roots_pending) begin\n");
	fprintf (stdout,"             // Advancing through the roots...\n");
	fprintf (stdout,"             root_step_elp <= next_root_step_elp;\n");
	fprintf (stdout,"             if (root_cntr == %d) begin\n",n); //here
	fprintf (stdout,"                root_cntr <= 0;\n");
	fprintf (stdout,"                roots_pending <= 1'b0;\n");
	fprintf (stdout,"             end\n");
	fprintf (stdout,"             else begin\n");
	fprintf (stdout,"                root_cntr <= root_cntr + 1'b1;\n");
	fprintf (stdout,"             end\n");
	fprintf (stdout,"         end\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"      last_root_match <= root_match;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"reg [%d:0] step_emp;\n",symbol_size*(t+1)-1);
	fprintf (stdout,"wire [%d:0] next_step_emp;\n\n",symbol_size*(t+1)-1);
	
	fprintf (stdout,"// the derivitive term is equal to the sum of the \n");
	fprintf (stdout,"// odd terms of the working ELP from the root search\n");
	fprintf (stdout,"wire [%d:0] deriv_term =\n",symbol_size-1);
	first = true;	
	for (h=symbol_size; h<symbol_size*(t+1); h+=(2*symbol_size))
	{
		if (!first) fprintf (stdout," ^\n");
		fprintf (stdout,"     root_step_elp[%d:%d]",h+symbol_size-1,h);
		first = false;
	}
	fprintf (stdout,";\n\n");
	
	fprintf (stdout,"wire [%d:0] error_val;\n\n",symbol_size-1);

	fprintf (stdout,"// this is running 1 tick behind the root finder\n");
	fprintf (stdout,"// to use the root_match and derivitive output signals\n");
	fprintf (stdout,"error_value_round eval (\n");
	fprintf (stdout,"    .emp_in(step_emp),\n");
    fprintf (stdout,"    .emp_out(next_step_emp),\n");
	fprintf (stdout,"    .deriv_term(deriv_term),\n");
    fprintf (stdout,"    .error_pos(last_root_match),\n");
	fprintf (stdout,"    .error_val(error_val));\n\n");

	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) begin\n");
	fprintf (stdout,"      step_emp <= 0;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else if (root_ena) begin\n");
	fprintf (stdout,"      if (emp_ready & !last_emp_ready) begin\n");
	fprintf (stdout,"         step_emp <= emp;\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"      else begin\n");
	fprintf (stdout,"         step_emp <= next_step_emp;\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"///////////////////////////////////////////////\n");
	fprintf (stdout,"// Delay the data in and mix with the correction\n");
	fprintf (stdout,"// to form output\n");
	fprintf (stdout,"///////////////////////////////////////////////\n\n");

//	int delay_sym = n /*codeword*/ + t /*emp lag*/ + 3*2*t /*elp lag*/ + 3;
	int delay_sym = n /*codeword*/ + t /*emp lag*/ + 7*2*t /*elp lag*/ + 7;

	fprintf (stdout,"reg [%d:0] data_delay;\n",delay_sym*symbol_size-1);
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"  if (syndrome_ena) data_delay <= {din,data_delay[%d:%d]};\n",
			delay_sym*symbol_size-1,
			symbol_size);
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"// don't aclear the delay buffer, so it can go in RAM\n");
	fprintf (stdout,"// but do fix it for simulation\n");
	fprintf (stdout,"initial begin\n");
	fprintf (stdout,"  data_delay <= 0;\n");  
	fprintf (stdout,"end\n");
	
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"  if (rst) begin\n");
	fprintf (stdout,"      dout <= 1'b0;\n");
	fprintf (stdout,"      dout_valid <= 1'b0;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else begin\n");
	fprintf (stdout,"      if (| root_cntr) begin\n");
	fprintf (stdout,"        dout <= data_delay[%d:0] ^ error_val;\n",symbol_size-1);
	fprintf (stdout,"        corrected_bits <= error_val;\n");
	fprintf (stdout,"        dout_valid <= 1'b1;\n");
	fprintf (stdout,"      end\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"endmodule\n");	

}

///////////////////////////////////////

void build_reed_sol_tb (
	int symbol_size,
	int data_symbols
)
{
	int n = (1 << symbol_size) - 1;
	int k = data_symbols;
	int t = (n - k) / 2;

	fprintf (stdout,"\n///////////////////////////////////////////\n");
	fprintf (stdout,"// Iterative TX / RX testbench\n");
	fprintf (stdout,"///////////////////////////////////////////\n\n");
	
	fprintf (stdout,"module reed_sol_tb ();\n\n");
	
	fprintf (stdout,"reg clk,rst,tx_first_din;\n");
	fprintf (stdout,"reg [%d:0] tx_din;\n",symbol_size-1);
	fprintf (stdout,"wire [%d:0] tx_dout;\n",symbol_size-1);
	fprintf (stdout,"wire tx_dout_valid,tx_ready_for_din;\n");
	fprintf (stdout,"reg tx_din_valid;\n");
	fprintf (stdout,"reg [%d:0] line_noise;\n",n*symbol_size-1);
	fprintf (stdout,"integer bytes_sent,bytes_rxd;\n\n");
	
	fprintf (stdout,"   reed_sol_tx tx (\n");
	fprintf (stdout,"       .clk(clk),.rst(rst),\n");
	fprintf (stdout,"       .first_din(tx_first_din),.din(tx_din),.din_valid(tx_din_valid),\n");
	fprintf (stdout,"       .ready_for_din(tx_ready_for_din),\n");
	fprintf (stdout,"       .dout(tx_dout),.dout_valid(tx_dout_valid));\n\n");
	
	fprintf (stdout,"initial begin\n");
	fprintf (stdout,"  clk = 0;\n");
	fprintf (stdout,"  rst = 0;\n");
	fprintf (stdout,"  tx_din = 0;\n");
	fprintf (stdout,"  tx_din_valid = 1'b1;\n");
	fprintf (stdout,"  tx_first_din = 1'b1;\n");
	fprintf (stdout,"  bytes_sent = 0;\n");
	fprintf (stdout,"  bytes_rxd = 0;\n");
	fprintf (stdout,"  line_noise = {%d'b0,48'h00d0_0000_0200};\n",
						n*symbol_size-48);
	fprintf (stdout,"  #10 rst = 1;\n");
	fprintf (stdout,"  #10 rst = 0;\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"always begin\n");
	fprintf (stdout,"  #100 clk = ~clk;\n");
	fprintf (stdout,"end\n\n");
		
	fprintf (stdout,"reg [%d:0] original_msg;\n",k*symbol_size-1);
	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"   if (rst) begin\n");
	fprintf (stdout,"       original_msg <= 0;\n");
	fprintf (stdout,"       bytes_sent <= 0;\n");
	fprintf (stdout,"   end else begin\n");
	fprintf (stdout,"     if (tx_ready_for_din) begin\n");
	fprintf (stdout,"       original_msg <= (original_msg << %d) | tx_din;\n",symbol_size);
	fprintf (stdout,"       bytes_sent <= (bytes_sent + 1'b1) %% %d;\n",k);
	fprintf (stdout,"     end\n");
	fprintf (stdout,"   end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"always @(negedge clk) begin\n");
	fprintf (stdout,"  //tx_din = (tx_din+1'b1) %% %d;\n",n);
	fprintf (stdout,"  tx_din = $random;\n");
	fprintf (stdout,"  tx_first_din = ((bytes_sent == 0) ? 1'b1 : 1'b0);\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"reg rx_first_din;\n");
	fprintf (stdout,"wire [%d:0] rx_din;\n",symbol_size-1);
	fprintf (stdout,"wire [%d:0] rx_dout;\n",symbol_size-1);
	fprintf (stdout,"wire [%d:0] corrected_bits;\n",symbol_size-1);
	fprintf (stdout,"wire failure;\n");
	fprintf (stdout,"wire rx_dout_valid,rx_ready_for_din;\n");
	fprintf (stdout,"wire rx_din_valid;\n\n");

	fprintf (stdout,"// update the noise pattern\n");
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"  if (rx_din_valid) line_noise <= {line_noise[%d:0],line_noise[%d:%d]};\n",
						n*symbol_size-symbol_size,
						n*symbol_size-1,
						n*symbol_size-symbol_size);
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"// XOR in line noise for the RX end\n");
	fprintf (stdout,"assign rx_din = tx_dout ^ line_noise[%d:%d];\n",
						n*symbol_size-1,
						n*symbol_size-symbol_size);
	fprintf (stdout,"assign rx_din_valid = tx_dout_valid;\n");

	fprintf (stdout,"   reed_sol_rx rx (\n");
	fprintf (stdout,"       .clk(clk),.rst(rst),\n");
	fprintf (stdout,"       .first_din(rx_first_din),\n");
	fprintf (stdout,"       .din(rx_din),\n");
	fprintf (stdout,"       .din_valid(rx_din_valid),\n");
	fprintf (stdout,"       .ready_for_din(rx_ready_for_din),\n");
	fprintf (stdout,"       .dout(rx_dout),\n");
	fprintf (stdout,"       .dout_valid(rx_dout_valid),\n");
	fprintf (stdout,"       .corrected_bits(corrected_bits),\n");
	fprintf (stdout,"       .failure(failure)\n");
	fprintf (stdout,");\n\n");

	fprintf (stdout,"always @(posedge clk or posedge rst) begin\n");
	fprintf (stdout,"   if (rst) begin\n");
	fprintf (stdout,"       bytes_rxd <= 0;\n");
	fprintf (stdout,"   end else begin\n");
	fprintf (stdout,"     if (rx_ready_for_din && rx_din_valid) begin\n");
	fprintf (stdout,"       bytes_rxd <= (bytes_rxd + 1'b1) %% %d;\n",n);
	fprintf (stdout,"     end\n");
	fprintf (stdout,"   end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"reg [%d:0] recovered_msg;\n",n*symbol_size-1);
	fprintf (stdout,"integer bytes_recovered = 0;\n");
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"  if (rx_dout_valid) begin\n");
	fprintf (stdout,"     recovered_msg <= (recovered_msg << %d) | rx_dout;\n",symbol_size);
	fprintf (stdout,"     bytes_recovered <= (bytes_recovered + 1'b1) %% %d;\n",n);
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");
	
	fprintf (stdout,"always @(negedge clk) begin\n");
	fprintf (stdout,"  rx_first_din = ((bytes_rxd == 0) ? 1'b1 : 1'b0);\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"reg [%d:0] original_msg0;\n",k*symbol_size-1);
	fprintf (stdout,"reg [%d:0] original_msg1;\n",k*symbol_size-1);
	fprintf (stdout,"reg [%d:0] original_msg2;\n",k*symbol_size-1);
	
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"  if ((bytes_sent == 0) && tx_ready_for_din) begin\n");
	fprintf (stdout,"     $display (\"Sent %%x\",original_msg);\n");
	fprintf (stdout,"     original_msg0 <= original_msg;\n");
	fprintf (stdout,"     original_msg1 <= original_msg0;\n");
	fprintf (stdout,"     original_msg2 <= original_msg1;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  if (bytes_recovered == 0) begin\n");
	fprintf (stdout,"     $display (\"Recovered %%x \",recovered_msg);\n");
	fprintf (stdout,"     $display (\"  should be %%x\",original_msg1);\n");
	fprintf (stdout,"     if (recovered_msg[%d:%d] !== original_msg1) begin\n",
								n*symbol_size-1,(n-k)*symbol_size);
	fprintf (stdout,"        $display (\"MISMATCH\");\n");
	fprintf (stdout,"        $display (\"  pattern %%x\",original_msg1 ^ recovered_msg[%d:%d]);\n",
								n*symbol_size-1,(n-k)*symbol_size);
	fprintf (stdout,"     end else begin\n");
	fprintf (stdout,"        $display (\"OK\");\n");
	fprintf (stdout,"     end\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"end\n\n");

	fprintf (stdout,"endmodule\n");	
}

int main ()
{

	// Test
//	int symbol_size = 4;
//	int data_symbols = 9 ; // 11
//	int mod_poly = 19;

	// bigger test
//	int symbol_size = 6;
//	int data_symbols = 57;
//	int mod_poly = 67;

	// Digital Video
		int symbol_size = 8;
		int data_symbols = 239;
		int mod_poly = 285;

	fprintf (stdout,"// baeckler - 08-08-2006\n\n");

	// encoder
	build_encoder (symbol_size,data_symbols,mod_poly);

	// syndrome generator
	build_syndrome_flat (symbol_size,data_symbols,mod_poly);
	build_syndrome_round (symbol_size,data_symbols,mod_poly);
	build_syndrome_tb (symbol_size,data_symbols);

	// ELP / EMP / error value for correction
	build_gf_general_mult (symbol_size,mod_poly);
	build_gf_inverse (symbol_size,mod_poly);
	build_gf_divide (symbol_size);
	build_error_loc_poly (symbol_size,data_symbols,mod_poly);
	build_error_loc_poly_multi_step (symbol_size,data_symbols,mod_poly);
	build_error_loc_poly_roots (symbol_size,data_symbols,mod_poly);
	build_error_mag_poly (symbol_size,data_symbols,mod_poly);
	build_error_value (symbol_size,data_symbols,mod_poly);
	
	// combined decoder test unit
	build_flat_decoder (symbol_size,data_symbols);
	build_flat_decoder_tb (symbol_size,data_symbols);

	// TX with some state control
	build_reed_sol_tx (symbol_size,data_symbols);

	// TX with lots of state control
	build_reed_sol_rx (symbol_size,data_symbols);

	// overall test bench
	build_reed_sol_tb (symbol_size,data_symbols);
	
	// math components test bench
	build_gf_math_tb (symbol_size);

	return (0);
}
