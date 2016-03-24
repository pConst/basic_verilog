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
import java.util.ListIterator;

/** Assembly command expression. */
public class Command extends AsmExpression {
	/** Command name. */
	public String name;
	/** Command arguments list. */
	public Vector list;

	public Command() {
	}

	/** Creates a command with specified name and argument list.
		@param s command name
		@param a argument list vector
	*/
	public Command(String s, Vector a) {
		name = s;
		list = a;
	}

	/** Creates a command with specified name, argument list and line number.
		@param l line number
		@param s command name
		@param a argument list vector
	*/
	public Command(int l, String s, Vector a) {
		super(l);
		name = s;
		list = a;
	}

	public String toString() {
		StringBuffer b = new StringBuffer();

//		b.append("#" + line + ": ");
		b.append(name);
		if (list != null) {
			b.append("(");
			ListIterator i = list.listIterator();
			while (i.hasNext()) {
				b.append(i.next());
				if (i.hasNext()) b.append(",");
				else b.append(")");
			}
		}

		return b.toString();
	}
}
