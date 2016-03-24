/*
	Copyright (c) 2006 Pablo Bleyer Kocik.

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

/*
	PacoBlaze Utilities
*/

function [8:1] numtohex;
	input [3:0] number;
	begin
		case (number)
			'h0: numtohex = "0";
			'h1: numtohex = "1";
			'h2: numtohex = "2";
			'h3: numtohex = "3";
			'h4: numtohex = "4";
			'h5: numtohex = "5";
			'h6: numtohex = "6";
			'h7: numtohex = "7";
			'h8: numtohex = "8";
			'h9: numtohex = "9";
			'ha: numtohex = "a";
			'hb: numtohex = "b";
			'hc: numtohex = "c";
			'hd: numtohex = "d";
			'he: numtohex = "e";
			'hf: numtohex = "f";
		endcase
	end
endfunction

`ifdef PACOBLAZE1
function [2*8:1] adrtohex;
	input [`code_width-1:0] address;
	begin
		adrtohex[8:1] = numtohex(address[3:0]);
		adrtohex[16:9] = numtohex(address[7:4]);
	end
endfunction
`else
function [3*8:1] adrtohex;
	input [`code_width-1:0] address;
	begin
		adrtohex[8:1] = numtohex(address[3:0]);
		adrtohex[16:9] = numtohex(address[7:4]);
		adrtohex[24:17] = numtohex({2'b0, address[9:8]});
	end
endfunction
`endif
