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

// baeckler - 08-06-2008

#include <math.h>
#include <stdio.h>

////////////////////////////////////////
// convert float to fixed point signed binary
// values must be in the range -2..2
////////////////////////////////////////
void conv_binary (double val, int bits)
{
	double f;
	int n = 0;

	fprintf (stdout,"%d'b",bits);
	
	// handle the top bit to become positive
	if (val < 0.0) 
	{
		fprintf (stdout,"1");
		val += 2.0;		
	}
	else 
	{
		fprintf (stdout,"0");
	}
	
	// handle remaining bits
	for (n=0; n<bits-1; n++)
	{
		f = 1.0;
		f /= (1 << n);

		if (val >= f) 
		{
			fprintf (stdout,"1");
			val -= f;
		}		
		else 
		{
			fprintf (stdout,"0");			
		}
	}	
}

////////////////////////////////////////
// generate an arctan table for CORDIC
////////////////////////////////////////
int main (void)
{
	double f = 1.0, at=0.0;
	double pi = 3.14159265358979;
	double gain = 1.0, gain_term;

	int const bits = 16;
	int const rounds = 16;

	int n = 0;

	// ROM content
	for (n=0; n<rounds; n++)
	{
		f = 1.0;
		f /= (1 << n);
		
		gain_term = 1.0 + f*f;
		gain_term = sqrt(gain_term);
		gain *= gain_term;

		at = atan(f);
		fprintf (stdout,"  4'h%x : zrom <= ",n);
		conv_binary (at,bits);
		fprintf (stdout,"; // %1.8f\n",at);
	}

	// handy constants for use in testing
	fprintf (stdout,"\n\n");

	fprintf (stdout,"gain = ");
	conv_binary (gain,bits);
	fprintf (stdout," // %1.8f\n",gain);
	
	fprintf (stdout,"inv_gain = ");
	conv_binary (1.0/gain,bits);
	fprintf (stdout," // %1.8f\n",1.0/gain);
	
	f = pi / 8.0;
	fprintf (stdout,"pi_over_8 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);

	f = pi / 8.0;
	f = sin(f);
	fprintf (stdout,"sin_pi_over_8 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);

	f = pi / 8.0;
	f = cos(f);
	fprintf (stdout,"cos_pi_over_8 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);
	
	f = -pi / 3.0;
	fprintf (stdout,"neg_pi_over_3 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);

	f = -pi / 3.0;
	f = sin(f);
	fprintf (stdout,"sin_neg_pi_over_3 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);

	f = -pi / 3.0;
	f = cos(f);
	fprintf (stdout,"cos_neg_pi_over_3 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);

	f = pi / 4.0;
	fprintf (stdout,"pi_over_4 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);

	f = -pi / 4.0;
	fprintf (stdout,"neg_pi_over_4 = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);

	f = (0.25*0.25) + (0.25*0.25);
	f = sqrt(f) * gain;
	fprintf (stdout,"gained_vec_len = ");
	conv_binary (f,bits);
	fprintf (stdout,"; // %1.8f\n",f);


	return (0);
}