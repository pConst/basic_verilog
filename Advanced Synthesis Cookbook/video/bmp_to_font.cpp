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

#include <stdio.h>

// font.bmp dimensions in pixels.   
int const w = 980;
int const h = 111;

// the content is expected to be the basic 24 bit BMP format, black characters
// on a white background.   Total file size should be 54 byte header + (3 * w * h)
// The width of the image may need to be a multiple of 4 depending on the editor
// program.

int grab [w][h];
bool used_col[w];
bool used_row[h];

int target_width = 24;
int target_height = 28;

int main (void)
{
	FILE * f = NULL;
	int b,g,r;
	int n,x,y,ch;
	bool any_on_line = false;
	bool any_in_col = false;
	int xx,yy,i,j;

	f = fopen ("font.bmp","rb");
	if (!f) 
	{
		fprintf (stdout,"Unable to read file\n");	
		return (1);
	}
	
	for (n=0; n<54;n++)
	{
		ch = fgetc (f);
	}

	for (y=0; y<h;y++)
	{
		for (x=0; x<w;x++)
		{
			if (feof(f))
			{
				fprintf (stdout,"The file length is shorter than expected\n");
				return (1);
			}

			b = fgetc (f);
			g = fgetc (f);
			r = fgetc (f);
			grab[x][h-1-y] = (b == 0xff && g == 0xff && r == 0xff) ? 0 : 1;
			
		}		
	}

	if (!feof(f))
	{
		ch = fgetc (f);
		if (!feof(f))
		{
			fprintf (stdout,"The file length is longer than expected\n");
			return (1);
		}
	}
	fclose (f);

	for (y=0; y<h;y++)
	{
		any_on_line = false;
		for (x=0; x<w;x++)
		{
			if (grab[x][y]) any_on_line = true;
		}
		used_row[y] = any_on_line;
	}
	
	fprintf (stdout,"module font_rom (\n");
	fprintf (stdout,"    input clk,\n");
	fprintf (stdout,"    input [10:0] addr,\n");
	fprintf (stdout,"    output reg [23:0] out\n");
	fprintf (stdout,");\n\n");

	fprintf (stdout,"reg [10:0] addr_r;\n");
	fprintf (stdout,"always @(posedge clk) begin\n");
	fprintf (stdout,"  addr_r <= addr;\n");
	fprintf (stdout,"  case (addr_r)\n");
	
	// dump
	int rec = 0, ofs = 0;
	for (y=1; y<h;y++)
	{
		if (used_row[y] & !used_row[y-1])
		{
			yy = y;
			while (used_row[yy]) yy++;
			
			fprintf (stdout,"// rows %d to %d\n",y,yy);
			
			// compress out unused columns
			// in this row range
			for (x=0; x<w;x++)
			{
				any_in_col = false;
				for (j=y; j<yy; j++)
				{
					if (grab[x][j]) any_in_col = true;
				}
				used_col[x] = any_in_col;
			}

			for (x=1; x<w;x++)
			{
				if (used_col[x] & !used_col[x-1])
				{
					xx = x;
					while (used_col[xx]) xx++;
					
					fprintf (stdout,"// start rec %d h = %d w = %d ofs = %d\n",
							rec,yy-y+1,xx-x+1,ofs);
					rec++;

					for (j=y;j<yy;j++)
					{
						fprintf (stdout,"    11'd%d : out <= 24'b",ofs);
						for (i=x;i<xx;i++)
						{
							fprintf (stdout,"%d",grab[i][j]);
						}
						for (i=0; i<target_width-(xx-x+1); i++)
						{
							fprintf (stdout,"0");
						}
						fprintf (stdout,";\n");
						ofs++;						
					}
					
					for (i=0; i<target_height-(yy-y+1); i++)
					{
						fprintf (stdout,"    11'd%d : out <= 24'b0;\n",ofs);						
						ofs++;
					}
					
					fprintf (stdout,"\n");
				}
			}
			fprintf (stdout,"\n");
		}
	}
	fprintf (stdout,"    default : out <= 0;\n");
	fprintf (stdout,"  endcase\n");
	fprintf (stdout,"end\n");
	fprintf (stdout,"endmodule\n\n");

	return (0);
}