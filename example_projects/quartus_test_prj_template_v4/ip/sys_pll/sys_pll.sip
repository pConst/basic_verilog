set_global_assignment -entity "sys_pll" -library "lib_sys_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "sys_pll" -library "lib_sys_pll" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "sys_pll" -library "lib_sys_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_sys_pll" -name SPD_FILE [file join $::quartus(sip_path) "sys_pll.spd"]

set_global_assignment -library "lib_sys_pll" -name MISC_FILE [file join $::quartus(sip_path) "sys_pll_sim/sys_pll.vo"]
