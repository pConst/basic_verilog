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

/** @file
	PacoBlaze definitions include file.
*/

`ifndef PACOBLAZE_INC_V_
`define PACOBLAZE_INC_V_

`define HAS_RESET_LATCH
//`define USE_ONEHOT_ENCODING

`ifdef PACOBLAZE3
	`define HAS_INTERRUPT_ACK
	`define HAS_SCRATCH_MEMORY
	`define HAS_COMPARE_OPERATION
	`define HAS_TEST_OPERATION
`endif

`ifdef PACOBLAZE3M
	`define HAS_INTERRUPT_ACK
	`define HAS_SCRATCH_MEMORY
	`define HAS_COMPARE_OPERATION
	`define HAS_TEST_OPERATION
	`define HAS_MUL_OPERATION
	`define HAS_WIDE_ALU
`endif

`ifdef HAS_DEBUG
`define idu_debug_width 32
`define alu_debug_width 27
`endif

`define operand_width 8 ///< Operand width

/** Instruction memory data, address width */
`ifdef PACOBLAZE1
	`define code_width 16
	`define code_depth 8 // 256 instructions
`endif
`ifdef PACOBLAZE2
	`define code_width 18
	`define code_depth 10 // 1024 instructions
`endif
`ifdef PACOBLAZE3
	`define code_width 18
	`define code_depth 10 // 1024 instructions
`endif
`ifdef PACOBLAZE3M
	`define code_width 18
	`define code_depth 10 // 1024 instructions
