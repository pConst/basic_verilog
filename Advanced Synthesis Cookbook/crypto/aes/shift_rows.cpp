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

// baeckler - 03-07-2006
// a little utility to generate 
// the shift rows byte pattern

#include <stdio.h>

void index (int row, int col)
{
	int bit = 127 - (col * 4 * 8 + row * 8);
	fprintf (stdout,"%d:%d",bit,bit-7);
}

int main (void)
{
	int r,c;

	fprintf (stdout,"SHift rows : \n");
	for (c=0; c<4; c++)
	{
		for (r=0;r<4;r++)
		{
			fprintf (stdout,"in[");
			index (r,(c+r)%4);
			fprintf (stdout,"],");
		}
		fprintf (stdout,"\n");
	}

	fprintf (stdout,"\nInverse shift rows : \n");
	for (c=0; c<4; c++)
	{
		for (r=0;r<4;r++)
		{
			fprintf (stdout,"in[");
			index (r,(4+c-r)%4);
			fprintf (stdout,"],");
		}
		fprintf (stdout,"\n");
	}
	return (0);
}