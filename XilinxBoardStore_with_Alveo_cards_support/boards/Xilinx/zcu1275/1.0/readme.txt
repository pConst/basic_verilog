
1)Validate that the xczu29dr-ffvf1760-2-e is available in your Vivado installation.  Please see details in the board lounge or in user guide UG973: Vivado Release Notes, Installation, and Licensing.

2) Copy the contents from the zip for into local Vivado install.
Vivado\201X.x\data\boards\board_files\zcu1275\

Alternative to step 2) 
Copy the contents from the zip into a local directory <path_to_board_files_dir>.
Set  the following parameter either in your Vivado_init.tcl or on the Vivado TCL console before project creation.
>>  set_param board.repoPaths <path_to_board_files_dir>

For more information please refer to user guide UG895: Vivado System-Level Design Guide, Appendix A.


