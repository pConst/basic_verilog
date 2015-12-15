// Copyright 2008 Altera Corporation. All rights reserved.  
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
#include <string.h>
#include <stdlib.h>

int const num_lanes = 20;
int const meta_frame_len = 100;
int const lane_bits = 20;
char * lane_format = "%05I64X\n";

int const MAX_LINE = 1024;
typedef unsigned __int64 u64;

////////////////////////////////////////////////////////////////

void panic (const char * msg)
{
	fprintf (stdout,"PANIC: %s\n",msg);
	exit(1);
}

////////////////////////////////////////////////////////////////
// CRC32 - most significant bit first
u64 evolve_crc32_byte
(
	u64 crc_in,
	unsigned char data
)
{
	int k = 0;
	unsigned int fbk = 0;
	u64 const poly = 0x1edc6f41; // Castagnoli 32

	for (k=0; k<8; k++)
	{
		crc_in = crc_in << 1;
		if ((crc_in & 0x100000000) != 0)
		{
			crc_in ^= poly;
		}

		if (data & 0x80) 
		{
			crc_in ^= poly;
		}

		data <<= 1;
	}
	return (crc_in & 0xffffffff);
}

////////////////////////////////////////////////////////////////
// CRC 32 - evolve for 64 bits, ms byte first
u64 evolve_crc32_word
(
	u64 crc_in,
	u64 data
)
{
	int k = 0;
	unsigned char dbyte[8];

	for (k=0; k<8; k++)
	{
		dbyte [k] = unsigned char (data & 0xff);	
		data >>= 8;
	}

	for (k=7; k>=0; k--)
	{
		crc_in = evolve_crc32_byte (crc_in,dbyte[k]);
	}
	return (crc_in);
}

////////////////////////////////////////////////////////////////
// convert text into 8 byte hex words
void sample_text_to_words
(
	char * data_out_fname,
	int words_wanted
)
{
	FILE * g = NULL;
	const char * sample_data = "Mary had a little lamb its fleece was white"
			"as snow and everywhere that Mary went the lamb was sure to go."
			"  It followed her to school one day which was against the rule."
			"  All the children laughed and cheered to see a lamb at school."
			"  Humpty Dumpty sat on a wall.  Humpty Dumpty had a great fall."
			"  All the king's horses and all the king's men couldn't put "
			"Humpty together again. ";
	int const sample_data_len = strlen (sample_data);
	int n=0,k=0,z=0;

	g = fopen (data_out_fname,"wt");
	if (!g) panic ("Unable to write lane TX data");
	
	for (n=0; n<words_wanted; n++)
	{
		for (z=0; z<8; z++)
		{
			fprintf (g,"%02x",sample_data[k]);
			k = (k + 1)  % sample_data_len;
		}
		fprintf (g,"\n");
	}

	fclose (g);
}

////////////////////////////////////////////////////////////////
// sscanf doesn't seem to work on 64's
u64 scan64 (char * buffer)
{
	unsigned int dat_ls,dat_ms;
	int len = 0;
	u64 dat = 0;

	len = strlen(buffer);
	while (len > 0 &&
			(buffer[len-1] == 0xa ||
			buffer[len-1] == 0xd))
	{
		len--;
		buffer[len] = 0;
	}
	if (strlen (buffer) != 16) panic ("Expected 64 bit hex number");
	sscanf (&(buffer[8]),"%x",&dat_ls);
	buffer[8] = 0;
	sscanf (buffer,"%x",&dat_ms);
	dat = dat_ms;
	dat <<= 16;
	dat <<= 16;
	dat |= dat_ls;
	
	return (dat);
}

////////////////////////////////////////////////////////////////
// Insert Metaframe words, CRC32, scrambling on TX data stream
// From Interlaken 1.1 protocol doc
void lane_tx_frame 
(
	char * data_in_fname,
	char * data_out_fname,
	bool error_injection
)
//
// Error schedule : 1 - wait for lock, damage a sync word
//					2 - damage a sync word
//					3 - damage a sync word
//					4 - damage an expected CRC
//					5 - damage a skip word to cause CRC error
//					6 - damage expected scrambler state word, proper CRC
//					7 - damage a sync word
//					8 - damage a sync word
//					9 - mis-synchronize the scrambler 

