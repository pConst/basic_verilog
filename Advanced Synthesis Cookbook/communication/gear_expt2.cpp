// Copyright 2009 Altera Corporation. All rights reserved.  
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

// baeckler - 03-27-2009

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

void panic (char * msg)
{
	fprintf (stdout,"PANIC: %s\n",msg);
	exit(1);
}

int const word_out_bits = 40;
int const word_in_bits = 67;
int const storage_len = word_out_bits-1+word_in_bits;
bool storage [storage_len];
int holding = 0;

void init_storage ()
{
	int n = 0;
	for (n=0; n<storage_len; n++)
	{
		storage[n] = false;
	}
	for (n=storage_len-1; n>=storage_len-word_out_bits; n--)
	{
		storage[n] = true;
	}
	holding = word_out_bits;
}

// bool OK?
bool shl_storage (int shift_dist)
{
	int n = 0;

	for (n=storage_len-1; n>=storage_len-shift_dist; n--)
	{
		if (storage[n]) 
		{
			//panic ("SHL is losing most significant bits");
			return (false);
		}
	}		
	for (n=storage_len-1; n>=shift_dist; n--)
	{
		storage[n] = storage[n-shift_dist];
	}
	for (n=0; n<shift_dist; n++)
	{
		storage[n] = false;
	}
	return (true);
}

// bool OK?
bool extract_word (int ms_idx)
{
	int n = 0;

	// these bits are TAKEN
	for (n=0; n<word_out_bits; n++)
	{
		if (!storage[ms_idx-n]) 
		{
			return (false);
		}
	}

	for (n=0; n<word_out_bits; n++)
	{
		storage[ms_idx-n] = false;				
	}

	holding -= word_out_bits;

	return (true);
}

bool insert_data (int shift_dist)
{
	int n = 0;

	if (shift_dist < 0)
	{
		return (false);
	}
	if (holding > 0 && !storage[word_in_bits+shift_dist])
	{
		// not adjoining exitsting residue
		return (false);
	}
	for (n=0; n<word_in_bits; n++)
	{
		if ((n+shift_dist) >= storage_len)
		{
			// ("Access out of range");
			return (false);
		}
		if (storage[n+shift_dist]) 
		{
			// ("New data is stomping old");
			return (false);
		}
		storage[n+shift_dist] = true;
	}
	holding += word_in_bits;

	return (true);
}

// scratch area for solution
int dat_shift [100];
int store_shift [100];
int extract_point [100];

// bool found a solution?
bool search (int phase)
{
	bool viable = true;
	bool last_storage [storage_len];	
	int last_holding;
	int n,a,b,c,bb,aa;

	if (phase == 68) return (true);

	// save state
	for (n=0; n<storage_len; n++)
	{
		last_storage[n] = storage[n];
	}
	last_holding = holding;

	//fprintf (stdout,"phase %d - holding %d\n",phase,holding);
	for (aa = 0; aa < 3; aa++)
	{
		if (aa == 0) a = 105;
		else if (aa == 1) a = 95; 
		else if (aa == 2) a = 100; 
				
		for (bb = 0; bb < 2; bb++)
		{
			if (bb == 0) b = 40; 
			else if (bb == 1) b = 45;
			
			for (c=0;c<32;c++) // 13 is ok, not sure about less
			{
				// execute phase - see if it works
				viable = true;

				if (holding >= word_out_bits) 
				{
					if (!extract_word (a))
					{
						viable = false;
						bb = 100; // if A doesn't work all B,C are wash
					}
				}
				else
				{
					// extract point a is a don't care
					a = 0;
				}

				if (viable)
				{	
					if (!shl_storage (b)) 
					{
						viable = false;
						c = 100; // if B doesn't work all C are wash
					}
				}
				if (viable)
				{
					if (holding >= word_out_bits)
					{
						// skip the insert this round						
						c = 100;
					}
					else
					{
						if (!insert_data (c)) viable = false;
					}
				}

				// if it looks OK keep searching
				if (viable)
				{
					//fprintf (stdout,"phase %d - %d %d %d works\n",phase,a,b,c);
					if (search (phase+1))
					{
						fprintf (stdout,"sol phase %d holding %d ext %d shl storage %d shl data %d\n",
							phase,last_holding,a,b,c);

						dat_shift [phase] = (c == 100) ? -1 : c;
						store_shift [phase] = b;
						extract_point [phase] = a;
						
						return (true);
					}
				}
				
				// restore state
				for (n=0; n<storage_len; n++)
				{
					storage[n] = last_storage[n];
				}
				holding = last_holding;
			}
		}
	}

	return (false);
}

int main (void)
{
	int n = 0;
	int shift_used[100];

	init_storage ();
	if (search (0))
	{
		// phase 0 has 67 bits, doesn't really matter
		// where, let phase 67 decide where phase 0 extracts
		extract_point[0] = extract_point[67];

		// Changes for hardware :
		// The search will be doing the extract and shifts
		// simultaneously.   
		// In hardware data shift is 1 tick earlier

		for (n=0; n<67; n++)
		{
			fprintf (stdout,"  6'h%02x : begin ",n);
			fprintf (stdout," ds <= 4'h%x;",
				dat_shift[(n+1)%67] == 0 ? 0 :
				dat_shift[(n+1)%67] == 1 ? 1 :
				dat_shift[(n+1)%67] == 2 ? 2 :
				dat_shift[(n+1)%67] == 3 ? 3 :
				dat_shift[(n+1)%67] == 4 ? 4 :
				dat_shift[(n+1)%67] == 13 ? 5 :
				dat_shift[(n+1)%67] == 14 ? 6 :
				dat_shift[(n+1)%67] == 15 ? 7 :
				dat_shift[(n+1)%67] == 16 ? 8 :
				dat_shift[(n+1)%67] == 17 ? 9 :
				dat_shift[(n+1)%67] == 26 ? 10 :
				dat_shift[(n+1)%67] == 27 ? 11 :
				dat_shift[(n+1)%67] == 28 ? 12 :
				dat_shift[(n+1)%67] == 29 ? 13 :
				dat_shift[(n+1)%67] == 30 ? 14 :
				15				
			);
		
			fprintf (stdout," ss <= 1'h%x; ",
				store_shift[n] == 40 ? 0 : 1);
			
			fprintf (stdout," ep <= 2'h%x; ",
				extract_point[n] == 95 ? 0 :
				extract_point[n] == 100 ? 1 :
				extract_point[n] == 105 ? 2 : 0xf);

			fprintf (stdout," end\n");
			if (n == 0x3f) fprintf (stdout,"\n");
			
		}
	}

	fprintf (stdout,"Tallying\n");
	for (n=0; n<67; n++)
	{
		shift_used[n] = 0;
	}
	for (n=0; n<67; n++)
	{
		if (dat_shift[n] != -1)
		{
			shift_used[dat_shift[n]] = 1;
		}
	}
	int tally = 0;
	for (n=0; n<67; n++)
	{
		if (shift_used[n]) 
		{
			tally++;		
			fprintf (stdout,"shift %d used\n",n);
		}
	}	
	fprintf (stdout,"%d unique shifts\n",tally);
	return (0);
}