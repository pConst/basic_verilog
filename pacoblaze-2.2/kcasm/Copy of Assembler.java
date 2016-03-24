/*
	Copyright (c) 2004, 2006 Pablo Bleyer Kocik.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	1. Redistributions of source code must retain the above copyright notice, this
	list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright notice,
	this list of conditions and the following disclaimer in the documentation
	and/or other materials provided with the distribution.

	3. The name of the author may not be used to endorse or promote products
	derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
	EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
	IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/

import java.util.Vector;
import java.util.TreeSet;
import java.util.Formatter;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/** Base PicoBlaze assembler. */
public abstract class Assembler {

	/** Assembled program. */
	public int[] program;
	/** Program listing. **/
	public String[] listing;
	/** Program environment. */
	public Environment environment;
	/** Address representation width. */
	public int address_width;
	/** Data (opcode) representation width. */
	public int data_width;

	/** Create a new assembler.
		@param n program size
		@param a address representation width
		@param d data representation width
	*/
	public Assembler(int n, int a, int d) {
		environment = new Environment();
		program = new int[n];
		for (int i=0; i<program.length; ++i) program[i] = 0;
		address_width = a;
		data_width = d;
	}

	/** Assemble instruction.
		@param n instruction name
		@param a literal arguments
	*/
	public abstract int code(String n, Vector a);

	/** Parse expressions for symbols.
		@param exp vector of expressions
	*/
	void parse(Vector<AsmExpression> exp) {
		if (exp == null) return;

		int pc = 0; // program counter
		Vector<Label> lbl = null; // label(s) for this symbol (if any)

		for (AsmExpression e: exp) {
			if (e.empty()) continue;

			if (e instanceof Label) { // add label
				if (lbl == null) lbl = new Vector<Label>(); // new label frame
				lbl.add((Label)e);
				// environment.symbols.put(c.name, new Symbol(Symbol.Type.LABEL, pc));
			}
			else if (e instanceof Command) { // add command
				Command c = (Command)e;
				Object value = null; // current context value (ie label value)

				// add a constant: 'constant' {name:String} {value:Integer}
				if (c.name.equalsIgnoreCase("constant")) {
					if (c.list == null
						|| c.list.size() != 2
						|| !(c.list.get(0) instanceof String || c.list.get(0) instanceof Integer)
						) throw new IllegalArgumentException("Bad constant declaration: " + c.toString() + " at line " + c.line);
					String name = (String)c.list.get(0);
					value = c.list.get(1);
					if (value instanceof String) {
						try {
							value = Integer.valueOf((String)value, 16);
						}
						catch (NumberFormatException ex) { throw new IllegalArgumentException("Bad constant declaration: " + c.toString() + " at line " + c.line); }
					}
					environment.symbols.put(name, new Symbol(Symbol.Type.CONSTANT, value));
				}
				// change address: 'address' {addr:Integer}
				else if (c.name.equalsIgnoreCase("address")) {
					if (c.list == null
						|| c.list.size() != 1
						|| !(c.list.get(0) instanceof String || c.list.get(0) instanceof Integer)
						) throw new IllegalArgumentException("Bad address declaration: " + c.toString() + " at line " + c.line);
					value = c.list.get(0);
					if (value instanceof String) {
						try {
							value = Integer.valueOf((String)value, 16);
						}
						catch (NumberFormatException ex) { throw new IllegalArgumentException("Bad address declaration: " + c.toString() + " at line " + c.line); }
					}
					pc = ((Integer)value).intValue();
				}
				// add register alias: 'register' {name:String} {value:Integer}
				else if (c.name.equalsIgnoreCase("register")) {
					if (c.list == null
						|| c.list.size() != 2
						|| !(c.list.get(0) instanceof String)
						|| !(c.list.get(1) instanceof String || c.list.get(1) instanceof Integer)
						) throw new IllegalArgumentException("Bad register declaration: " + c.toString() + " at line " + c.line);
					String name = (String)c.list.get(0);
					value = c.list.get(1);
					if (value instanceof String) {
						try {
							String sv = (String)value;
							if (sv.charAt(0) != 's' && sv.charAt(0) != 'S') throw new NumberFormatException();
							value = Integer.valueOf(sv.substring(1), 16);
						}
						catch (NumberFormatException ex) { throw new IllegalArgumentException("Bad register declaration: " + c.toString() + " at line " + c.line); }
					}
					environment.symbols.put(name, new Symbol(Symbol.Type.REGISTER, value));
				}
				else if (c.name.equalsIgnoreCase("namereg")) {
					if (c.list == null
						|| c.list.size() != 2
						|| !(c.list.get(1) instanceof String)
						|| !(c.list.get(0) instanceof String || c.list.get(0) instanceof Integer)
						) throw new IllegalArgumentException("Bad register declaration: " + c.toString() + " at line " + c.line);
					String name = (String)c.list.get(1);
					value = c.list.get(0);
					if (value instanceof String) {
						try {
							String sv = (String)value;
							if (sv.charAt(0) != 's' && sv.charAt(0) != 'S') throw new NumberFormatException();
							value = Integer.valueOf(sv.substring(1), 16);
						}
						catch (NumberFormatException ex) { throw new IllegalArgumentException("Bad register declaration: " + c.toString() + " at line " + c.line); }
					}
					environment.symbols.put(name, new Symbol(Symbol.Type.REGISTER, value));
				}
				// else, assume code and increment program counter
				else {
					value = new Integer(pc);
					++pc;
				}

				// associate labels with current context value
				if (lbl != null) { // we have labels
					for (Label t: lbl)
						environment.symbols.put(t.name, new Symbol(Symbol.Type.LABEL, value));
					lbl = null; // clear labels
				}

			}
		}
	}