`endif
`define code_size (1<<`code_depth) ///< Instruction memory size

`define port_width `operand_width ///< Port IO data width
`define port_depth `operand_width ///< Port id (address) width
`define port_size (1<<`port_depth) ///< Port size

`define stack_width `code_depth ///< Call/return stack width
/** Call/return stack depth */
`ifdef PACOBLAZE1
	`define stack_depth 4
`endif
`ifdef PACOBLAZE2
	`define stack_depth 5
`endif
`ifdef PACOBLAZE3
	`define stack_depth 5
`endif
`ifdef PACOBLAZE3M
	`define stack_depth 5
`endif
`define stack_size (1<<`stack_depth) ///< Call/return stack size

`define register_width `operand_width ///< Register file width
/** Register file depth */
`ifdef PACOBLAZE1
	`define register_depth 4
`endif
`ifdef PACOBLAZE2
	`define register_depth 5
`endif
`ifdef PACOBLAZE3
	`define register_depth 4
`endif
`ifdef PACOBLAZE3M
	`define register_depth 4
`endif
`define register_size (1<<`register_depth) ///< Register file size

`ifdef PACOBLAZE3
	`define scratch_width `operand_width ///< Scratchpad ram width
	`define scratch_depth 6 ///< Scratchpad ram depth
	`define scratch_size (1<<`scratch_depth) ///< Scratchpad ram size
`endif
`ifdef PACOBLAZE3M
	`define scratch_width `operand_width ///< Scratchpad ram width
	`define scratch_depth 6 ///< Scratchpad ram depth
	`define scratch_size (1<<`scratch_depth) ///< Scratchpad ram size
`endif

`ifdef USE_ONEHOT_ENCODING
`ifdef PACOBLAZE1
	`define operation_width 16
`endif
`ifdef PACOBLAZE2
	`define operation_width 16
`endif
`ifdef PACOBLAZE3
	`define operation_width 20
`endif
`ifdef PACOBLAZE3M
	`define operation_width (20+5) // mul+addw(cy)+subw(cy)
`endif
`else // !USE_ONEHOT_ENCODING
`ifdef PACOBLAZE1
	`define operation_width 4
`endif
`ifdef PACOBLAZE2
	`define operation_width 4
`endif
`ifdef PACOBLAZE3
	`define operation_width 5
`endif
`ifdef PACOBLAZE3M
	`define operation_width 5
`endif
`endif


`define reset_vector 0 ///< Reset vector
`define interrupt_vector (`code_size-1) ///< Interrupt vector


/** Operation string names */
`define os_load "load"
`define os_add "add"
`define os_addcy "addcy"
`define os_and "and"
`define os_or "or"
`define os_rs "rs"
	`define os_sr0 "sr0"
	`define os_sr1 "sr1"
	`define os_srx "srx"
	`define os_sra "sra"
	`define os_rr "rr"
	`define os_sl0 "sl0"
	`define os_sl1 "sl1"
	`define os_slx "slx"
	`define os_sla "sla"
	`define os_rl "rl"
`define os_sub "sub"
`define os_subcy "subcy"
`define os_xor "xor"
`define os_jump "jump"
`define os_call "call"
`define os_return "return"
`define os_returni "returni"
`define os_interrupt "interrupt"
`define os_input "input"
`define os_output "output"
`define os_invalid "(n/a)"
// PB3
`define os_compare "compare"
`define os_test "test"
`define os_fetch "fetch"
`define os_store "store"
// PB3M
`define os_mul "mul"
`define os_addw "addw"
`define os_addwcy "addwcy"
`define os_subw "subw"
`define os_subwcy "subwcy"

// flags
`define os_z "z "
`define os_nz "nz"
`define os_c "c "
`define os_nc "nc"
// interrupt
`define os_enable "enable "
`define os_disable "disable"


/** Conditional flags */
`define flag_z 2'b00 // zero set
`define flag_nz 2'b01 // zero not set
`define flag_c 2'b10 // carry set
`define flag_nc 2'b11 // carry not set

/** Rotate/shift operations */
`define opcode_rsc 2'b11 // shift constant
`define opcode_rsa 2'b00 // shift all (through carry)
`define opcode_rr 2'b10
`define opcode_slx 2'b10
`define opcode_rl 2'b01
`define opcode_srx 2'b01

`ifdef PACOBLAZE1
	`define opcode_reg 4'hc // register operation
	`define opcode_load 4'h0
	`define opcode_add 4'h4
	`define opcode_addcy 4'h5
	`define opcode_and 4'h1
	`define opcode_or 4'h2
	`define opcode_rs 4'hd
	`define opcode_sub 4'h6
	`define opcode_subcy 4'h7
	`define opcode_xor 4'h3

	`define opcode_ctl 3'b100 // flow control operation: jump, call, return(i), interrupt
		`define opcode_jump 2'b01
		`define opcode_call 2'b11
		`define opcode_return 4'b0010
		`define opcode_returni 4'b0011
		`define opcode_interrupt 4'b0000
	`define opcode_input 3'b101
	`define opcode_output 3'b111

`endif // PACOBLAZE1

`ifdef PACOBLAZE2
	`define opcode_load 4'h0
	`define opcode_add 4'h4
	`define opcode_addcy 4'h5
	`define opcode_and 4'h1
	`define opcode_or 4'h2
	`define opcode_rs 4'hc
	`define opcode_sub 4'h6
	`define opcode_subcy 4'h7
	`define opcode_xor 4'h3

	`define opcode_jump 4'ha // subop = 1
	`define opcode_call 4'hb
	`define opcode_return 4'ha // subop = 0
	`define opcode_returni 4'he // subop = 0
	`define opcode_interrupt 4'he // subop = 1

	`define opcode_input 4'h8
	`define opcode_output 4'h9
`endif // PACOBLAZE2

`ifdef PACOBLAZE3
	`define opcode_add 5'h0c
	`define opcode_addcy 5'h0d
	`define opcode_and 5'h05
	`define opcode_compare 5'h0a
	`define opcode_or 5'h06
	`define opcode_rs 5'h10
	`define opcode_sub 5'h0e
	`define opcode_subcy 5'h0f
	`define opcode_test 5'h09
	`define opcode_xor 5'h07

	`define opcode_call 5'h18
	`define opcode_interrupt 5'h1e
	`define opcode_fetch 5'h03
	`define opcode_input 5'h02
	`define opcode_jump 5'h1a
	`define opcode_load 5'h00
	`define opcode_output 5'h16
	`define opcode_return 5'h15
	`define opcode_returni 5'h1c
	`define opcode_store 5'h17
`endif // PACOBLAZE3

`ifdef PACOBLAZE3M
	`define opcode_add 5'h0c
	`define opcode_addcy 5'h0d
	`define opcode_and 5'h05
	`define opcode_compare 5'h0a
	`define opcode_or 5'h06
	`define opcode_rs 5'h10
	`define opcode_sub 5'h0e
	`define opcode_subcy 5'h0f
	`define opcode_test 5'h09
	`define opcode_xor 5'h07

	`define opcode_call 5'h18
	`define opcode_interrupt 5'h1e
	`define opcode_fetch 5'h03
	`define opcode_input 5'h02
	`define opcode_jump 5'h1a
	`define opcode_load 5'h00
	`define opcode_output 5'h16
	`define opcode_return 5'h15
	`define opcode_returni 5'h1c
	`define opcode_store 5'h17

	`define opcode_mul 5'h1f
	`define opcode_addw 5'h11
	`define opcode_addwcy 5'h12
	`define opcode_subw 5'h13
	`define opcode_subwcy 5'h14
`endif // PACOBLAZE3M


/** Exploded operations. ALU operations come first as ALU operation subset */
`ifdef PACOBLAZE1
`ifdef USE_ONEHOT_ENCODING
`define op_load 'h0
`define op_add 'h1
`define op_addcy 'h2
`define op_and 'h3
`define op_or 'h4
`define op_rs 'h5
`define op_sub 'h6
`define op_subcy 'h7
`define op_xor 'h8
`define op_jump 'h9
`define op_call 'ha
`define op_return 'hb
`define op_returni 'hc
`define op_interrupt 'hd
`define op_input 'he
`define op_output 'hf
`define ob_load (1<<`op_load)
`define ob_add (1<<`op_add)
`define ob_addcy (1<<`op_addcy)
`define ob_and (1<<`op_and)
`define ob_or (1<<`op_or)
`define ob_rs (1<<`op_rs)
`define ob_sub (1<<`op_sub)
`define ob_subcy (1<<`op_subcy)
`define ob_xor (1<<`op_xor)
`define ob_jump (1<<`op_jump)
`define ob_call (1<<`op_call)
`define ob_return (1<<`op_return)
`define ob_returni (1<<`op_returni)
`define ob_interrupt (1<<`op_interrupt)
`define ob_input (1<<`op_input)
`define ob_output (1<<`op_output)
`else // !USE_ONEHOT_ENCODING
`define op_load `opcode_load
`define op_add `opcode_add
`define op_addcy `opcode_addcy
`define op_and `opcode_and
`define op_or `opcode_or
`define op_rs `opcode_rs
`define op_sub `opcode_sub
`define op_subcy `opcode_subcy
`define op_xor `opcode_xor
`define op_jump `opcode_jump
`define op_call `opcode_call
`define op_return `opcode_return
`define op_returni `opcode_returni
`define op_interrupt `opcode_interrupt
`define op_input `opcode_input
`define op_output `opcode_output
`endif
`endif
`ifdef PACOBLAZE2
`ifdef USE_ONEHOT_ENCODING
`define op_load 'h0
`define op_add 'h1
`define op_addcy 'h2
`define op_and 'h3
`define op_or 'h4
`define op_rs 'h5
`define op_sub 'h6
`define op_subcy 'h7
`define op_xor 'h8
`define op_jump 'h9
`define op_call 'ha
`define op_return 'hb
`define op_returni 'hc
`define op_interrupt 'hd
`define op_input 'he
`define op_output 'hf
`define ob_load (1<<`op_load)
`define ob_add (1<<`op_add)
`define ob_addcy (1<<`op_addcy)
`define ob_and (1<<`op_and)
`define ob_or (1<<`op_or)
`define ob_rs (1<<`op_rs)
`define ob_sub (1<<`op_sub)
`define ob_subcy (1<<`op_subcy)
`define ob_xor (1<<`op_xor)
`define ob_jump (1<<`op_jump)
`define ob_call (1<<`op_call)
`define ob_return (1<<`op_return)
`define ob_returni (1<<`op_returni)
`define ob_interrupt (1<<`op_interrupt)
`define ob_input (1<<`op_input)
`define ob_output (1<<`op_output)
`else // !USE_ONEHOT_ENCODING
`define op_load `opcode_load
`define op_add `opcode_add
`define op_addcy `opcode_addcy
`define op_and `opcode_and
`define op_or `opcode_or
`define op_rs `opcode_rs
`define op_sub `opcode_sub
`define op_subcy `opcode_subcy
`define op_xor `opcode_xor
`define op_jump `opcode_jump
`define op_call `opcode_call
`define op_return `opcode_return
`define op_returni `opcode_returni
`define op_interrupt `opcode_interrupt
`define op_input `opcode_input
`define op_output `opcode_output
`endif
`endif
`ifdef PACOBLAZE3
`ifdef USE_ONEHOT_ENCODING
`define op_load 'h0
`define op_add 'h1
`define op_addcy 'h2
`define op_and 'h3
`define op_or 'h4
`define op_rs 'h5
`define op_sub 'h6
`define op_subcy 'h7
`define op_xor 'h8
`define op_jump 'h9
`define op_call 'ha
`define op_return 'hb
`define op_returni 'hc
`define op_interrupt 'hd
`define op_input 'he
`define op_output 'hf
`define op_compare 'h10
`define op_test 'h11
`define op_fetch 'h12
`define op_store 'h13
`define ob_load (1<<`op_load)
`define ob_add (1<<`op_add)
`define ob_addcy (1<<`op_addcy)
`define ob_and (1<<`op_and)
`define ob_or (1<<`op_or)
`define ob_rs (1<<`op_rs)
`define ob_sub (1<<`op_sub)
`define ob_subcy (1<<`op_subcy)
`define ob_xor (1<<`op_xor)
`define ob_jump (1<<`op_jump)
`define ob_call (1<<`op_call)
`define ob_return (1<<`op_return)
`define ob_returni (1<<`op_returni)
`define ob_interrupt (1<<`op_interrupt)
`define ob_input (1<<`op_input)
`define ob_output (1<<`op_output)
`define ob_compare (1<<`op_compare)
`define ob_test (1<<`op_test)
`define ob_fetch (1<<`op_fetch)
`define ob_store (1<<`op_store)
`else // !USE_ONEHOT_ENCODING
`define op_load `opcode_load
`define op_add `opcode_add
`define op_addcy `opcode_addcy
`define op_and `opcode_and
`define op_or `opcode_or
`define op_rs `opcode_rs
`define op_sub `opcode_sub
`define op_subcy `opcode_subcy
`define op_xor `opcode_xor
`define op_jump `opcode_jump
`define op_call `opcode_call
`define op_return `opcode_return
`define op_returni `opcode_returni
`define op_interrupt `opcode_interrupt
`define op_input `opcode_input
`define op_output `opcode_output
`define op_compare `opcode_compare
`define op_test `opcode_test
`define op_fetch `opcode_fetch
`define op_store `opcode_store
`endif
`endif
`ifdef PACOBLAZE3M
`ifdef USE_ONEHOT_ENCODING
`define op_load 'h0
`define op_add 'h1
`define op_addcy 'h2
`define op_and 'h3
`define op_or 'h4
`define op_rs 'h5
`define op_sub 'h6
`define op_subcy 'h7
`define op_xor 'h8
`define op_jump 'h9
`define op_call 'ha
`define op_return 'hb
`define op_returni 'hc
`define op_interrupt 'hd
`define op_input 'he
`define op_output 'hf
`define op_compare 'h10
`define op_test 'h11
`define op_fetch 'h12
`define op_store 'h13
`define op_mul 'h14
`define op_addw 'h15
`define op_addwcy 'h16
`define op_subw 'h17
`define op_subwcy 'h18
`define ob_load (1<<`op_load)
`define ob_add (1<<`op_add)
`define ob_addcy (1<<`op_addcy)
`define ob_and (1<<`op_and)
`define ob_or (1<<`op_or)
`define ob_rs (1<<`op_rs)
`define ob_sub (1<<`op_sub)
`define ob_subcy (1<<`op_subcy)
`define ob_xor (1<<`op_xor)
`define ob_jump (1<<`op_jump)
`define ob_call (1<<`op_call)
`define ob_return (1<<`op_return)
`define ob_returni (1<<`op_returni)
`define ob_interrupt (1<<`op_interrupt)
`define ob_input (1<<`op_input)
`define ob_output (1<<`op_output)
`define ob_compare (1<<`op_compare)
`define ob_test (1<<`op_test)
`define ob_fetch (1<<`op_fetch)
`define ob_store (1<<`op_store)
`define ob_mul (1<<`op_mul)
`define ob_addw (1<<`op_addw)
`define ob_addwcy (1<<`op_addwcy)
`define ob_subw (1<<`op_subw)
`define ob_subwcy (1<<`op_subwcy)
`else // !USE_ONEHOT_ENCODING
`define op_load `opcode_load
`define op_add `opcode_add
`define op_addcy `opcode_addcy
`define op_and `opcode_and
`define op_or `opcode_or
`define op_rs `opcode_rs
`define op_sub `opcode_sub
`define op_subcy `opcode_subcy
`define op_xor `opcode_xor
`define op_jump `opcode_jump
`define op_call `opcode_call
`define op_return `opcode_return
`define op_returni `opcode_returni
`define op_interrupt `opcode_interrupt
`define op_input `opcode_input
`define op_output `opcode_output
`define op_compare `opcode_compare
`define op_test `opcode_test
`define op_fetch `opcode_fetch
`define op_store `opcode_store
`define op_mul `opcode_mul
`define op_addw `opcode_addw
`define op_addwcy `opcode_addwcy
`define op_subw `opcode_subw
`define op_subwcy `opcode_subwcy
`endif
`endif

`endif // PACOBLAZE_INC_V_

