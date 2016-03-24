JAVAC = javac -g # -Xlint:unchecked
JAVACC = javacc
JAR = jar
JAVADOC = javadoc

JSRC = Assembler.java Environment.java \
	AsmExpression.java Label.java Command.java Comment.java \
	Symbol.java Instruction.java \
	Instruction1.java Assembler1.java \
	Instruction2.java Assembler2.java \
	Instruction3.java Assembler3.java

JCCSRC = KCAsm.jj
JCCGEN = TokenMgrError.java ParseException.java Token.java \
	SimpleCharStream.java \
	$(JCCSRC:%.jj=%)Constants.java $(JCCSRC:%.jj=%)TokenManager.java

JCFLAGS =
JCCFLAGS =

.SECONDARY: .java
.PHONY: doc

JARFILE = ../KCAsm.jar

all: $(JARFILE)

%.java: %.jj
	$(JAVACC) $(JCCFLAGS) $^

$(JCCGEN): $(JCCSRC:%.jj=%.java)

%.class: $(JCCSRC:%.jj=%.java) $(JCCGEN) $(JSRC)
	$(JAVAC) $(JCFLAGS) $^

$(JARFILE): KCAsm.class MANIFEST.MF
	$(JAR) cfm $@ MANIFEST.MF *.class

doc: $(JSRC)
	$(JAVADOC) -d doc $^

clean:
	$(RM) $(JCCGEN) $(JCCSRC:%.jj=%.java) *.class

distclean: clean
	$(RM) *.bak
	$(RM) $(JARFILE)
	$(RM) -r doc

