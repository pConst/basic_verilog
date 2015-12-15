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

// baeckler - 03-30-2009
// read ascii hex data from JTAG c_probe

#include <windows.h>
#include <stdio.h>
#include "read_c_probe.h"

#define C_PROBE_ID 0x30

////////////////////////////////////////////////////////////////////

int jtag_init
(
		char *preferred_hardware,
		char *preferred_server,
		char *preferred_port,
		char *preferred_device,
		int preferred_node_id,
		int preferrred_instance,
		char *appname,
		int print_scan,
		type_jtagnode *node
)
{
    AJI_ERROR err;
    int i,j,k;
    ULONG hardware_count = 0x10;
	AJI_HARDWARE hardware_list[0x10];
    int hardware_id = 0;
    ULONG device_count = 0x10;
    ULONG node_count = 0x10;
	AJI_DEVICE device_list[0x10];
	DWORD node_n = 1;
    int foundlink = -1;
    DWORD idcodes[0x10];
    DWORD device_index;
    int match = 0;
    ULONG node_info;


    node->id = 0;
    node->offset = 0;
    node->data_length = 0;
    node->hub_id = 0;
    err = aji_get_hardware(&hardware_count, hardware_list, 5000);
    if (err) {
        printf("\naji_get_hardware(), err=%d ",err);
        return JTAGLINK_ERR_BAD_HARDWARE;
    }
    if (print_scan) {
        printf("\nscanning jtag ...");
    }
	for (i=0; i<(int)hardware_count; i++) {
        if (print_scan) {
            if (hardware_list[i].server) printf("\n  %s on %s [%s]", hardware_list[i].hw_name, hardware_list[i].server, hardware_list[i].port );
            else printf("\n  %s [%s]", hardware_list[i].hw_name, hardware_list[i].port );
        }
	    err = aji_lock_chain(hardware_list[i].chain_id, 10000);
        if (err) {
            printf("\naji_lock_chain(), err=%d",err);
        }
        else {
            device_count = 0x10;
            err = aji_read_device_chain(hardware_list[i].chain_id, &device_count, device_list, 1);
            if (err) {
                if (err != AJI_BAD_JTAG_CHAIN) printf("\naji_read_device_chain(), err=%d ",err);
            } else {
	            for (j=0; j<(int)device_count; j++) {
                    if (print_scan) {
            	        printf("\n    %s, (%08x)", device_list[j].device_name,device_list[j].device_id);
                    }

					//get number of nodes
                    node_count = 0x10;
                    err = aji_get_nodes(hardware_list[i].chain_id, j, &idcodes[0], &node_count);
                    if (err) {
                        printf("\naji_get_nodes(), err=%d ",err);
            	        err = aji_unlock_chain(hardware_list[i].chain_id);
                        return JTAGLINK_ERR_BAD_NODEINFO;
                    }
                    for (k=0; k<(int)node_count; k++) {
                        err = aji_open_node(hardware_list[i].chain_id, j, idcodes[k], (AJI_OPEN_ID *)(&node->id), alt_jtaglib_claims, sizeof(alt_jtaglib_claims)/sizeof(alt_jtaglib_claims[0]), appname);
                        if (err == AJI_CHAINS_CLAIMED) {
                            //in use ...
                        } else {
                            if (err) {
                               printf("\naji_open_node(), err=%d, aji_node_id=%x",err,node->id);
                	           err = aji_unlock_chain(hardware_list[i].chain_id);
                               return JTAGLINK_ERR_BAD_NODES;
                           }
                           err = aji_get_node_info((AJI_OPEN_ID)node->id, &device_index, (ULONG *)&node->info);
                           if (err) {
                               printf("\naji_get_nodes(), err=%d ",err);
                             	err = aji_close_device((AJI_OPEN_ID)node->id);
                	           err = aji_unlock_chain(hardware_list[i].chain_id);
                               return JTAGLINK_ERR_BAD_NODEINFO;
                           }
                           node_info = *(ULONG *)&node->info;
                           node->info.inst_id = (UCHAR)(node_info >>  0) & 0xff;
                           node->info.mfg_id  = (USHORT)(node_info >>  8) & 0x7ff;
                           node->info.node_id = (UCHAR)(node_info >> 19) & 0xff;
                           node->info.version = (UCHAR)(node_info >> 27) & 0x1f;
                           if (print_scan) {
                               printf("\n      %02x:%02x:%02x:%02x",node->info.mfg_id,node->info.node_id,node->info.version,node->info.inst_id);
                           }

                            if (node->info.mfg_id==ALTERA_MFG_ID) {
                                match = (preferred_hardware) ? (hardware_list[i].hw_name) ? (int)strstr(hardware_list[i].hw_name,preferred_hardware) : 0 : 1;
                                if (match) {
                                    match = (preferred_server) ?  (hardware_list[i].server) ? (int)strstr(hardware_list[i].server,preferred_server) : 0 : 1;
                                    if (match) {
                                        match = (preferred_port) ? (hardware_list[i].port) ? (int)strstr(hardware_list[i].port,preferred_port) : 0 : 1;
                                        if (match) {
                                            match = (preferred_device) ? (device_list[j].device_name) ? (int)strstr(device_list[j].device_name,preferred_device) : 0 : 1;
                                            if (match) {
                                                match = (preferred_node_id>=0) ? (node->info.node_id==preferred_node_id) : 1;
                                                if (match) {
                                                    match = (preferrred_instance>=0) ? (node->info.inst_id==preferrred_instance) : 1;
                                                    if (match) {
                                                        //if this is our 'preferred' hardware/device use it
                                                        // else continue the search
                                                        strcpy(node->hardware,(hardware_list[i].hw_name)?hardware_list[i].hw_name:"");
                                                        strcpy(node->server,(hardware_list[i].server)?hardware_list[i].server:"");
                                                        strcpy(node->port,(hardware_list[i].port)?hardware_list[i].port:"");
                                                        strcpy(node->device,(device_list[j].device_name)?device_list[j].device_name:"");

                                                        foundlink = k;
                                                        if (match) {
                                                            err = aji_unlock_chain(hardware_list[i].chain_id);
                                                            if (err) {
                                                                printf("\naji_unlock_chain(), err=%d, chain_id=%x",err,hardware_list[i].chain_id);
                                                                return JTAGLINK_ERR_BAD_NODEUNLOCK;
                                                            }
                                                            goto found;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                  	        err = aji_close_device((AJI_OPEN_ID)node->id);
                      	}
                    }
	            }
    	    }
            err = aji_unlock_chain(hardware_list[i].chain_id);
            if (err) {
                printf("\naji_unlock_chain(), err=%d, chain_id=%x",err,hardware_list[i].chain_id);
                return JTAGLINK_ERR_BAD_NODEUNLOCK;
            }
	    }
	}
found:
    if (foundlink == -1) {
        if (print_scan) {
            printf("\ncannot find JTAG node");
        }
        return JTAGLINK_ERR_BAD_NODES;
    }

    return 0;
}

////////////////////////////////////////////////////////////////////

int jtag_close
(
	type_jtagnode *node
)
{
    AJI_ERROR err;

	err = aji_close_device((AJI_OPEN_ID)node->id);
    if (err) {
        printf("\naji_close_device(), err=%d",err);
        return err;
    }

    return 0;
}

////////////////////////////////////////////////////////////////////

int jtag_command
(
	type_jtagnode *node,
	DWORD instruction,
	DWORD length,
	BYTE *data_in,
	BYTE *data_out
)
{
    AJI_ERROR err;
    AJI_ERROR err1;
    DWORD delay = 0;
	    err = aji_lock((AJI_OPEN_ID)node->id, 500, AJI_PACK_AUTO); // TODO: longer timeout for first try
        if (err) {
            printf("\naji_lock(), err=%d ",err);
            return JTAGLINK_ERR_BAD_NODELOCK;
        }

    do {
        err = aji_access_overlay((AJI_OPEN_ID)node->id, instruction, 0);
        if (err == AJI_CHAIN_IN_USE) {
            //then the aji_lock() has failed, but hadn't yet told us ...
            // so wait a bit, then relock and try again
            Sleep(100);
    	    err1 = aji_lock((AJI_OPEN_ID)node->id, 500, AJI_PACK_AUTO); // TODO: longer timeout for first try
            if (err1) printf("\naji_lock(), err=%d ",err1);
        }
    } while (err == AJI_CHAIN_IN_USE);

	if (err) {
        printf("\naji_access_overlay(), err=%d, instruction=%x ",err, instruction);
        err = aji_unlock((AJI_OPEN_ID)node->id);
        return JTAGLINK_ERR_BAD_NODEACCESSIR;
    }

    err = aji_access_dr((AJI_OPEN_ID)node->id, length, AJI_DR_UNUSED_X, 0, (data_in)?length:0, data_in, 0, (data_out)?length:0, data_out);
    if (err) {
        printf("\naji_access_dr(), err=%d, length=%x, data_in=%02x %02x, data_out=%02x %02x",err, length, (data_in)?data_in[0]:0, (data_in)?data_in[1]:0,  (data_out)?data_out[0]:0, (data_out)?data_out[1]:0);
        err = aji_unlock((AJI_OPEN_ID)node->id);
        return JTAGLINK_ERR_BAD_NODEACCESSDR;
    }
    err = aji_unlock((AJI_OPEN_ID)node->id);
    if (err) {
        printf("\naji_unlock(), err=%d ",err);
        return JTAGLINK_ERR_BAD_NODEUNLOCK;
    }

    return 0;
}

////////////////////////////////////////////////////////////////////

int main (void)
{
	type_jtagnode node;
	int const probe_width = 16;
	UCHAR buffer [(probe_width >> 3) + 1];
    int ret = 0, val = 0;
	int k = 0, n = 0;
	int const required_bytes = 100000;
	FILE * f = NULL;
	bool bad_sample = false;
	int next_status = 0;

	f = fopen ("c_probe.bin","wb");
	if (!f) 
	{
		fprintf (stdout,"Unable to write dump file\n");
		return (1);
	}

	ret = jtag_init(0,0,0,0,C_PROBE_ID,0,"jtag_c_probe", 1, &node);
    if (ret < 0) 
	{
        printf("\nfailed to find jtag node");
        return 0;
    }

	fprintf (stdout,"\n\nCapturing %d bytes to c_probe.bin...\n",required_bytes);
	k=0;
	while (k<required_bytes)
	{
		if (k >= next_status)
		{
			fprintf (stdout,"%d pct complete\n",
				k * 100 / required_bytes);
			next_status += 2000;
		}

		// read from probe.  To write reverse 0 and buffer args
		jtag_command(&node, 0, probe_width, 0, buffer);
		if (buffer[1] == 0 && buffer[0] == 0)
		{
			// probe isn't ready
		}
		else 
		{
			bad_sample = false;
			for (n=0; n<2; n++)
			{
				if (buffer[n] >= 'A' && buffer[n] <= 'F')
				{
					buffer[n] = buffer[n] - 'A' + 10;
				}
				else if (buffer[n] >= 'a' && buffer[n] <= 'f')
				{
					buffer[n] = buffer[n] - 'a' + 10;
				}
				else if (buffer[n] >= '0' && buffer[n] <= '9')
				{
					buffer[n] = buffer[n] - '0';
				}
				else
				{
					bad_sample = true;
				}
			}
			if (bad_sample)
			{
				fprintf (stdout,"Read bad sample - link is corrupt?\n");
			}
			else
			{
				val = buffer[1];
				val <<= 4;
				val |= buffer[0];
				fprintf (f,"%c",val);
				k++;
			}
		}
	}
	jtag_close(&node);
	fclose (f);
	fprintf (stdout,"done\n");

	return (0);
             
}