/*
	PACOBLAZE1
	JUMP         100 cnd(3) 01 address(8)
	CALL         100 cnd(3) 11 address(8)
	RETURN       100 cnd(3) 00 10 0     0 0000
	RETURNI      100 000    00 11 ie(1) 1 0000
	INTERRUPTE/D 100 000    00 00 ed(1) 1 0000

	LOADK        0000 sX(4) constant(8)
	LOADR        1100 sX(4) sY(4) 0000
	ANDK         0001 sX(4) constant(8)
	ANDR         1100 sX(4) sY(4) 0001
	ORK          0010 sX(4) constant(8)
	ORR          1100 sX(4) sY(4) 0010
	XORK         0011 sX(4) constant(8)
	XORR         1100 sX(4) sY(4) 0011
	ADDK         0100 sX(4) constant(8)
	ADDR         1100 sX(4) sY(4) 0100
	ADDCYK       0101 sX(4) constant(8)
	ADDCYR       1100 sX(4) sY(4) 0101
	SUBK         0110 sX(4) constant(8)
	SUBR         1100 sX(4) sY(4) 0110
	SUBCYK       0111 sX(4) constant(8)
	SUBCYR       1100 sX(4) sY(4) 0111
	RSR          1101 sX(4) 0000 1 sr(3)
		11 0 SR0
		11 1 SR1
		01 0 SRX
		00 0 SRA
		10 0 RR
	RSL          1101 sX(4) 0000 0 sr(3)
		11 0 SL0
		11 1 SL1
		10 0 SLX
		00 0 SLA
		01 0 RL
	             . .
	INPUTK       1010 sX(4) pid(8)
	INPUTR       1011 sX(4) sY(4) 0000
	OUTPUTK      1110 sX(4) pid(8)
	OUTPUTR      1111 sX(4) sY(4) 0000

	condition[2] = unconditional/conditional
	condition[1:0] =
		00 z
		01 nz
		10 c
		11 nc
*/

