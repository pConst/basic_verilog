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

/** Assembly instruction factory for PicoBlaze-2. */
public class Instruction2 extends Instruction {

	static final String[] opname = {
		"add",
		"addcy",
		"and",
		"or",
		"rl",
		"sl0",
		"sl1",
		"sla",
		"slx",
		"rr",
		"sr0",
		"sr1",
		"sra",
		"srx",
		"sub",
		"subcy",
		"xor",
		"call",
		"interrupt",
		"enable",
		"disable",
		"input",
		"jump",
		"load",
		"output",
		"return",
		"returni",
	};

	static final int[] opcode = {
		0x04<<13, // add
		0x05<<13, // addcy
		0x01<<13, // and
		0x02<<13, // or
		0x14<<13|0x2, // rl
		0x14<<13|0x6, // sl0
		0x14<<13|0x7, // sl1
		0x14<<13|0x0, // sla
		0x14<<13|0x4, // slx
		0x14<<13|0xc, // rr
		0x14<<13|0xe, // sr0
		0x14<<13|0xf, // sr1
		0x14<<13|0x8, // sra
		0x14<<13|0xa, // srx
		0x06<<13, // sub
		0x07<<13, // subcy
		0x03<<13, // xor
		0x1b<<13, // call
		0x1e<<13, // interrupt
		0x1e<<13, // interrupt
		0x1e<<13, // interrupt
		0x10<<13, // input
		0x1a<<13, // jump
		0x00<<13, // load
		0x11<<13, // output
		0x12<<13, // return
		0x16<<13, // returni
	};

	public Instruction2() {
		super(opname, opcode);
		ifz = 0x4<<10;
		ifnz = 0x5<<10;
		ifc = 0x6<<10;
		ifnc = 0x7<<10;
		implied = 0<<16;
		register = 1<<16;
		disable = 0<<0;
		enable = 1<<0;
		posx = 8;
		posy = 3;
	}

	public int code(String insn, Vector arg, Environment env)
	throws IllegalArgumentException {
		String ins = insn.toLowerCase();
		if (!map.containsKey(ins))
			throw new IllegalArgumentException(
				"Unrecognized instruction '" + ins + "'"
				);
		int ic = map.get(ins);

		if (
			ins.equalsIgnoreCase("add")
			|| ins.equalsIgnoreCase("addcy")
			|| ins.equalsIgnoreCase("and")
			|| ins.equalsIgnoreCase("or")
			|| ins.equalsIgnoreCase("sub")
			|| ins.equalsIgnoreCase("subcy")
			|| ins.equalsIgnoreCase("xor")
			|| ins.equalsIgnoreCase("input")
			|| ins.equalsIgnoreCase("output")
			|| ins.equalsIgnoreCase("load")
		) {
			if (arg == null || arg.size() != 2)
				throw new IllegalArgumentException();
			// find target/first operand register
			Integer a = env.resolve(arg.get(0), Symbol.Type.REGISTER);
			if (a == null) throw new IllegalArgumentException();

			// find second operand
			Object b = arg.get(1);
			if (b == null) throw new IllegalArgumentException();

			// implied integer value operand
			if (b instanceof Integer)
				return ic|implied|(a<<posx)|((Integer)b);
			// search symbol
			else {
				Symbol s = env.symbols.get((String)b);
				if (s == null) {
					Integer x = env.resolve((String)b);
					if (x != null) return ic|implied|(a<<posx)|x; // implied hex
					else throw new IllegalArgumentException();
				}
				else {
					if (s.type == Symbol.Type.REGISTER)
						return ic|register|(a<<posx)|(((Integer)s.value)<<posy);
					else
						return ic|implied|(a<<posx)|((Integer)s.value);
				}
			}
		}
		else if (
			ins.equalsIgnoreCase("rl")
			|| ins.equalsIgnoreCase("sl0")
			|| ins.equalsIgnoreCase("sl1")
			|| ins.equalsIgnoreCase("sla")
			|| ins.equalsIgnoreCase("slx")
			|| ins.equalsIgnoreCase("rr")
			|| ins.equalsIgnoreCase("sr0")
			|| ins.equalsIgnoreCase("sr1")
			|| ins.equalsIgnoreCase("sra")
			|| ins.equalsIgnoreCase("srx")
		) {
			if (arg == null || arg.size() != 1)
				throw new IllegalArgumentException("Bad shift/rotate arguments");
			// find target/first operand register
			Integer a = env.resolve(arg.get(0), Symbol.Type.REGISTER);
			if (a == null) throw new IllegalArgumentException();
			return ic|(a<<posx);
		}
		else if (
			ins.equalsIgnoreCase("call")
			|| ins.equalsIgnoreCase("jump")
		) {
			Object a = null, b = null;
			int l = (arg == null) ? 0 : arg.size();
			if (l > 2) throw new IllegalArgumentException();
			if (l > 0) a = arg.get(0);
			if (l > 1) b = arg.get(1);


			if (l == 1) {
				if (a instanceof Integer) return ic|((Integer)a);
				else if (a instanceof String) {
					Symbol s = env.symbols.get(a);
					if (s == null || s.type == Symbol.Type.REGISTER) throw new IllegalArgumentException();
					return ic|((Integer)s.value);
				}
			}
			else if (l == 2) {
				// a is condition code
				if (!(a instanceof String)) throw new IllegalArgumentException();

				if (b instanceof Integer)
					return ic|translateCondition((String)a)|((Integer)b);
				else if (b instanceof String) {
					Symbol s = env.symbols.get((String)b);
					if (s == null) {
						Integer x = env.resolve((String)b);
						if (x!= null) return ic|translateCondition((String)a)|x;
						else throw new IllegalArgumentException();
					}
					else if (s.type == Symbol.Type.REGISTER) throw new IllegalArgumentException();

					return ic|translateCondition((String)a)|((Integer)s.value);
				}
			}
		}
		else if (
			ins.equalsIgnoreCase("return")
			|| ins.equalsIgnoreCase("returni")
			|| ins.equalsIgnoreCase("interrupt")
		) {
			Object a = null;
			int l = (arg == null) ? 0 : arg.size();
			if (l > 1) throw new IllegalArgumentException();
			if (l == 1) a = arg.get(0);

			if (l == 0) {
				if (ins.equalsIgnoreCase("return")) return ic;
			}
			else {
				if (!(a instanceof String)) throw new IllegalArgumentException();
				if (ins.equalsIgnoreCase("return")) return ic|translateCondition((String)a);
				else return ic|translateAction((String)a);
			}
		}
		else if (
			ins.equalsIgnoreCase("enable")
			|| ins.equalsIgnoreCase("disable")
		) {
			Object a = null;
			int l = (arg == null) ? 0 : arg.size();
			if (arg == null || arg.size() != 1) throw new IllegalArgumentException();
			a = arg.get(0);
			if (!(a instanceof String) || !((String)a).equalsIgnoreCase("interrupt"))
				throw new IllegalArgumentException();
			return ic|translateAction(ins);
		}

		throw new IllegalArgumentException();
	}

}

