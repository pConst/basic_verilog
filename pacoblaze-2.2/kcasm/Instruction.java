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
import java.util.HashMap;

/** Base class for PicoBlaze instruction factory. */
public abstract class Instruction {

	static int
		ifz,
		ifnz,
		ifc,
		ifnc,
		implied,
		register,
		disable,
		enable,
		posx,
		posy;
	/** Maps opcode names to values. */
	static HashMap<String,Integer> map;

	/** Create new instruction initializing opcode map.
		@param opname opcode names array
		@param opcode opcode values array
	*/
	public Instruction(String[] opname, int[] opcode) {
		if (map != null) return;
		map = new HashMap<String,Integer>();
		for (int i=0; i<opname.length; ++i)
			map.put(opname[i], new Integer(opcode[i]));
	}

	/** Code instruction.
		@param n instruction name
		@param a instruction argument list
		@param e assembly environment
		@return opcode value
	*/
	public abstract int code(String n, Vector a, Environment e);

	/** Convert condition name to value.
		@param c condition name
		@return condition value
	*/
	public static int translateCondition(String c) {
		if (c.equalsIgnoreCase("z")) return ifz;
		else if (c.equalsIgnoreCase("nz")) return ifnz;
		else if (c.equalsIgnoreCase("c")) return ifc;
		else if (c.equalsIgnoreCase("nc")) return ifnc;
		else throw new IllegalArgumentException("Invalid condition value");
	}

	/** Convert action name to value.
		@param a action name
		@return action value
	*/
	public static int translateAction(String a) {
		if (a.equalsIgnoreCase("disable")) return disable;
		else if (a.equalsIgnoreCase("enable")) return enable;
		else throw new IllegalArgumentException("Invalid action value");
	}

}