/*
	PACOBLAZE2     s
	JUMP         1 1 010 cnd(3) address(10)
	CALL         1 1 011 cnd(3) address(10)
	RETURN       1 0 010 cnd(3) 0000000000
	RETURNI      1 0 110 000000000000 ie(1)
	INTERRUPTE/D 1 1 110 000000000000 ed(1)

	LOADK        0 0 000 sX(5) constant(8)
	LOADR        0 1 000 sX(5) sY(5) 000
	ANDK         0 0 001 sX(5) constant(8)
	ANDR         0 1 001 sX(5) sY(5) 000
	ORK          0 0 010 sX(5) constant(8)
	ORR          0 1 010 sX(5) sY(5) 000
	XORK         0 0 011 sX(5) constant(8)
	XORR         0 1 011 sX(5) sY(5) 000
	ADDK         0 0 100 sX(5) constant(8)
	ADDR         0 1 100 sX(5) sY(5) 000
	ADDCYK       0 0 101 sX(5) constant(8)
	ADDCYR       0 1 101 sX(5) sY(5) 000
	SUBK         0 0 110 sX(5) constant(8)
	SUBR         0 1 110 sX(5) sY(5) 000
	SUBCYK       0 0 111 sX(5) constant(8)
	SUBCYR       0 1 111 sX(5) sY(5) 000

	RSR          1 0 100 sX(5) 0000 1 sr(3)
	RSL          1 0 100 sX(5) 0000 0 sr(3)

	INPUTK       1 0 000 sX(5) pid(8)
	INPUTR       1 1 000 sX(5) sY(5) 000
	OUTPUTK      1 0 001 sX(5) pid(8)
	OUTPUTR      1 1 001 sX(5) sY(5) 000
*/

