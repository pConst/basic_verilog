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

import java.util.HashMap;

/** Assembly environment class, stores assembly symbol information. */
public class Environment {

	/** Default register names. */
	static final String[] registers = {
		"s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
		"s8", "s9", "sA", "sB", "sC", "sD", "sE", "sF"
	};

	/** Symbol map stores constant names and values. */
	public HashMap<String,Symbol> symbols;

	public Environment() {
		symbols = new HashMap<String,Symbol>();

		// store default register names
		for (int i=0; i<=0xf; ++i)
			symbols.put(registers[i], new Symbol(Symbol.Type.REGISTER, i));
	}

//	Object getValue(String name) {
//		Symbol r = (Symbol)symbols.get(name);
//		// if (r.type != type) return null;
//		if (r) return r.value;
//		else return null;
//	}
//
//	Symbol getSymbol(String name) {
//		return (Symbol)symbols.get(name);
//	}
//
//	void putSymbol(String name, Symbol symbol) {
//		symbols.put(name, symbol);
//	}

	/** Resolve object within environment context.
		@param o object to resolve
		@return object integer value if resolved, null otherwise.
	*/
	public Integer resolve(Object o) {
		if (o instanceof Integer) return (Integer)o; // idempotent
		else if (o instanceof String) {
			Symbol s = symbols.get(o); // lookup symbol
			if (s != null) return (Integer)s.value; // return symbol value
			else { // attempt to convert it to an hex number
				try { return new Integer(Integer.valueOf((String)o, 16)); }
				catch (NumberFormatException e) { }
			}
		}
		return null;
	}

	/** Resolve object within environment context and specified type.
		@param o object to resolve
		@param t object type
		@return object integer value if resolved and type matches, null otherwise.
	*/
	public Integer resolve(Object o, Symbol.Type t) {
		if (o instanceof Integer) return (Integer)o; // idempotent
		else if (o instanceof String) {
			Symbol s = symbols.get(o); // lookup symbol
			if (s != null && s.type == t) return (Integer)s.value; // return value if type coincides
		}
		return null;
	}

	public String toString() {
		StringBuffer b = new StringBuffer();
		for (Object s: symbols.keySet())
			b.append(s.toString() + ":" + symbols.get(s).toString() + "\n");
		return b.toString().trim();
	}

}
