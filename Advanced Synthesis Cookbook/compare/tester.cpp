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

int const WIDTH = 256;
int const LOG_WIDTH = 8;

bool eval_fn (int tvec[WIDTH])
{
	int lowest_hot = -1;
	int highest_hot = -1;
	int n = 0;
	bool hot_run = false;
	bool explained = false;

/*	for (n=WIDTH-1; n>=0; n--)
	{
		fprintf (stdout,"%d",tvec[n]);
	}
	fprintf (stdout," : \n");
*/
	for (n=0; n<WIDTH; n++)
	{
		if (tvec[n])
		{
			lowest_hot = n;
			break;
		}
	}
	for (n=WIDTH-1; n>=0; n--)
	{
		if (tvec[n])
		{
			highest_hot = n;
			break;
		}
	}
	
	if (lowest_hot < highest_hot)
	{
		// is it completely 1 between the highest and lowest hots?
		hot_run = true;
		for (n=lowest_hot; n<=highest_hot && hot_run; n++)
		{
			if (!tvec[n]) hot_run = false;
		}
		if (hot_run)
		{
			if (lowest_hot == 0 && highest_hot == (WIDTH-1))
			{
				// VCC
				fprintf (stdout,"  vcc\n");
				explained = true;
			}
			else if (lowest_hot == 0)
			{
				// less than equal highest hot
				fprintf (stdout,"  <= %d\n",highest_hot);
				explained = true;
			}
			else  if (highest_hot == (WIDTH-1))
			{
				// greater than equal lowest hot
				fprintf (stdout,"  >= %d\n",lowest_hot);
				explained = true;
			}
			else
			{
				// hot in a continuous range
				fprintf (stdout,"  in range [%d..%d]  (%d)\n",
					lowest_hot,highest_hot,highest_hot-lowest_hot);
				explained = true;
			}
		}
	}
	else if (lowest_hot != -1)
	{
		// one hot.
		fprintf (stdout,"  == %d\n",lowest_hot);
		explained = true;		
	}
	else
	{
		// gnd
		fprintf (stdout,"  gnd\n");
		explained = true;
	}
	return (explained);
}

int tvec [200000][WIDTH];
	
// add constant and build functions
void analyze_adder (int a)
{
	int k = 0, j = 0;
	int dat = 0;
	int fnum = 0;
	int n = 0;
	bool match = false;

	fprintf (stdout,"Analyzing + %d...\n",a);

	// single output bits
	for (k=0; k<=LOG_WIDTH; k++)
	{
		for (dat = 0; dat<WIDTH; dat++)
		{
			tvec[fnum][dat] = (((dat+a)&(1<<k)) != 0) ? 1 : 0;
		}
		fnum++;
	}

	// single data bits
	for (k=0; k<LOG_WIDTH; k++)
	{
		for (dat = 0; dat<WIDTH; dat++)
		{
			tvec[fnum][dat] = ((dat&(1<<k)) != 0) ? 1 : 0;
		}
		fnum++;
	}

	// add the inversions
	n = fnum;
	for (k=0; k<n; k++)
	{
		for (dat = 0; dat<WIDTH; dat++)
		{
			tvec[fnum][dat] = tvec[k][dat] ? 0 : 1;
		}
		fnum++;
	}

	// add the ANDs of singles
	n = fnum;
	for (k=0; k<n; k++)
	{
		for (j=k+1; j<n; j++)
		{
			for (dat = 0; dat<WIDTH; dat++)
			{
				tvec[fnum][dat] = tvec[k][dat] & tvec[j][dat];
			}
			fnum++;
		}
	}

	// add the XORs of singles
	for (k=0; k<n; k++)
	{
		for (j=k+1; j<n; j++)
		{
			for (dat = 0; dat<WIDTH; dat++)
			{
				tvec[fnum][dat] = tvec[k][dat] ^ tvec[j][dat];
			}
			fnum++;
		}
	}

	// add the ORs of singles
	for (k=0; k<n; k++)
	{
		for (j=k+1; j<n; j++)
		{
			for (dat = 0; dat<WIDTH; dat++)
			{
				tvec[fnum][dat] = tvec[k][dat] | tvec[j][dat];
			}
			fnum++;
		}
	}

	// trash some duplicates
	for (k=0; k<fnum; k++)
	{
		for (j=k+1; j<fnum; j++)
		{
			match = true;
			for (dat = 0; dat<WIDTH && match; dat++)
			{
				if (tvec[k][dat] != tvec[j][dat])
				{
					match = false;
				}
			}
			if (match)
			{
				for (dat = 0; dat<WIDTH; dat++)
				{
					tvec[j][dat] = tvec[fnum-1][dat];
				}
				fnum--;				
			}
		}
	}
	
	fprintf (stdout,"%d and counting...\n",fnum);


	// Trash some stuff that isn't interesting
	for (k=0; k<fnum; k++)
	{
		if (!eval_fn (tvec[k]))
		{
			for (dat = 0; dat<WIDTH; dat++)
			{
				tvec[k][dat] = tvec[fnum-1][dat];
			}
			fnum--;				
			k--;
		}
	}

	// add the ANDs of doubles
	n = fnum;
	for (k=0; k<n; k++)
	{
		for (j=k+1; j<n; j++)
		{
			for (dat = 0; dat<WIDTH; dat++)
			{
				tvec[fnum][dat] = tvec[k][dat] & tvec[j][dat];
			}
			fnum++;
		}
	}

	// add the ORs of doubles
	for (k=0; k<n; k++)
	{
		for (j=k+1; j<n; j++)
		{
			for (dat = 0; dat<WIDTH; dat++)
			{
				tvec[fnum][dat] = tvec[k][dat] | tvec[j][dat];
			}
			fnum++;
		}
	}

	fprintf (stdout,"+ %d yields %d functions\n",a,fnum);
	for (n=0; n<fnum; n++)
	{
		eval_fn (tvec[n]);
	}
}


int main (void)
{
	int dat;
	int a = 0;
	int tvec[WIDTH];
	int k = 0;

	for (a = 0; a < WIDTH; a++)
	{
		analyze_adder (a);		
	}
	return (0);
}