/*
	PACOBLAZE3
	ADDK         01100 0 sX(4) constant(8)
	ADDR         01100 1 sX(4) sY(4) 0000
	ADDCYK       01101 0 sX(4) constant(8)
	ADDCYR       01101 1 sX(4) sY(4) 0000
	ANDK         00101 0 sX(4) constant(8)
	ANDR         00101 1 sX(4) sY(4) 0000
	CALL         11000 cnd(3) address(10)
	COMPARE      01010 0 sX(4) constant(8)
	COMPARE      01010 1 sX(4) sY(4) 0000
	INTERRUPTE/D 11110 000000000000 ed(1)
	FETCHK       00011 0 sX(4) 00 spad(6)
	FETCHR       00011 1 sX(4) sY(4) 0000
	INPUTK       00010 0 sX(4) pid(8)
	INPUTR       00010 1 sX(4) sY(4) 0000
	JUMP         11010 cnd(3) address(10)
	LOADK        00000 0 sX(4) constant(8)
	LOADR        00000 1 sX(4) sY(4) 0000
	ORK          00110 0 sX(4) constant(8)
	ORR          00110 1 sX(4) sY(4) 0000
	OUTPUTK      10110 0 sX(4) pid(8)
	OUTPUTR      10110 1 sX(4) sY(4) 0000
	RETURN       10101 0000000000000
	RETURNI      11100 000000000000 ie(1)
	RSR          10000 0 sX(4) 0000 1 sr(3)
	RSL          10000 0 sX(4) 0000 0 sr(3)

	SR0 sX100000 sX(4) 0000 1 11 0
	SR1 sX100000 sX(4) 0000 1 11 1
	SRX sX100000 sX(4) 0000 1 01 0
	SRA sX100000 sX(4) 0000 1 00 0
	RR  sX100000 sX(4) 0000 1 10 0

	SL0 sX100000 sX(4) 0000 0 11 0
	SL1 sX100000 sX(4) 0000 0 11 1
	SLX sX100000 sX(4) 0000 0 10 0
	SLA sX100000 sX(4) 0000 0 00 0
	RL  sX100000 sX(4) 0000 0 01 0

	STOREK       10111 0 sX(4) 00 spad(6)
	STORER       10111 1 sX(4) sY(4) 0000
	SUBK         01110 0 sX(4) constant(8)
	SUBR         01110 1 sX(4) sY(4) 0000
	SUBCYK       01111 0 sX(4) constant(8)
	SUBCYR       01111 1 sX(4) sY(4) 0000
	TESTK        01001 0 sX(4) constant(8)
	TESTR        01001 1 sX(4) sY(4) 0000
	XORK         00111 0 sX(4) constant(8)
	XORR         00111 1 sX(4) sY(4) 0000


	ADD sX,kk 0 1 1 0 0 0 x x x x k k k k k k k k
	ADD sX,sY 0 1 1 0 0 1 x x x x y y y y 0 0 0 0
	ADDCY sX,kk 0 1 1 0 1 0 x x x x k k k k k k k k
	ADDCY sX,sY 0 1 1 0 1 1 x x x x y y y y 0 0 0 0
	AND sX,kk 0 0 1 0 1 0 x x x x k k k k k k k k
	AND sX,sY 0 0 1 0 1 1 x x x x y y y y 0 0 0 0
	CALL 1 1 0 0 0 0 0 0 a a a a a a a a a a
	CALL C 1 1 0 0 0 1 1 0 a a a a a a a a a a
	CALL NC 1 1 0 0 0 1 1 1 a a a a a a a a a a
	CALL NZ 1 1 0 0 0 1 0 1 a a a a a a a a a a
	CALL Z 1 1 0 0 0 1 0 0 a a a a a a a a a a
	COMPARE sX,kk 0 1 0 1 0 0 x x x x k k k k k k k k
	COMPARE sX,sY 0 1 0 1 0 1 x x x x y y y y 0 0 0 0
	DISABLE INTERRUPT 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	ENABLE INTERRUPT 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1
	FETCH sX, ss 0 0 0 1 1 0 x x x x 0 0 s s s s s s
	FETCH sX,(sY) 0 0 0 1 1 1 x x x x y y y y 0 0 0 0
	INPUT sX,(sY) 0 0 0 1 0 1 x x x x y y y y 0 0 0 0
	INPUT sX,pp 0 0 0 1 0 0 x x x x p p p p p p p p
	JUMP 1 1 0 1 0 0 0 0 a a a a a a a a a a
	JUMP C 1 1 0 1 0 1 1 0 a a a a a a a a a a
	JUMP NC 1 1 0 1 0 1 1 1 a a a a a a a a a a
	JUMP NZ 1 1 0 1 0 1 0 1 a a a a a a a a a a
	JUMP Z 1 1 0 1 0 1 0 0 a a a a a a a a a a
	LOAD sX,kk 0 0 0 0 0 0 x x x x k k k k k k k k
	LOAD sX,sY 0 0 0 0 0 1 x x x x y y y y 0 0 0 0
	OR sX,kk 0 0 1 1 0 0 x x x x k k k k k k k k
	OR sX,sY 0 0 1 1 0 1 x x x x y y y y 0 0 0 0
	OUTPUT sX,(sY) 1 0 1 1 0 1 x x x x y y y y 0 0 0 0
	OUTPUT sX,pp 1 0 1 1 0 0 x x x x p p p p p p p p
	RETURN 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
	RETURN C 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0
	RETURN NC 1 0 1 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0
	RETURN NZ 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0
	RETURN Z 1 0 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0
	RETURNI DISABLE 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	RETURNI ENABLE 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
	RL sX 1 0 0 0 0 0 x x x x 0 0 0 0 0 0 1 0
	RR sX 1 0 0 0 0 0 x x x x 0 0 0 0 1 1 0 0
	SL0 sX 1 0 0 0 0 0 x x x x 0 0 0 0 0 1 1 0
	SL1 sX 1 0 0 0 0 0 x x x x 0 0 0 0 0 1 1 1
	SLA sX 1 0 0 0 0 0 x x x x 0 0 0 0 0 0 0 0
	SLX sX 1 0 0 0 0 0 x x x x 0 0 0 0 0 1 0 0
	SR0 sX 1 0 0 0 0 0 x x x x 0 0 0 0 1 1 1 0
	SR1 sX 1 0 0 0 0 0 x x x x 0 0 0 0 1 1 1 1
	SRA sX 1 0 0 0 0 0 x x x x 0 0 0 0 1 0 0 0
	SRX sX 1 0 0 0 0 0 x x x x 0 0 0 0 1 0 1 0
	STORE sX, ss 1 0 1 1 1 0 x x x x 0 0 s s s s s s
	STORE sX,(sY) 1 0 1 1 1 1 x x x x y y y y 0 0 0 0
	SUB sX,kk 0 1 1 1 0 0 x x x x k k k k k k k k
	SUB sX,sY 0 1 1 1 0 1 x x x x y y y y 0 0 0 0
	SUBCY sX,kk 0 1 1 1 1 0 x x x x k k k k k k k k
	SUBCY sX,sY 0 1 1 1 1 1 x x x x y y y y 0 0 0 0
	TEST sX,kk 0 1 0 0 1 0 x x x x k k k k k k k k
	TEST sX,sY 0 1 0 0 1 1 x x x x y y y y 0 0 0 0
	XOR sX,kk 0 0 1 1 1 0 x x x x k k k k k k k k
	XOR sX,sY 0 0 1 1 1 1 x x x x y y y y 0 0 0 0

	Unused opcodes
	01
	04
	08
	0b
	11
	12
	13
	14
	19
	1b
	1d
	1f

// PB1,2,3
`define ob_load (1<<0)
`define ob_add (1<<1)
`define ob_addcy (1<<2)
`define ob_and (1<<3)
`define ob_or (1<<4)
`define ob_rs (1<<5)
`define ob_sub (1<<6)
`define ob_subcy (1<<7)
`define ob_xor (1<<8)
`define ob_jump (1<<9)
`define ob_call (1<<10)
`define ob_return (1<<11)
`define ob_returni (1<<12)
`define ob_interrupt (1<<13)
`define ob_input (1<<14)
`define ob_output (1<<15)
// PB3
`define ob_compare (1<<16)
`define ob_test (1<<17)
`define ob_fetch (1<<18)
`define ob_store (1<<19)
`ifdef PACOBLAZE3M
`define ob_mul (1<<20)
`define ob_addw (1<<21)
`define ob_subw (1<<22)
`define ob_addwcy (1<<23)
`define ob_subwcy (1<<24)
`endif


*/