{
	FILE * f = NULL;
	FILE * g = NULL;
	char buffer[MAX_LINE];
	int meta_cntr = 0;
	u64 dat = 0;
	u64 scrambler = 0x1234;
	u64 next_scrambler = 0;
	u64 crc32 = 0xffffffff;

	// error injection controls
	int words_written = 0;
	int error_schedule = 0;
	
	f = fopen (data_in_fname,"rt");
	if (!f) panic ("Unable to read lane TX data");
	g = fopen (data_out_fname,"wt");
	if (!g) panic ("Unable to write lane TX data");

	while (!feof(f))
	{
		// allow lock time before error injection
		if (error_injection && error_schedule == 0 && words_written > 2000) 
		{
			error_schedule = 1;
		}
			
		// unscrambled framing words
		if (meta_cntr == 0) 
		{
			// synchronization
			dat = 0x78f678f678f678f6;
			if (error_schedule == 1 || error_schedule == 2 || error_schedule == 3 ||
				error_schedule == 7 || error_schedule == 8)
			{
				dat ^= 0x666; // inject error
				error_schedule++;
			}			
			crc32 = evolve_crc32_word (crc32,dat);
			fprintf (g,"1 %016I64X\n",dat);
			words_written++;
			meta_cntr++;			
		}
		if (meta_cntr == 1)
		{
			if (error_schedule == 9)
			{
				scrambler = 0x666; // Change scrambler evolution
				error_schedule++;
			}

			// scrambler state
			dat = 0x2800000000000000;
			crc32 = evolve_crc32_word (crc32,dat);
			dat |= scrambler;

			if (error_schedule == 6)
			{
				dat ^= 0x666; // inject error
				error_schedule++;
			}

			fprintf (g,"1 ");
			fprintf (g,"%016I64X\n",dat);
			words_written++;
			meta_cntr++;
		}
		// continue on to next scrambled data

		// eval next scrambler state
		next_scrambler = 
					(scrambler << 6) ^
					(((scrambler >> 16) >> 16) >> 20) ^
					((scrambler & 0x7fffffffff) << 25) ^
					((scrambler & 0x7fffffffff) >> 14) ^
					(((scrambler & 0xffffff8000000000) >> 16) >> 17);
		
		if (meta_cntr == 2)
		{
			// skip word
			dat = 0x1e1e1e1e1e1e1e1e;
			crc32 = evolve_crc32_word (crc32,dat);
			
			if (error_schedule == 5)
			{
				dat ^= 0x666; // inject error, incorrect CRC
				error_schedule++;
			}
			
			// scramble
			dat ^= (scrambler << 6);
			dat ^= (((next_scrambler >> 16) >> 16) >> 26);
			fprintf (g,"1 %016I64X\n",dat);
			words_written++;
			meta_cntr++;
		}
		else if (meta_cntr == (meta_frame_len-1))
		{
			// diagnostic word	
			dat = 0x6400000000000000;
			crc32 = evolve_crc32_word (crc32,dat);
			
			// stick in CRC bits
			crc32 ^= 0xffffffff;
			dat |= crc32;

			if (error_schedule == 4)
			{
				dat ^= 0x666; // inject error
				error_schedule++;
			}			
			
			// scramble
			dat ^= (scrambler << 6);
			dat ^= (((next_scrambler >> 16) >> 16) >> 26);
			fprintf (g,"1 %016I64X\n",dat);
			words_written++;
			meta_cntr = 0;

			// crc start over
			crc32 = 0xffffffff;
		}
		else 
		{
			// payload word 
			if (fgets (buffer,sizeof(buffer),f))
			{
				dat = scan64(buffer);	
				crc32 = evolve_crc32_word (crc32,dat);
			
				// scramble the data
				dat ^= (scrambler << 6);
				dat ^= (((next_scrambler >> 16) >> 16) >> 26);
				fprintf (g,"0 %016I64X\n",dat);
				words_written++;
				meta_cntr++;
			}
		}
		// evolve the scrambler
		scrambler = next_scrambler & 0x03ffffffffffffff;								
	}

	fclose (f);
	fclose (g);
}

