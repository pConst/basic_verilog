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

// baeckler - 01-02-2007 
// add legal text to example files

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

///////////////////////////////////////////////////////
// paste the contents of legal.txt on the front
///////////////////////////////////////////////////////
void add_header (char *fname)
{
	FILE * f = NULL, * tmp = NULL, * hdr = NULL;
	char buffer [2048];

	f = fopen (fname,"rt");
	if (!f) 
	{
		fprintf (stdout,"Error reading %s\n",fname);
		exit(1);
	}
	hdr = fopen ("utility/legal.txt","rt");
	if (!hdr) 
	{
		fprintf (stdout,"Error reading legal.txt\n");
		exit(1);
	}
	tmp = fopen ("tmp","wt");
	if (!tmp) 
	{
		fprintf (stdout,"Error writing tmp file\n");
		exit(1);
	}
	
	// dump to tmp header then body
	while (!feof(hdr))
	{
		if (fgets (buffer,sizeof(buffer),hdr))
		{
			fprintf (tmp,"%s",buffer);
		}
	}
	fclose (hdr);
	fprintf (tmp,"\n\n");
	
	while (!feof(f))
	{
		if (fgets (buffer,sizeof(buffer),f))
		{
			fprintf (tmp,"%s",buffer);
		}
	}
	fclose (f);
	fclose (tmp);

	// move tmp back to original
	f = fopen (fname,"wt");
	if (!f) 
	{
		fprintf (stdout,"Error writing %s\n",fname);
		exit(1);
	}
	tmp = fopen ("tmp","rt");
	if (!tmp) 
	{
		fprintf (stdout,"Error reading tmp file\n");
		exit(1);
	}
	while (!feof(tmp))
	{
		if (fgets (buffer,sizeof(buffer),tmp))
		{
			fprintf (f,"%s",buffer);
		}
	}
	fclose (f);
	fclose (tmp);

}

///////////////////////////////////////////////////////
// recursive dir for *.v, *.inc, *.cpp and insert
// legal header if not there already
///////////////////////////////////////////////////////
int main (void)
{
	char buffer [1024];
	char buffer2 [1024];
	FILE * f = NULL, * g = NULL, * h = NULL;
	int n = 0;

	_flushall();
	system ("dir /s /b *.v *.sv *.inc *.cpp > design_files.txt");
	
	f = fopen ("design_files.txt","rt");
	if (!f) 
	{
		fprintf (stdout,"Error reading file list\n");
		return (1);
	}
	while (!feof(f))
	{
		if (fgets (buffer,sizeof(buffer),f))
		{
			// change back slashes to forward, and kill crlf
			n = 0;
			while (buffer[n] != 0 && buffer[n] != 0xd && buffer[n] != 0xa)
			{
				if (buffer[n] == '\\') buffer[n] = '/';
				n++;
			}
			buffer[n] = 0;

			// open the file and look for a header
			fprintf (stdout,"Looking at file %s ...\n",buffer);
			g = fopen (buffer,"rt");
			if (!g)
			{
				fprintf (stdout,"Error reading design file\n");
				return (1);
			}

			
			bool found = false;
			for (n=0; n<5; n++)
			{
				if (fgets (buffer2,sizeof(buffer2),g))
				{
					if (strstr (buffer2,"// Copyright") != 0)
					{
						fprintf (stdout,"  has a header already\n");
						found = true;
					}
				}
			}
			fclose (g);
			if (!found)
			{
				add_header (buffer);						
			}
		}
		
	}
	fclose (f);
	return (0);
}