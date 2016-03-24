#
# PacoBlaze Makefile
#

# Path for the Xilinx sources
XILINX = ../xilinx

# Xilinx implementation of PicoBlaze
KCPSM2 = $(XILINX)/kcpsm2.v
KCPSM3 = $(XILINX)/kcpsm3.v
UNISIMS = $(wildcard $(XILINX)/unisims/*.v)

# Verilog engine
VERILOG = cver
#VERILOG = iverilog
# Icarus Verilog processed verilog file
VVP = vvp
# Verilog to HTML
V2HTML = v2html

# Instance of PacoBlaze we want to use
PACOBLAZE = PACOBLAZE3
# The test file used to run simulation testbenches
TEST_FILE = "../test/adc_ctrl.rmh"
# Number of clock cycles to run the simulation
TEST_CYCLES = 2000
# Clock cycle where to assert the interrupt request to the uC
TEST_IRQ = 100

# Command line for Cver
ifeq ($(VERILOG),cver)
VDEF = +define+HAS_DEBUG +define+TEST_FILE="\"$(TEST_FILE)\"" +define+TEST_CYCLES=$(TEST_CYCLES) +define+TEST_IRQ=$(TEST_IRQ) +define+USE_ONEHOT_ENCODING # +define+$(PACOBLAZE)
endif

# Command line for Icarus
ifeq ($(VERILOG),iverilog)
VDEF = -DHAS_DEBUG -DTEST_FILE="\"$(TEST_FILE)\"" -DTEST_CYCLES=$(TEST_CYCLES) -DTEST_IRQ=$(TEST_IRQ) -DUSE_ONEHOT_ENCODING # -D$(PACOBLAZE)
endif

# Flags for v2html
V2HTMLFLAGS = -m "pablo.N@SPAM.bleyer.org" -htf -ni -h index.html -s -tab 2

.SECONDARY: .vcd

# Main target
all: pacoblaze3_tb.vcd

# Cver rules
pacoblaze_idu_tb.vcd: pacoblaze3.v pacoblaze_idu_tb.v
pacoblaze_dregister_tb.vcd: pacoblaze_dregister.v pacoblaze_dregister_tb.v

pacoblaze1_tb.vcd: blockram.v pacoblaze1.v pacoblaze1_tb.v
pacoblaze3_tb.vcd: blockram.v pacoblaze3.v pacoblaze3_tb.v
pacoblaze3b_tb.vcd: blockram.v pacoblaze3.v pacoblaze3b_tb.v

compare3_tb.vcd: blockram.v pacoblaze3.v $(KCPSM3) $(UNISIMS) compare3_tb.v
cmprnd3_tb.vcd: blockram.v pacoblaze3.v $(KCPSM3) $(UNISIMS) cmprnd3_tb.v
compare3m_tb.vcd: blockram.v pacoblaze3m.v $(KCPSM3) $(UNISIMS) compare3m_tb.v

pacoblaze3m_tb.vcd: blockram.v pacoblaze3m.v pacoblaze3m_tb.v

addsub_tb.vcd: addsub.v addsub_tb.v

# Icarus rules
pacoblaze3_tb.vvp: blockram.v pacoblaze3.v pacoblaze3_tb.v

# Make the Verilog code documentation with v2html
doc: $(wildcard *.v)
	-mkdir doc
	cp $^ doc
	cd doc; $(V2HTML) $(V2HTMLFLAGS) $^

# Create a value change dump (vcd) file from a verilog source
%.vcd: %.v
	$(VERILOG)  $(VDEF) $^

# Create an Icarus processed file from a verilog source
%.vvp: %.v
	$(VERILOG) -o $@ $^

# Create a value change dump (vcd) file from an Icarus vvp
%.vcd: %.vvp
	$(VVP) $^

# Clean simulation and intermediate files
clean:
	$(RM) *.vvp *.vcd

# Clean everything
distclean: clean
	$(RM) *.bak
	$(RM) -r doc