////////////////////////////////////////////////////////////////

int count_ones (u64 dat)
{
	int ones = 0;
	while (dat) 
	{
		if ((dat & 1) != 0)
		{
			ones++;
		}
		dat >>= 1;
	}
	return (ones);
}


////////////////////////////////////////////////////////////////
// apply 64-67 disparity encoding
void lane_tx_disparity
(
	char * data_in_fname,
	char * data_out_fname	
)
{
	FILE * f = NULL;
	FILE * g = NULL;
	u64 dat = 0;
	char buffer [MAX_LINE];
	int running_disparity = 0;
	int word_disparity = 0;
	int control_bits = 0;

	f = fopen (data_in_fname,"rt");
	if (!f) panic ("Unable to read lane TX data");
	g = fopen (data_out_fname,"wt");
	if (!g) panic ("Unable to write lane TX data");

	while (!feof(f))
	{
		if (fgets (buffer,sizeof(buffer),f))
		{
			if (buffer[0] != '1' &&
				buffer[0] != '0') panic ("Expected leading 1/0 control word marker");
			control_bits = (buffer[0] == '1') ? 2 : 1;
			
			dat = scan64(&(buffer[2]));	
			word_disparity = count_ones (dat);
			word_disparity = word_disparity - (64-word_disparity);
			
			// framing bits have two 0's, one 1.
			word_disparity --;
		
			if ((word_disparity >= 0 && running_disparity >= 0) ||
				(word_disparity < 0 && running_disparity < 0))
			{
				fprintf (g,"%x ",control_bits ^ 4);
				fprintf (g,"%016I64X\n",~dat);			
			}
			else
			{
				fprintf (g,"%x ",control_bits);
				fprintf (g,"%016I64X\n",dat);			
			}
		}
	}

	fclose (f);
	fclose (g);
}

////////////////////////////////////////////////////////////////

int hex_nybble_val (int ch)
{
	if (ch >= '0' && ch <= '9') ch -= '0';
	else if (ch >= 'a' && ch <= 'f') ch = ch -'a' + 10;
	else if (ch >= 'A' && ch <= 'F') ch = ch -'A' + 10;
	else panic ("This is not a hex nybble char");
	return (ch);
}

////////////////////////////////////////////////////////////////
// Break up 67 bit words into (20) bit transmit blocks
void lane_tx_gearbox
(
	char * data_in_fname,
	char * data_out_fname	
)
{
	FILE * f = NULL;
	FILE * g = NULL;
	u64 residue = 0, dat = 0;
	u64 lane_mask = 0;
	int bits_residue = 0;
	int ch = 0;
	int n = 0, k = 0;
	char buffer [MAX_LINE];

	for (k=0; k<lane_bits; k++)
	{
		lane_mask <<= 1;
		lane_mask |= 1;
	}

	f = fopen (data_in_fname,"rt");
	if (!f) panic ("Unable to read lane TX data");
	g = fopen (data_out_fname,"wt");
	if (!g) panic ("Unable to write lane TX data");

	while (!feof(f))
	{
		if (fgets (buffer,sizeof(buffer),f))
		{
			ch = buffer[0];
			ch = hex_nybble_val(ch);

			// 1st nybble is 3 bit
			if (ch >= 8) panic ("Illegal framing bits");
			residue = (residue << 3) | ch;
			bits_residue += 3;

			// 16 remaining are full 4bit
			for (n=0; n<16; n++)
			{
				ch = buffer[2+n];
				ch = hex_nybble_val(ch);
				residue = (residue << 4) | ch;
				bits_residue += 4;

				// are there enough bits for an output word?
				if (bits_residue >= lane_bits)
				{
					dat = residue;
					k = bits_residue;
					while (k > lane_bits)
					{
						dat >>= 1;
						k--;
					}
					dat &= lane_mask;
					bits_residue -= lane_bits;

					fprintf (g,lane_format,dat);
				}
			}
		}
	}
	fclose (f);
	fclose (g);
}

/////////////////////////////////////////////

