#------------------------------------------------------------------------------
# Makefile for Intel / Altera Quartus
# Konstantin Pavlov, pavlovconst@gmail.com
#
#
# INFO ------------------------------------------------------------------------
#
# - Use this Makefile in linux terminal or on Windows under Cygwin
#
# - Default target ("make" command without any options) is intended to get fast
#   compilation and timing analysis. Suitable for general project development
#   and debugging
#
# - "make -j" runs timing analysis and *.sof file assembling in parallel. That
#   saves you ~20 seconds every time :)
#
# - Specific targets (for example, "make sof") provide you requested results
#   assuming that timing analysis is unnexessary
#
# - Check that Quartus and Modelsim directories are in your $PATH. Something like
#     echo $PATH | tr : \\n | grep quartus
#     export PATH = '/cygdrive/c/intelFPGA/17.0/quartus/bin64:$PATH'
#     export PATH = '/cygdrive/c/intelFPGA/17.0/quartus/bin:$PATH'
#     echo $PATH | tr : \\n | grep modelsim
#     export PATH = '/cygdrive/c/intelFPGA/17.0/modelsim_ase/win32aloem:$PATH'



PROJ_DIR = $(shell pwd)
PROJ = $(shell ls -1 *.qpf | tail -n1 | awk '{ gsub(".qpf","") } 1' )
#SRCS = $(shell ls -R1 src/*.{v,sv,vh,sdc,tcl,hex,bin} 2>/dev/null | grep -v ':' )
SRCS = $(shell ls -R1 src/* )

QPF = $(PROJ).qpf
QSF = $(PROJ).qsf
SOF = ./out/$(PROJ).sof
POF = ./out/$(PROJ).pof
RBF = ./out/$(PROJ).rbf
JAM = ./out/$(PROJ).jam

PRE_SCRIPT = './DEBUG/pre_flow.tcl'
POST_SCRIPT = './DEBUG/post_flow.tcl'

MAP_REPORT = ./out/$(PROJ).map.rpt
FIT_REPORT = ./out/$(PROJ).fit.rpt

DSE_CONFIG = $(PROJ).dse

TARGET_IP = 192.168.1.1
TARGET_PORT = USB-1
TARGET_CHIP = 1


# OS deterction algorithm
ifeq '$(findstring ;,$(PATH))' ';'
	DET_OS := Windows
else
	DET_OS := $(shell uname 2>/dev/null || echo Unknown)
	DET_OS := $(patsubst CYGWIN%,Cygwin,$(DET_OS))
	DET_OS := $(patsubst MSYS%,MSYS,$(DET_OS))
	DET_OS := $(patsubst MINGW%,MSYS,$(DET_OS))
endif


# selecting Quartus based on detected OS
ifeq '$(DET_OS)' 'Cygwin'
	QUARTUS_DIR =  /cygdrive/c/intelFPGA_lite/20.1/quartus/bin64/
else
	QUARTUS_DIR =  ~/intelFPGA_lite/20.1/quartus/bin64/
endif


.SILENT: info clean

.PHONY: all info gui clean stp report


all: sta sof



info:
	echo -e \\n '    Detected OS: ' $(DET_OS)\
					\\n '    Project directory: ' $(PROJ_DIR) \
	        \\n '    Project name: ' $(PROJ) \
	        \\n '    Preject sources: ' $(SRCS)


gui:
	quartus $(QPF) 1>/dev/null


$(MAP_REPORT): $(SRCS) $(QPF) $(QSF)
	$(shell if test -f $(PRE_SCRIPT); then quartus_sh -t $(PRE_SCRIPT) compile $(PROJ) $(PROJ); fi )
	$(QUARTUS_DIR)quartus_map --no_banner \
		--read_settings_files=on \
		--write_settings_files=off \
		--64bit $(PROJ) -c $(PROJ)
	# dont use --effort=fast because it can dramatically increase fitting time
map: $(MAP_REPORT)


$(FIT_REPORT): $(MAP_REPORT)
	# $(QUARTUS_DIR)quartus_cdb --read_settings_files=on \
	#             --write_settings_files=off \
	#             --64bit $(PROJ) -c $(PROJ)
	$(QUARTUS_DIR)quartus_fit --no_banner \
		--read_settings_files=on \
		--write_settings_files=off \
		--inner_num=1 \
		--one_fit_attempt=on \
		--pack_register=off \
		--effort=fast \
		--64bit $(PROJ) -c $(PROJ)
	# using --io_smart_recompile for secondary fitter launches is tricky
fit: $(FIT_REPORT)


$(SOF): $(FIT_REPORT)
	$(QUARTUS_DIR)quartus_asm --no_banner \
		--read_settings_files=off \
		--write_settings_files=off \
		--64bit $(PROJ) -c $(PROJ)
asm: $(SOF)


sta: $(FIT_REPORT)
	$(QUARTUS_DIR)quartus_sta $(PROJ) -c $(PROJ)
	#$(shell if test -f $(POST_SCRIPT); then quartus_sh -t $(POST_SCRIPT) compile $(PROJ) $(PROJ); fi )

stap: $(FIT_REPORT)
	$(QUARTUS_DIR)quartus_sta --parallel --model=slow $(PROJ) -c $(PROJ)
	#$(shell if test -f $(POST_SCRIPT); then quartus_sh -t $(POST_SCRIPT) compile $(PROJ) $(PROJ); fi )


$(POF): $(SOF)
	$(QUARTUS_DIR)quartus_cpf --no_banner \
		-c $(SOF) $(POF)
$(RBF): $(SOF)
	$(QUARTUS_DIR)quartus_cpf --no_banner \
		-c $(SOF) $(RBF)
$(JAM): $(SOF)
	$(QUARTUS_DIR)quartus_cpf --no_banner \
		-c $(SOF) $(JAM)
sof: $(SOF)
pof: $(POF)
rbf: $(RBF)
jam: $(JAM)


prog: sof
	$(QUARTUS_DIR)quartus_pgm --no_banner \
		-c "USB-Blaster on $(TARGET_IP) [$(TARGET_PORT)]" -m jtag \
		-o "P;$(SOF)@$(TARGET_CHIP)"

prog_pof: pof
	$(QUARTUS_DIR)quartus_pgm --no_banner \
	  -c "USB-Blaster on $(TARGET_IP) [$(TARGET_PORT)]" -m jtag \
	  -o "BVP;$(POF)@$(TARGET_CHIP)"

prog_rbf: rbf
	$(QUARTUS_DIR)quartus_pgm --no_banner \
	  -c "USB-Blaster on $(TARGET_IP) [$(TARGET_PORT)]" -m jtag \
	  -o "BVP;$(RBF)@$(TARGET_CHIP)"


# report compilation time and timing summary
report:
	# TODO


clean:
	# clean common junk files
	rm -rfv *.qws
	rm -rfv *_assignment_defaults.qdf
	rm -rfv c5_pin_model_dump.txt
	rm -rfv *ipregen.rpt
	rm -rfv .qsys_edit/
	# clean compilation databases
	rm -rfv db/ incremental_db/ greybox_tmp/
	# clean output directory
	rm -rfv out/
	# clean hard memory controller
	rm -rfv *_ddr3_0_p0_0_summary.csv
	# clean design space explorer files
	rm -rfv dse/ dse1_base.qpf dse1_base.qsf $(PROJ).dse.rpt $(PROJ).archive.rpt
	# clean early power estimator files
	rm -rfv *_early_pwr.csv
	# TODO: add project-specific files to remove here



dse: $(DSE_CONFIG)
	$(QUARTUS_DIR)quartus_dse --no_banner \
	            --terminate off \
	            --num-parallel-processors 10 \
	            --auto-discover-files on \
	            --revision $(PROJ) $(PROJ).qpf \
	            --use-dse-file $(DSE_CONFIG)


sim: $(SRCS)
	modelsim -do compile.tcl

sim_clean:


gtkwave: $(SRCS)
	# creating VVP file
	iverilog -Wall -g2012 -o iverilog_sim.vvp -s $(SRCS)
	# creating VCD file
	vvp -v iverilog_sim.vvp
	# creating settings file for gtkwave on-the-fly
	echo fontname_waves Verdana 9 > .\gtkwaverc
	echo fontname_signals Verdana 9 >> .\gtkwaverc
	echo fontname_logfile Verdana 9 >> .\gtkwaverc
	echo splash_disable 1 >> .\gtkwaverc
	echo use_roundcaps 1 >> .\gtkwaverc
	echo force_toolbars 1 >> .\gtkwaverc
	echo left_justify_sigs 1 >> .\gtkwaverc
	# launching gtkwave
	# press CTRL+S to save vawe config. gtkwave will open it automatically next time
	gtkwave -r .\gtkwaverc iverilog_sim.vcd wave.gtkw

	#   // place this code into your testbench and add signals you want to dump
	#   //   and navigate during simulation
	#   initial begin
	#     $dumpfile("iverilog_sim.vcd");
	#     $dumpvars( 0, M );
	#     #10000 $finish;
	#   end


stp:
	$(QUARTUS_DIR)quartus_stp --no_banner \
		$(QPF)



