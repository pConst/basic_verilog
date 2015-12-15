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

// baeckler - 04-10-2006
// RC4 test program
//   algorithm taken from "Applied Cryptography" by Bruce Schneier

#include <stdio.h>

int main (void)
{
	int i = 0, j = 0;
	int sbox [256];
	int key [256];

	// fixed key string
	char *key_str = "gregg";

	int tmp = 0;
	int n = 0;
	
	// fill in the key array and init the sbox to 1234...
	fprintf (stdout,"Key string is %s\n",key_str);
	for (i=0; i<256; i++)
	{
		key[i] = key_str[i%5];
		sbox[i] = i;
	}

	// key the system
	j = 0;
	for (i=0; i<256; i++)
	{
		j += sbox[i] + key[i];
		j = j % 256;
		//fprintf (stdout,"Keying : swap %d and %d\n",i,j);
		tmp = sbox[i];
		sbox[i] = sbox[j];
		sbox[j] = tmp;
	}

	// generate some bytes ...
	i = 0;
	j = 0;
	for (n=0; n<10000; n++)
	{
		// actual generate operation
		i++;
		i = i % 256;
		j += sbox[i];
		j = j % 256;
		tmp = sbox[i];
		sbox[i] = sbox[j];
		sbox[j] = tmp;
		
		// dump a few checkpoint values to look at for
		// testing.
		if ((n == 0) || (n == 99) || (n == 999) || (n == 9999))
		{
			fprintf (stdout,"byte %d is %02x\n",
					n+1,sbox[(sbox[i] + sbox[j]) % 256]);
		}
	}		

	return (0);
}
