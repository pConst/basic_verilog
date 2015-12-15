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

// baeckler - 11-28-2005
// Standalone utility to make it easier to replicate TXT files from coconut.
//
// $Log:   /pvcs/newarch/coconut/txt_to_c.cp_  $
//	
//	   Rev 1.1   15 May 2007 14:57:50   chkyeoh
//	port to linux 
//	PN, Tue May 15 10:57:48 2007
//	
//	   Rev 1.0   29 Nov 2005 11:21:24   baeckler
//	Init rev
//	 
//	SJ, Mon Nov 28 15:20:51 2005
//
#include <stdio.h>
#include <string.h>

bool drop_leading_pound = false;
bool drop_blank_lines = false;

int main (int argc, char *argv[])
{
	FILE * f = NULL;
	char buffer[4096];
	char buffer2[4096];
	int n=0,k=0;
	int len = 0;

	if (argc != 2 && argc != 3)
	{
		fprintf (stdout,"Convert text file to C dump file function\n");
		fprintf (stdout,"Usage : %s (filename) (optional filter)\n",argv[0]);
		fprintf (stdout,"  filter Q - QSFs\n");
		return (0);
	}
	
	f = fopen (argv[1],"rt");
	if (!f)
	{
		fprintf (stdout,"Unable to read %s",argv[1]);
		return (0);
	}

	if (argc == 3 && 
		(argv[2][0] == 'Q' || argv[2][0] == 'q'))
	{
		drop_leading_pound = true;
		drop_blank_lines = true;
	}

	fprintf (stdout,"#include <stdio.h>\n\n");
	fprintf (stdout,"int main (void)\n");
	fprintf (stdout,"{\n");
	fprintf (stdout,"    FILE * f = fopen (\"%s_new\",\"wt\");\n",argv[1]);
	fprintf (stdout,"    if (!f) return 1;\n\n");
	while (!feof(f))
	{
		if (fgets (buffer,sizeof(buffer),f))
		{
			// strip off CRLF
			len = strlen(buffer);
			while (len > 0 && (buffer[len-1] == 0xa || buffer[len-1] == 0xd))
			{
				buffer[len-1] = 0;
				len--;
			}
			
			// if they say " they mean \"
			// if they say \ they mean two of them
			// if they say % they mean two of them
			k=0;
			for (n=0;n<len;n++)
			{
				if (buffer[n] == '"')
				{
					buffer2[k++]='\\';
				}
				else if (buffer[n] == '\\')
				{
					buffer2[k++]='\\';
				}
				else if (buffer[n] == '%')
				{
					buffer2[k++]='%';
				}
				buffer2[k++] = buffer[n];
			}
			buffer2[k++] = 0;
			
			// spit out print instruction
			if (drop_leading_pound && 
				buffer2[0] == '#')
			{
				// skip this
			}
			else if (drop_blank_lines &&
					buffer2[0] == 0)
			{
				// skip this
			}
			else
			{
				fprintf (stdout,"    fprintf (f,\"%s\\n\");\n",buffer2);
			}
		}
	}

	fprintf (stdout,"    fclose (f);\n");
	fprintf (stdout,"    return (0);\n");
	fprintf (stdout,"}\n");

	fclose (f);
	
	return (0);
}