void make_lane_rx_tb 
(
	int stimulus_words
)
{
    FILE * f = fopen ("lane_rx_tb.sv","wt");
    if (!f) panic ("Unable to write lane RX tb");

    fprintf (f,"module lane_rx_tb ();\n");
    fprintf (f,"\n");

    fprintf (f,"localparam WIDTH = %d;\n",lane_bits);
    fprintf (f,"localparam SAMPLE_BYTES = (WIDTH / 4) + 2;\n");
    fprintf (f,"localparam META_FRAME_LEN = %d;\n",meta_frame_len);
    fprintf (f,"\n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"// load sample data out of file\n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"reg [WIDTH-1:0] lane_bits,lane_bits_err;\n");
    fprintf (f,"reg clk = 0, arst = 0;\n");
    fprintf (f,"\n");
    fprintf (f,"integer pfile = 0, pfile_err;\n");
    fprintf (f,"\n");
    fprintf (f,"initial begin\n");
    fprintf (f,"	pfile = $fopen (\"lane_bits.txt\",\"r\");\n");
    fprintf (f,"    if (pfile == 0) begin\n");
    fprintf (f,"        $display (\"Unable to read lane_bits data file\");\n");
    fprintf (f,"        $stop();\n");
    fprintf (f,"    end\n");
    fprintf (f,"	pfile_err = $fopen (\"lane_bits_err.txt\",\"r\");\n");
    fprintf (f,"    if (pfile_err == 0) begin\n");
    fprintf (f,"        $display (\"Unable to read lane_bits_err data file\");\n");
    fprintf (f,"        $stop();\n");
    fprintf (f,"    end\n");
    fprintf (f,"end\n");
    fprintf (f,"\n");
    fprintf (f,"reg [SAMPLE_BYTES*8-1:0] buffer;\n");
    fprintf (f,"integer r,s = 0;\n");
    fprintf (f,"always @(negedge clk) begin\n");
    fprintf (f,"  r = $fgets (buffer,pfile);	\n");
    fprintf (f,"  r = $sscanf (buffer,\"%%x\",lane_bits);\n");
	fprintf (f,"  s = s + 1;\n");
    fprintf (f,"  r = $fgets (buffer,pfile_err);	\n");
    fprintf (f,"  r = $sscanf (buffer,\"%%x\",lane_bits_err);\n");
	fprintf (f,"end\n");
    fprintf (f,"\n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"// shift sample data \n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"reg [2*WIDTH-1:0] sample_dat;\n");
    fprintf (f,"always @(posedge clk or posedge arst) begin\n");
    fprintf (f,"	if (arst) sample_dat <= 0;\n");
    fprintf (f,"	else sample_dat <= (sample_dat << WIDTH) | lane_bits;\n");
    fprintf (f,"end\n");
    fprintf (f,"\n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"// test units\n");
    fprintf (f,"//    look at all (width) shifts of the\n");
    fprintf (f,"//   input stream\n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"wire [65:0] dout [0:WIDTH-1];\n");
    fprintf (f,"wire [WIDTH-1:0] dout_valid,word_locked,sync_locked;\n");
    fprintf (f,"wire [WIDTH-1:0] framing_error,crc32_error,scrambler_mismatch,missing_sync;\n");
    fprintf (f,"reg [15:0] words_to_sync_lock [0:WIDTH-1];\n");
    fprintf (f,"\n");
    fprintf (f,"genvar i;\n");
    fprintf (f,"generate\n");
    fprintf (f,"	for (i=0; i<WIDTH; i=i+1)\n");
    fprintf (f,"	begin : du\n");
    fprintf (f,"		lane_rx lr (\n");
    fprintf (f,"			.clk,.arst,\n");
    fprintf (f,"			.din(sample_dat[2*WIDTH-1-i:WIDTH-i]),\n");
    fprintf (f,"			.dout(dout[i]),\n");
    fprintf (f,"			.dout_valid(dout_valid[i]),\n");
    fprintf (f,"			.word_locked(word_locked[i]),\n");
    fprintf (f,"			.sync_locked(sync_locked[i]),\n");
    fprintf (f,"			.framing_error(framing_error[i]),\n");
    fprintf (f,"			.crc32_error(crc32_error[i]),\n");
    fprintf (f,"			.scrambler_mismatch(scrambler_mismatch[i]),\n");
    fprintf (f,"			.missing_sync(missing_sync[i])\n");
    fprintf (f,"		);\n");
    fprintf (f,"		defparam lr .META_FRAME_LEN = META_FRAME_LEN;\n");
	fprintf (f,"\n");
	fprintf (f,"        // monitor time from word lock to meta frame sync\n"); 
	fprintf (f,"        always @(posedge clk or posedge arst) begin\n");
	fprintf (f,"            if (arst) words_to_sync_lock[i] <= 0;\n");
	fprintf (f,"            else begin\n");
	fprintf (f,"                if (!word_locked[i]) words_to_sync_lock[i] <= 0;\n");
	fprintf (f,"                else if (!sync_locked[i] & dout_valid[i]) words_to_sync_lock[i] <= words_to_sync_lock[i] + 1'b1;\n");
	fprintf (f,"            end\n");
	fprintf (f,"        end\n");
	fprintf (f,"    end\n");
    fprintf (f,"endgenerate\n");
    fprintf (f,"\n");
	fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"// spec rules\n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"reg fail = 1'b0;\n");
	fprintf (f,"\n");
	fprintf (f,"// Observe lane locking\n");
	fprintf (f,"wire all_aligned = &word_locked;\n");
    fprintf (f,"wire all_locked = &sync_locked;\n");
    fprintf (f,"initial begin\n");
	fprintf (f,"   // allow 1200 words to acquire word alignment.\n");
	fprintf (f,"   // This is data dependent, could in theory take forever\n");
	fprintf (f,"   #%d\n",1200 * 67 * 10 / lane_bits);
	fprintf (f,"   if (!all_aligned) begin\n");
	fprintf (f,"      $display (\"Failed to acquire word alignment within expected window\");\n");
	fprintf (f,"      fail = 1;\n");
	fprintf (f,"   end\n\n");
	fprintf (f,"   // allow 4 more frames to acquire frame lock\n");
	fprintf (f,"   #%d\n",(4 * meta_frame_len) * 67 * 10 / lane_bits);
	fprintf (f,"   if (!all_locked) begin\n");
	fprintf (f,"      $display (\"Failed to acquire frame lock within expected window\");\n");
	fprintf (f,"      fail = 1;\n");
	fprintf (f,"   end\n");
	fprintf (f,"end\n");
    fprintf (f,"\n");
	fprintf (f,"// Lanes should sync lock after word lock +4 good sync words, not earlier or later\n");
	fprintf (f,"integer n;\n");
	fprintf (f,"initial begin\n");
	fprintf (f,"   @(posedge all_locked) begin\n");
	fprintf (f,"      for (n=0; n<WIDTH;n=n+1) begin\n");
	fprintf (f,"         if (words_to_sync_lock[n] < %d) begin\n",3*meta_frame_len);
	fprintf (f,"            $display (\"Chan %%d acquired sync in less than 3 frames\",n);\n");
	fprintf (f,"            fail = 1;\n");
	fprintf (f,"         end\n");    
	fprintf (f,"         if (words_to_sync_lock[n] > %d) begin\n",4*meta_frame_len);
	fprintf (f,"            $display (\"Chan %%d failed to acquired sync lock in 4 frames\",n);\n");
	fprintf (f,"            fail = 1;\n");
	fprintf (f,"         end\n");    
	fprintf (f,"      end\n");    
	fprintf (f,"   end\n");
	fprintf (f,"   @(negedge clk);\n");
	fprintf (f,"   if (!fail) $display (\"All %d shifted data test lanes have locked properly\");\n",lane_bits);
    fprintf (f,"end\n");
	fprintf (f,"\n");
	fprintf (f,"// Locked lanes should not have any error flags\n");
	fprintf (f,"integer k;\n");
	fprintf (f,"always @(posedge clk) begin\n");
	fprintf (f,"   #1 \n");
	fprintf (f,"   for (k=0; k<WIDTH;k=k+1) begin\n");
	fprintf (f,"     if (sync_locked[k]) begin\n");
	fprintf (f,"       if (crc32_error[k] | framing_error[k] | scrambler_mismatch[k] | missing_sync[k]) begin\n");
	fprintf (f,"         $display (\"Chan %%d is reporting an unexpected error\",k);\n");
	fprintf (f,"         fail = 1;\n");
	fprintf (f,"       end\n");    
	fprintf (f,"     end\n");    
	fprintf (f,"   end\n");    
	fprintf (f,"end\n");    
	fprintf (f,"\n");
	fprintf (f,"// Due dilligence that the data stream passing CRC is the original test string\n");
	fprintf (f,"reg [WIDTH-1:0] text_ok = 0;\n");
	fprintf (f,"integer y;\n");
	fprintf (f,"always @(posedge clk) begin\n");
	fprintf (f,"   for (y=0; y<WIDTH;y=y+1) begin\n");
	fprintf (f,"     if (sync_locked[y] & dout_valid[y] && dout[y] == \" Humpty \") begin\n");
	fprintf (f,"       text_ok[y] = 1'b1;\n");
	fprintf (f,"     end\n");
	fprintf (f,"   end\n");
	fprintf (f,"end\n");    
	fprintf (f,"\n");
	fprintf (f,"////////////////////////////////////////////////\n");
    fprintf (f,"// look at response to corrupted data stream\n");
	fprintf (f,"////////////////////////////////////////////////\n");
    fprintf (f,"wire [65:0] dout_err;\n");
	fprintf (f,"wire dout_valid_err,word_locked_err,sync_locked_err;\n");
    fprintf (f,"wire framing_error_err,crc32_error_err,scrambler_mismatch_err,missing_sync_err;\n");
	fprintf (f,"reg [%d-1:0] lane_bits_noise = 0;\n",lane_bits);
	fprintf (f,"reg lane_bits_noise_ena = 1'b0;\n");
    fprintf (f,"lane_rx dut_err (\n");
    fprintf (f,"		.clk,.arst,\n");
	fprintf (f,"		.din(lane_bits_err ^ (lane_bits_noise_ena ? lane_bits_noise : %d'b0)),\n",
			lane_bits-1);
    fprintf (f,"		.dout(dout_err),\n");
    fprintf (f,"		.dout_valid(dout_valid_err),\n");
    fprintf (f,"		.word_locked(word_locked_err),\n");
    fprintf (f,"		.sync_locked(sync_locked_err),\n");
    fprintf (f,"		.framing_error(framing_error_err),\n");
    fprintf (f,"		.crc32_error(crc32_error_err),\n");
    fprintf (f,"		.scrambler_mismatch(scrambler_mismatch_err),\n");
    fprintf (f,"		.missing_sync(missing_sync_err)\n");
    fprintf (f,");\n");
    fprintf (f,"defparam dut_err .META_FRAME_LEN = META_FRAME_LEN;\n");
	fprintf (f,"\n");
	fprintf (f,"always @(posedge clk) begin\n");
	fprintf (f,"   lane_bits_noise <= $random();");
	fprintf (f,"end\n");
	fprintf (f,"\n");	
	fprintf (f,"reg good_error_response = 1'b0;\n");
	fprintf (f,"reg good_noise_recovery = 1'b0;\n");
	fprintf (f,"initial begin\n");
	fprintf (f,"   // look at response to framing layer errors in the data stream\n");
	fprintf (f,"   @(posedge sync_locked_err);\n");
	fprintf (f,"   @(posedge missing_sync_err);\n");
	fprintf (f,"   @(posedge missing_sync_err);\n");
	fprintf (f,"   @(posedge missing_sync_err);\n");
	fprintf (f,"   @(posedge crc32_error_err);\n");
	fprintf (f,"   @(posedge crc32_error_err);\n");
	fprintf (f,"   @(posedge scrambler_mismatch_err);\n");
	fprintf (f,"   @(posedge missing_sync_err);\n");
	fprintf (f,"   @(posedge missing_sync_err);\n");
	fprintf (f,"   $display (\"Correct response to data stream with sync / scrambler / CRC32 errors\");\n");
    fprintf (f,"   @(posedge scrambler_mismatch_err);\n");
	fprintf (f,"   @(posedge scrambler_mismatch_err);\n");
	fprintf (f,"   @(posedge scrambler_mismatch_err);\n");
	fprintf (f,"   @(negedge sync_locked_err);\n");
	fprintf (f,"   @(posedge sync_locked_err);\n");
	fprintf (f,"   good_error_response = 1'b1;\n");
	fprintf (f,"   $display (\"Correct recovery from incorrect scrambler state\");\n");
    fprintf (f,"\n");
	fprintf (f,"   // look at response to catastrophic line noise\n");
	fprintf (f,"   @(negedge clk) lane_bits_noise_ena = 1'b1;\n");
	fprintf (f,"   @(negedge word_locked_err);\n");
	fprintf (f,"   #100 @(negedge clk) lane_bits_noise_ena = 1'b0;\n");
	fprintf (f,"   @(posedge framing_error_err);\n");
	fprintf (f,"   @(posedge word_locked_err);\n");
	fprintf (f,"   @(posedge sync_locked_err);\n");
	fprintf (f,"   good_noise_recovery = 1'b1;\n");
	fprintf (f,"   $display (\"Correct recovery from catastrophic noise burst\");\n");
    fprintf (f,"end\n\n");

	fprintf (f,"// stop shortly before data file is exhausted\n");
	fprintf (f,"always @(posedge clk) begin\n");
	fprintf (f,"   if (s == (%d-2)) begin\n",(stimulus_words*67/20));
	fprintf (f,"      if (~&text_ok) begin\n");
	fprintf (f,"        $display (\"Sample text was not properly recovered on the dout\");\n");
	fprintf (f,"        fail = 1'b1;\n");
	fprintf (f,"      end\n");
	fprintf (f,"      if (!good_error_response) begin\n");
	fprintf (f,"        $display (\"dut_err did not respond properly to error injected data stream\");\n");
	fprintf (f,"        fail = 1'b1;\n");
	fprintf (f,"      end\n");
	fprintf (f,"      if (!good_noise_recovery) begin\n");
	fprintf (f,"        $display (\"dut_err did not recover from catastrophic noise burst\");\n");
	fprintf (f,"        fail = 1'b1;\n");
	fprintf (f,"      end\n");
	fprintf (f,"   end\n");
	fprintf (f,"   else if (s == %d) begin\n",(stimulus_words*67/20));
	fprintf (f,"      if (!fail) $display (\"PASS\");\n");
	fprintf (f,"      else $display (\"FAIL\");\n");
	fprintf (f,"      $stop();\n");
	fprintf (f,"   end\n");
	fprintf (f,"end\n");
	fprintf (f,"\n");
	
	fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"// clock driver\n");
    fprintf (f,"/////////////////////////////////////\n");
    fprintf (f,"always begin\n");
    fprintf (f,"	#5 clk = ~clk;\n");
    fprintf (f,"end\n");
    fprintf (f,"\n");
    fprintf (f,"initial begin\n");
    fprintf (f,"	arst = 0;\n");
    fprintf (f,"	#1 arst = 1;\n");
    fprintf (f,"	@(negedge clk) arst = 0;\n");
    fprintf (f,"end\n");
    fprintf (f,"\n");
    fprintf (f,"endmodule\n");
    fclose (f);
}

////////////////////////////////////////////////////////////////

int main (void)
{
	// number of 8byte payload words desired
	int words_wanted = 5000;

	// write some sample data for a lane RX unit
	sample_text_to_words ("sample.txt",words_wanted);
	lane_tx_frame ("sample.txt","framed.txt",false);
	lane_tx_frame ("sample.txt","framed_err.txt",true);
	lane_tx_disparity ("framed.txt","lane_words.txt");
	lane_tx_disparity ("framed_err.txt","lane_words_err.txt");
	lane_tx_gearbox ("lane_words.txt","lane_bits.txt");
	lane_tx_gearbox ("lane_words_err.txt","lane_bits_err.txt");

	make_lane_rx_tb (words_wanted);

	return (0);
}
