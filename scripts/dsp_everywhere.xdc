#------------------------------------------------------------------------------
# dsp_everywhere.xdc
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Experimental XDC constraints to explore how many DSPs could be used in your
# project. After the exploration you can write more specific DSP constraints
#


# add all project cells first
set_property use_dsp48 yes [get_cells -hierarchical -filter { IS_PRIMITIVE == "FALSE" }]

# (OPTIONAL) and then exclude specific cells if they fail timings with DSP`s
# set_property use_dsp no [get_cells -hierarchical -filter { IS_PRIMITIVE == "FALSE" && NAME =~ "top/my_instance_a*" }]
# set_property use_dsp no [get_cells -hierarchical -filter { IS_PRIMITIVE == "FALSE" && NAME =~ "top/my_instance_b*" }]
# set_property use_dsp no [get_cells -hierarchical -filter { IS_PRIMITIVE == "FALSE" && NAME =~ "top/my_instance_c*" }]

