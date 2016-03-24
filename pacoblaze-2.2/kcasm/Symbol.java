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

/** Class to store assembly symbol information. */
public class Symbol {

	public enum Type {
		/** Symbols with no type. */
		NONE,
		/** Symbol is a register. */
		REGISTER,
		/** Symbol is a constant value. */
		CONSTANT,
		/** Symbol is a label. */
		LABEL
	};

	/** The type of the symbol. */
	public Type type;
	/** The value of the symbol. */
	public Object value;

	public Symbol() {
		type = Type.NONE;
		value = null;
	}

	/** Create a symbol with type NONE and specified value.
		@param v value object
	*/
	public Symbol(Object v) {
		type = Type.NONE;
		value = v;
	}

	/** Create a symbol with specified type and value.
		@param t symbol type
		@param v value object
	*/
	public Symbol(Type t, Object v) {
		type = t;
		value = v;
	}

	/** Create a symbol with type NONE and integer value.
		@param v integer value
	*/
	public Symbol(int v) {
		type = Type.NONE;
		value = new Integer(v);
	}

	/** Create a symbol with specified type and integer value.
		@param t symbol type
		@param v integer value
	*/
	public Symbol(Type t, int v) {
		type = t;
		value = new Integer(v);
	}

	public String toString() {
//		if (value instanceof Integer)
//			return type.toString() + ": " + numberFormat((Integer)value);
//		else
			return type.toString() + ": " + value.toString();
	}

	/** Format number representations.
		@param v integer value
		@return string representation
	*/
	public static String numberFormat(int v) {
		StringBuffer b = new StringBuffer();
		b.append("%" + Integer.toString(v, 2));
		b.append(" @" + Integer.toString(v, 8));
		b.append(" &" + Integer.toString(v, 10));
		b.append(" $" + Integer.toString(v, 16));
		return b.toString();
	}

	public static void main(String[] args) {
		Symbol s = new Symbol(Symbol.Type.LABEL, "The value");
		System.out.println(s.toString());
	}
}
