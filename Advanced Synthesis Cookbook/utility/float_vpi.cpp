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

#include <stdlib.h>
#include <stdio.h>
#include "vpi_user.h"

void rand_float_register();

unsigned int float_to_int (float f)
{
	void * foo = &f;
	unsigned int out = *((unsigned int *)foo);
	return (out);
}

float int_to_float (int n)
{
	void * foo = &n;
	float out = *((float *)foo);
	return (out);
}

////////////////////////////////////////////////////
// make a random float (single)
////////////////////////////////////////////////////
PLI_INT32 rand_float_calltf(PLI_BYTE8 * user_dat)
{
	vpiHandle systf_handle;
	s_vpi_value value_s;

	float a, b, c, d, out;
	unsigned int n;
	

	systf_handle = vpi_handle (vpiSysTfCall,NULL);

	n = rand();
	a = n;
	n = rand();
	b = n;
	a = a * b;

	n = rand();
	if (n == 0) n++;
	c = n;
	n = rand();
	if (n == 0) n++;
	d = n;
	c = c * d;

	out = a / c;
	n = float_to_int (out);

//	vpi_printf ("%08x\n",n);
	
	value_s.format = vpiIntVal;
	value_s.value.integer = (PLI_INT32)n;
	vpi_put_value (systf_handle,&value_s,NULL,vpiNoDelay);
	
	return(0);
}

void rand_float_register(void)
{
  s_vpi_systf_data tf_data;
  tf_data.type    = vpiSysFunc;
  tf_data.sysfunctype = vpiSysFuncSized;
  tf_data.tfname = "$rand_float";
  tf_data.calltf  = rand_float_calltf;
  tf_data.compiletf = NULL;
  tf_data.sizetf = NULL;
  tf_data.user_data = NULL;
  vpi_register_systf(&tf_data);
}

////////////////////////////////////////////////////
// divide two floats (single)
////////////////////////////////////////////////////
PLI_INT32 float_div_calltf(PLI_BYTE8 * user_dat)
{
	vpiHandle systf_handle, arg_iter, arg_handle;
	s_vpi_value value_s;

	unsigned int n,d;
	float nf,df;
	float outf;
	unsigned int out;
	
	systf_handle = vpi_handle (vpiSysTfCall,NULL);
	arg_iter = vpi_iterate (vpiArgument, systf_handle);
	if (!arg_iter)
	{
		vpi_printf ("Error: fpdiv failed to obtain arg handles");
		return (0);
	}

	arg_handle = vpi_scan (arg_iter);
	value_s.format = vpiIntVal;
	vpi_get_value (arg_handle,&value_s);
	n = value_s.value.integer;
	
	arg_handle = vpi_scan (arg_iter);
	value_s.format = vpiIntVal;
	vpi_get_value (arg_handle,&value_s);
	d = value_s.value.integer;

//	vpi_printf ("n=%08x\n",n);
//	vpi_printf ("d=%08x\n",d);

	vpi_free_object (arg_iter);

	nf = int_to_float(n);
	df = int_to_float(d);

	outf = nf / df;
	out = float_to_int (outf);

//	vpi_printf ("q = %08x\n",out);
	
	value_s.format = vpiIntVal;
	value_s.value.integer = (PLI_INT32)out;
	vpi_put_value (systf_handle,&value_s,NULL,vpiNoDelay);
	
	return(0);
}

void float_div_register(void)
{
  s_vpi_systf_data tf_data;
  tf_data.type    = vpiSysFunc;
  tf_data.sysfunctype = vpiSysFuncSized;
  tf_data.tfname = "$float_div";
  tf_data.calltf  = float_div_calltf;
  tf_data.compiletf = NULL;
  tf_data.sizetf = NULL;
  tf_data.user_data = NULL;
  vpi_register_systf(&tf_data);
}

////////////////////////////////////////////////////
// error
////////////////////////////////////////////////////
PLI_INT32 float_err_bar_calltf(PLI_BYTE8 * user_dat)
{
	vpiHandle systf_handle, arg_iter, arg_handle;
	s_vpi_value value_s;

	unsigned int n,d;
	float nf,df;
	float outf;
	int out;
	
	systf_handle = vpi_handle (vpiSysTfCall,NULL);
	arg_iter = vpi_iterate (vpiArgument, systf_handle);
	if (!arg_iter)
	{
		vpi_printf ("Error: fp error bar failed to obtain arg handles");
		return (0);
	}

	arg_handle = vpi_scan (arg_iter);
	value_s.format = vpiIntVal;
	vpi_get_value (arg_handle,&value_s);
	n = value_s.value.integer;
	
	arg_handle = vpi_scan (arg_iter);
	value_s.format = vpiIntVal;
	vpi_get_value (arg_handle,&value_s);
	d = value_s.value.integer;

//	vpi_printf ("n=%08x\n",n);
//	vpi_printf ("d=%08x\n",d);

	vpi_free_object (arg_iter);

	nf = int_to_float(n);
	df = int_to_float(d);
	
	if (d == 0) 
	{
		outf = 0;
	}
	else 
	{
		outf = (nf - df) / df;
	}

//	vpi_printf ("float err = %f\n",outf);
	
	if (outf < 0.0) outf = - outf;
	outf = outf * 100 * 100;
	
//	vpi_printf ("scaled float err = %f\n",outf);
	
	out = outf;

//	vpi_printf ("int = %08x\n",out);
	
	value_s.format = vpiIntVal;
	value_s.value.integer = (PLI_INT32)out;
	vpi_put_value (systf_handle,&value_s,NULL,vpiNoDelay);
	
	return(0);
}

void float_err_bar_register(void)
{
  s_vpi_systf_data tf_data;
  tf_data.type    = vpiSysFunc;
  tf_data.sysfunctype = vpiSysFuncSized;
  tf_data.tfname = "$float_err_bar";
  tf_data.calltf  = float_err_bar_calltf;
  tf_data.compiletf = NULL;
  tf_data.sizetf = NULL;
  tf_data.user_data = NULL;
  vpi_register_systf(&tf_data);
}

/////////////////////////////////////////////


void (*vlog_startup_routines[])() = 
{
  rand_float_register,
  float_div_register,
  float_err_bar_register,
  0
};
