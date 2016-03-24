KCASM1 = java -Dkcpsm=1 -Dbram=16 -Dmodule=$*_rom -jar ../KCAsm.jar
KCASM2 = java -Dkcpsm=2 -Dbram=18 -Dmodule=$*_rom -jar ../KCAsm.jar
KCASM3 = java -Dkcpsm=3 -Dbram=18 -Dmodule=$*_rom -jar ../KCAsm.jar

KCASM = $(KCASM3)

SRC = $(wildcard *.psm)
OBJ = $(SRC:%.psm=%.rmh)

all: ../KCAsm.jar $(OBJ)

../KCAsm.jar:
	cd ..; ant jar

%.rmh %_rom.v: %.psm
	$(KCASM) $^ $@

clean:
	$(RM) *.rmh *_rom.v

distclean: clean
	$(RM) *.bak
