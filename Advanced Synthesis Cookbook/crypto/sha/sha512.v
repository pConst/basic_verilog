// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// baeckler - 12-13-2006
// straight from FIPS 180

///////////////////////////////////////

module big_sigma_0_512 (x,result);
input [63:0] x;
output [63:0] result;

wire [63:0] ror28,ror34,ror39;

	assign ror28 = {x[28-1:0],x[63:28]};
	assign ror34 = {x[34-1:0],x[63:34]};
	assign ror39 = {x[39-1:0],x[63:39]};
	assign result = ror28 ^ ror34 ^ ror39;

endmodule

///////////////////////////////////////

module big_sigma_1_512 (x,result);
input [63:0] x;
output [63:0] result;

wire [63:0] ror14,ror18,ror41;

	assign ror14 = {x[14-1:0],x[63:14]};
	assign ror18 = {x[18-1:0],x[63:18]};
	assign ror41 = {x[41-1:0],x[63:41]};
	assign result = ror14 ^ ror18 ^ ror41;

endmodule

///////////////////////////////////////

module little_sigma_0_512 (x,result);
input [63:0] x;
output [63:0] result;

wire [63:0] ror1,ror8,shr7;

	assign ror1 = {x[1-1:0],x[63:1]};
	assign ror8 = {x[8-1:0],x[63:8]};
	assign shr7 = {7'b0,x[63:7]};
	assign result = ror1 ^ ror8 ^ shr7;

endmodule

///////////////////////////////////////

module little_sigma_1_512 (x,result);
input [63:0] x;
output [63:0] result;

wire [63:0] ror19,ror61,shr6;

	assign ror19 = {x[19-1:0],x[63:19]};
	assign ror61 = {x[61-1:0],x[63:61]};
	assign shr6 = {6'b0,x[63:6]};
	assign result = ror19 ^ ror61 ^ shr6;

endmodule

///////////////////////////////////////

module fn_ch (x,y,z,result);
input [63:0] x,y,z;
output [63:0] result;
	assign result = (x & y) ^ (~x & z);
endmodule

///////////////////////////////////////

module fn_maj (x,y,z,result);
input [63:0] x,y,z;
output [63:0] result;
	assign result = (x & y) ^ (x & z) ^ (y & z);
endmodule

///////////////////////////////////////

// this costs about 192 luts, depth 2 in raw SII cells
module k_table (idx,k);
input [6:0] idx;
output [63:0] k;
reg [63:0] k;

	always @(*) begin
		case (idx) 
			0 : k=64'h428a2f98d728ae22 ;
			1 : k=64'h7137449123ef65cd ;
			2 : k=64'hb5c0fbcfec4d3b2f ;
			3 : k=64'he9b5dba58189dbbc ;
			4 : k=64'h3956c25bf348b538 ;
			5 : k=64'h59f111f1b605d019 ;
			6 : k=64'h923f82a4af194f9b ;
			7 : k=64'hab1c5ed5da6d8118 ;
			8 : k=64'hd807aa98a3030242 ;
			9 : k=64'h12835b0145706fbe ;
			10 : k=64'h243185be4ee4b28c ;
			11 : k=64'h550c7dc3d5ffb4e2 ;
			12 : k=64'h72be5d74f27b896f ;
			13 : k=64'h80deb1fe3b1696b1 ;
			14 : k=64'h9bdc06a725c71235 ;
			15 : k=64'hc19bf174cf692694 ;
			16 : k=64'he49b69c19ef14ad2 ;
			17 : k=64'hefbe4786384f25e3 ;
			18 : k=64'h0fc19dc68b8cd5b5 ;
			19 : k=64'h240ca1cc77ac9c65 ;
			20 : k=64'h2de92c6f592b0275 ;
			21 : k=64'h4a7484aa6ea6e483 ;
			22 : k=64'h5cb0a9dcbd41fbd4 ;
			23 : k=64'h76f988da831153b5 ;
			24 : k=64'h983e5152ee66dfab ;
			25 : k=64'ha831c66d2db43210 ;
			26 : k=64'hb00327c898fb213f ;
			27 : k=64'hbf597fc7beef0ee4 ;
			28 : k=64'hc6e00bf33da88fc2 ;
			29 : k=64'hd5a79147930aa725 ;
			30 : k=64'h06ca6351e003826f ;
			31 : k=64'h142929670a0e6e70 ;
			32 : k=64'h27b70a8546d22ffc ;
			33 : k=64'h2e1b21385c26c926 ;
			34 : k=64'h4d2c6dfc5ac42aed ;
			35 : k=64'h53380d139d95b3df ;
			36 : k=64'h650a73548baf63de ;
			37 : k=64'h766a0abb3c77b2a8 ;
			38 : k=64'h81c2c92e47edaee6 ;
			39 : k=64'h92722c851482353b ;
			40 : k=64'ha2bfe8a14cf10364 ;
			41 : k=64'ha81a664bbc423001 ;
			42 : k=64'hc24b8b70d0f89791 ;
			43 : k=64'hc76c51a30654be30 ;
			44 : k=64'hd192e819d6ef5218 ;
			45 : k=64'hd69906245565a910 ;
			46 : k=64'hf40e35855771202a ;
			47 : k=64'h106aa07032bbd1b8 ;
			48 : k=64'h19a4c116b8d2d0c8 ;
			49 : k=64'h1e376c085141ab53 ;
			50 : k=64'h2748774cdf8eeb99 ;
			51 : k=64'h34b0bcb5e19b48a8 ;
			52 : k=64'h391c0cb3c5c95a63 ;
			53 : k=64'h4ed8aa4ae3418acb ;
			54 : k=64'h5b9cca4f7763e373 ;
			55 : k=64'h682e6ff3d6b2b8a3 ;
			56 : k=64'h748f82ee5defb2fc ;
			57 : k=64'h78a5636f43172f60 ;
			58 : k=64'h84c87814a1f0ab72 ;
			59 : k=64'h8cc702081a6439ec ;
			60 : k=64'h90befffa23631e28 ;
			61 : k=64'ha4506cebde82bde9 ;
			62 : k=64'hbef9a3f7b2c67915 ;
			63 : k=64'hc67178f2e372532b ;
			64 : k=64'hca273eceea26619c ;
			65 : k=64'hd186b8c721c0c207 ;
			66 : k=64'heada7dd6cde0eb1e ;
			67 : k=64'hf57d4f7fee6ed178 ;
			68 : k=64'h06f067aa72176fba ;
			69 : k=64'h0a637dc5a2c898a6 ;
			70 : k=64'h113f9804bef90dae ;
			71 : k=64'h1b710b35131c471b ;
			72 : k=64'h28db77f523047d84 ;
			73 : k=64'h32caab7b40c72493 ;
			74 : k=64'h3c9ebe0a15c9bebc ;
			75 : k=64'h431d67c49c100d4c ;
			76 : k=64'h4cc5d4becb3e42b6 ;
			77 : k=64'h597f299cfc657e2a ;
			78 : k=64'h5fcb6fab3ad6faec ;
			79 : k=64'h6c44198c4a475817 ;
			default : k = 64'h0;
		endcase
	end
endmodule

///////////////////////////////////////

module h_register (clk,reset,evolve,in,out,out_comb);

parameter HASH_SIZE = 384;  // allowable 384,512

input [8*64-1:0] in;
output [8*64-1:0] out;
output [8*64-1:0] out_comb;
input clk,reset,evolve;

	generate
		initial begin
			if (HASH_SIZE !== 384 && HASH_SIZE !== 512) 
			begin
				$display ("Unsupported size %d",HASH_SIZE);
				$stop();
			end
		end
	endgenerate

	genvar i;
	reg [8*64-1:0] h_reg;
	reg [8*64-1:0] h_comb;

	assign out = h_reg;
	assign out_comb = h_comb;

	wire [511:0] init_val;
	generate 
		if (HASH_SIZE == 384) 
			assign init_val = {
					64'h47b5481dbefa4fa4,
					64'hdb0c2e0d64f98fa7,
					64'h8eb44a8768581511,
					64'h67332667ffc00b31,
					64'h152fecd8f70e5939,
					64'h9159015a3070dd17,
					64'h629a292a367cd507,
					64'hcbbb9d5dc1059ed8};
		else 
			assign init_val = {
					64'h5be0cd19137e2179,
					64'h1f83d9abfb41bd6b,
					64'h9b05688c2b3e6c1f,
					64'h510e527fade682d1,
					64'ha54ff53a5f1d36f1,
					64'h3c6ef372fe94f82b,
					64'hbb67ae8584caa73b,
					64'h6a09e667f3bcc908};
	endgenerate

	// order is h7 (MS end) .. h0 (LS end)

	generate 
	for (i=0; i<8; i=i+1)
	begin : hrlp
		always @(*) begin
			if (reset) begin
				h_comb [64*i+63:64*i] = init_val[64*i+63:64*i];
			end
			else begin
				h_comb [64*i+63:64*i] = h_reg[64*i+63:64*i] + in[64*i+63:64*i];
			end
		end
	end
	endgenerate

	always @(posedge clk) begin
		if (reset | evolve) h_reg <= h_comb;
	end

endmodule

///////////////////////////////////////

module msg_schedule_reg (
	clk,new_msg,
	word_ack,m_in,
	next_w,w_out,
	msg_word_valid,enable_out	
);

input clk,new_msg,next_w;
input [63:0] m_in;
input msg_word_valid;
output [63:0] w_out;
output word_ack;
output enable_out;

	reg [63:0] w_out;
	reg [63:0] w_tm1,w_tm2,w_tm15;
	wire [63:0] w_tm6,w_tm14;
	
	reg cntr_max;
	reg [6:0] cntr;

	wire enable_out;
	
	// I want a message word.
	wire internal_ack = (next_w & (cntr <= 15));
	
	// If I want a msg word, and msg_word_valid is asserted
	// then we need to stall the rest of the system.
	assign enable_out = !internal_ack | msg_word_valid;
	assign word_ack = internal_ack & msg_word_valid;
	
	///////////////////
	// Hybrid RAM / Reg shift regiter - 64bit x 16
	always @(posedge clk) begin
		if (next_w & enable_out) begin
			w_tm1 <= w_out;
			w_tm2 <= w_tm1;
			w_tm15 <= w_tm14;
		end
	end

	delay_reg dr0 (
		.clock(clk),
		.enable(next_w & enable_out),
		.data_in(w_tm2),
		.data_out(w_tm6)
	);
	defparam dr0 .DEPTH = 4;
	defparam dr0 .WIDTH = 64;

	delay_reg dr1 (
		.clock(clk),
		.enable(next_w & enable_out),
		.data_in(w_tm6),
		.data_out(w_tm14)
	);
	defparam dr1 .DEPTH = 8;
	defparam dr1 .WIDTH = 64;

	/////////////////
	// 
	always @(posedge clk) begin
		if (new_msg) begin
			cntr <= 7'b0;
			cntr_max <= 1'b0;
		end
		else if (enable_out) begin
			cntr_max <= (cntr == 7'd79); // count should be 0 to 80 continuous	
			if (cntr_max) cntr <= 7'b0;
			else cntr <= cntr + 1'b1;			
		end
	end	
	
	/////////////////
	// computation on the taps
	// these are shifted a bit from the spec tap #'s due
	// to latency

	wire [63:0] w_val,w_valx,w_valy;
	little_sigma_1_512 lsx (.x(w_tm1),.result(w_valx));
	little_sigma_0_512 lsy (.x(w_tm14),.result(w_valy));
	
	always @(posedge clk) begin
		if (next_w & enable_out) begin
			if (cntr_max || cntr < 16) w_out <= m_in;
			else w_out <= w_valx + w_valy + w_tm6 + w_tm15;
		end		
	end

endmodule


///////////////////////////////////////

// bit order is {h,g,f,e,d,c,b,a};

module ab_register (clk,load,evolve,in,out,round_k,round_w);

input [8*64-1:0] in;
output [8*64-1:0] out;
input clk,load,evolve;
input [63:0] round_k,round_w;

	wire [63:0] t1, t2;
	reg [63:0] a,b,c,d,e,f,g,h;

	assign out = {h,g,f,e,d,c,b,a};

	// knock out T1 pieces
	wire [63:0] t1_ch,t1_sig,t1_round,t1_fns;
	big_sigma_1_512 t1sig (.x(e),.result(t1_sig));
	fn_ch t1ch (.x(e),.y(f),.z(g),.result(t1_ch));
	// t1 = h + (t1_sig + t1_ch) + (round_k + round_w);
	assign t1_round = round_k + round_w;
	assign t1_fns = t1_sig + t1_ch;		// this part is critical

	// knock out T2
	wire [63:0] t2_sig,t2_maj;
	big_sigma_0_512 t2sig (.x(a),.result(t2_sig));
	fn_maj t2maj (.x(a),.y(b),.z(c),.result(t2_maj));
	assign t2 = t2_sig + t2_maj;

	always @(posedge clk) begin
		if (load) begin
			{h,g,f,e,d,c,b,a} <= in;
		end
		else if (evolve) begin
			h <= g;
			g <= f;
			f <= e;
			e <= t1_fns + ((d + h) + t1_round); // get the critical part forward
			d <= c;
			c <= b;
			b <= a;
			a <= (t1_round + t1_fns) + (h + t2);	
		end
	end
endmodule

///////////////////////////////////////

// new_msg is asserted to start running a fresh message
// complete indicates no more message blocks available
// msg_word must be advanced in immediate response to ack

// hash_out is  { h7,6,5,4,3,2,1,h0 }

module sha512 (clk,reset,
	new_msg,msg_complete,
	msg_word,msg_word_ack,msg_word_valid,
	hash_out,hash_ready);

parameter HASH_SIZE = 512;	
	// allowable sizes 384 and 512
	// this changes the value used to initialize the hash register
	// discard output bits [511:384] when using SHA 384 mode.
	
input clk,reset,new_msg,msg_complete,msg_word_valid;
input [63:0] msg_word;
output [511:0] hash_out;
output msg_word_ack,hash_ready;

	reg[6:0] round, round_plus_one /* synthesis preserve */;
	reg last_round;
	
	reg last_new_msg;
	always @(posedge clk) begin
		if (reset) last_new_msg = 1'b0;
		else last_new_msg <= new_msg;
	end

	wire [63:0] round_w, next_round_k;
	reg [63:0] round_k /* synthesis preserve */;
	wire [8*64-1:0] h_reg_comb, ab_reg;
	
	reg h_reset,evolve_h;
	reg clear_round,next_round;
	reg load_ab_reg,evolve_ab;
	reg next_w;
	reg hash_ready;

	// this enables evolution - generated by message availability
	wire enable;

	// generate K series
	k_table kt (.idx(round_plus_one),.k(next_round_k));
	always @(posedge clk) begin
		if (enable) round_k <= next_round_k;
	end

	// generate W series
	msg_schedule_reg sched (
		.clk(clk),
		.new_msg(new_msg),
		.word_ack(msg_word_ack),
		.m_in(msg_word),
		.next_w(next_w),
		.w_out(round_w),
		.msg_word_valid(msg_word_valid),
		.enable_out(enable)
	);

	// the hash register
	h_register hreg (
		.clk(clk),
		.reset(h_reset),
		.evolve(evolve_h & enable),
		.in(ab_reg),
		.out(hash_out),
		.out_comb(h_reg_comb)
	);
	defparam hreg .HASH_SIZE = HASH_SIZE;

	// the working abcdefgh register
	ab_register abreg (
		.clk(clk),
		.load(load_ab_reg & enable),
		.evolve(evolve_ab & enable),
		.in(h_reg_comb),
		.out(ab_reg),
		.round_k(round_k),
		.round_w(round_w)
	);
	
	// leading round counter for K computation
	always @(posedge clk) begin
		if (enable) begin
			if (reset | new_msg) round_plus_one <= 7'b0;
			else if (last_round) round_plus_one <= 7'b0;
			else round_plus_one <= round_plus_one + 1'b1;
		end
	end

	// round counter sweeps 0..80 inclusive (80 is evolve time)
	always @(posedge clk) begin
		if (enable) begin
			if (clear_round) begin
				round <= 0;
				last_round <= 0;
			end
			else if (next_round) begin
				round <= round + 1'b1;					
				last_round <= (round == 7'd78);
			end
		end
	end

	// little state machine control
	reg [1:0] state,next_state;
	parameter IDLE = 0, EVOLVE_H = 1, EVOLVE_AB = 2;
		
	always @(*) begin
		
		// defaults
		h_reset = 1'b0;
		evolve_h = 1'b0;
		clear_round = 1'b0;
		load_ab_reg = 1'b0;
		next_round = 1'b0;
		evolve_ab = 1'b0;
		next_w = 1'b0;
		next_state = state;
		hash_ready = 1'b0;

		case (state)
			IDLE : begin
					if (new_msg) next_state = EVOLVE_H;
					hash_ready = 1'b1;
				end
			EVOLVE_H : begin				// 1 tick
					if (last_new_msg) begin
						h_reset = 1'b1;
					end else begin
						evolve_h = 1'b1;
					end
					clear_round = 1'b1;
					load_ab_reg = 1'b1;
					if (msg_complete) next_state = IDLE;
					else begin
						next_w = 1'b1;
						next_state = EVOLVE_AB;
					end
				end
			EVOLVE_AB : begin				// 80 ticks
					next_round = 1'b1;
					evolve_ab = 1'b1;
					if (last_round) next_state = EVOLVE_H;
					else next_w = 1'b1; 
				end
		endcase		
	end

	always @(posedge clk) begin
		if (reset) state = IDLE;
		else if (enable) state <= next_state;
	end


// synthesis translate_off

// Mimic FIPS example D2 printout
wire [63:0] ta,tb,tc,td,te,tf,tg,th;
assign {th,tg,tf,te,td,tc,tb,ta} = ab_reg;
always @(posedge clk) begin
	#10 if (round >= 1) begin
		$display ("t=%d    : %x - %x - %x - %x",
			round - 1, ta,tb,tc,td);
		$display ("t=%d    : %x - %x - %x - %x",
			round - 1, te,tf,tg,th);
	end
end

// synthesis translate_on
	
endmodule
