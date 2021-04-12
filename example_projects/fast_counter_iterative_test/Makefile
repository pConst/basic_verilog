#------------------------------------------------------------------------------
# Makefile for iterative compilation for Intel / Altera Quartus
# Konstantin Pavlov, pavlovconst@gmail.com
#
#
# INFO ------------------------------------------------------------------------
#
# - This is a top-level Makefile
# - It makes a bunch of Quartus project copies which differ only one variable
# - Then it compiles all projects in parallel and collects FMAX data
#
# - Please define var sweep range below
# - Separate quartus project will be created and compiled for every var value
#
# - This makefile is "make -j"-friendly
#


VAR_START = 5
VAR_STOP = 32
VAR = $(shell seq $(VAR_START) ${VAR_STOP})

JOBS = $(addprefix job,${VAR})


.PHONY: all report clean


all: fmax
	echo '$@ success'

${JOBS}: job%:
	mkdir -p ./$*; \
	cp ./base/* ./$*; \
	echo "\`define WIDTH $*" > ./$*/define.vh; \
	$(MAKE) -C ./$* stap

fmax: ${JOBS}
	echo '# FMAX summary report for iterative compilation' > ./fmax.csv; \
	for (( var = $(VAR_START); var <= $(VAR_STOP); var++ )); do \
		{ echo $$var ', '; \
			cat ./$$var/OUTPUT/test.sta.rpt | \
			grep -A2 '; Fmax       ; Restricted Fmax ; Clock Name ; Note ;' | \
			tail -n1 | cut -d\; -f3 | cut -d' ' -f2; echo ', '; \
		cat ./$$var/OUTPUT/test.sta.rpt | \
		grep -A3 '; Fmax       ; Restricted Fmax ; Clock Name ; Note ;' | \
			tail -n1 | cut -d\; -f3 | cut -d' ' -f2; } >> ./fmax.csv; \
	done; \
	echo 'fmax.csv file done'

report: ./fmax.csv
	cat ./fmax.csv

clean:
	for (( var = $(VAR_START); var <= $(VAR_STOP); var++ )); do \
		rm -rfv ./$$var; \
		rm -rfv ./fmax.csv; \
	done