	/** Assemble a vector of expressions.
		@param exp vector of expressions
	*/
	void assemble(Vector<AsmExpression> exp) {
		if (exp == null) return;

		int pc = 0; // program counter
		Vector<String> lst = new Vector<String>(); // program listing strings
		int cl = -1; // current line number

		for (AsmExpression e: exp) {
			if (e.empty()) continue;

			// label found
			if (e instanceof Label) {
				lst.add("// @" + String.format("%0" + address_width + "x", pc) + " #" + e.line + ": " + e.toString());
				cl = e.line;
			}
			// comment found
			else if (e instanceof Comment) {
				if (e.line == cl) { // in-line comment
					String s = lst.lastElement() + " " + e.toString();
					lst.setElementAt(s, lst.size()-1);
				}
				else lst.add("// #" + e.line + ": " + e.toString()); // single line
			}
			// command found
			else if (e instanceof Command) {
				Command c = (Command)e;
				String s = "";
				cl = c.line;

				// assign new pc
				if (c.name.equalsIgnoreCase("address")) {
					pc = ((Integer)c.list.get(0)).intValue();
					lst.add(
						"@"
						+ String.format("%0" + address_width + "x", pc)
						+ " // #" + c.line + ": " + c.toString()
						);
				}
				// possible instruction found, attempt assembly
				else if (!c.name.equalsIgnoreCase("constant")
					&& !c.name.equalsIgnoreCase("register")
					&& !c.name.equalsIgnoreCase("namereg")
				) {
//					Class c = getClass();
//					Class[] ca = new Class[] {java.util.Vector.class};
//					Method m = c.getDeclaredMethod("_" + c.name, ca);
//					Object[] oa = new Object[] {c.list};
//					int o = ((Integer)m.invoke(this, oa)).intValue();

					int o;
					try {
						o = code(c.name, c.list);
					}
					catch (IllegalArgumentException x) {
						throw new IllegalArgumentException(
							x.getMessage() + " at line " + c.line
						);
					}

					program[pc] = o; // assign opcode to program memory
					// add instruction to listing
					s += String.format("%0" + data_width + "x", o) + " ";
					lst.add(s + "// @" + String.format("%0" + address_width + "x", pc) + " #" + c.line + ": " + c.toString());
					++pc; // advance program counter
				}
				// non-instruction command
				else lst.add(s + "// #" + c.line + ": " + c.toString());
			}
		}

		listing = new String[lst.size()];
		for (int j=0; j<lst.size(); ++j) listing[j] = lst.get(j);
	}

	/** Generate Verilog readmemh-compatible listing file. */
	public String toString() {
		StringBuffer b = new StringBuffer();

		// print symbol table
		b.append("/* Symbol Table */\n");
		TreeSet<String> t = new TreeSet<String>(environment.symbols.keySet());
		for (String k: t) {
			b.append ("// " + k + " = ");
			Symbol s = environment.symbols.get(k);
			if (s != null) b.append(s.toString());
			b.append("\n");
		}

		b.append("\n");

		// print program code
		b.append("/* Program Code */\n");
		for (int j=0; j<listing.length; ++j) {
			b.append(listing[j]);
			b.append("\n");
		}

		return b.toString();
	}

//	public void toVerilog(String fn)
//	throws IOException {
//		FileWriter fw = new FileWriter(new File(fn + ".v"));
//		Formatter1 fm = new Formatter1();
//		fw.write(fm.formatVerilog(fn, program));
//		fw.close();
//	}

	/** Generate Verilog ROM file.
		@param n Verilog module name
		@return Verilog module BlockRAM declaration
	*/
	public abstract String toBlockRAM(String n);
}
