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

// baeckler - 03-09-2006

//////////////////////////////////////////////
// eight input (256 word) ROM helper fn
//////////////////////////////////////////////
module eight_input_rom (in,out);
input [7:0] in;
output out;
wire out /* synthesis keep */;

parameter [255:0] mask = 256'b0;

wire [3:0] t /* synthesis keep */;
wire [63:0] m0 = mask[63:0];
wire [63:0] m1 = mask[127:64];
wire [63:0] m2 = mask[191:128];
wire [63:0] m3 = mask[255:192];

assign t[0] = m0[in[5:0]];
assign t[1] = m1[in[5:0]];
assign t[2] = m2[in[5:0]];
assign t[3] = m3[in[5:0]];
assign out = t[in[7:6]];

endmodule

//////////////////////////////////////////////
// Single Rijndael SBOX
//////////////////////////////////////////////
module sbox (in,out);
input [7:0] in;
output [7:0] out;
wire [7:0] out;

parameter METHOD = 1;

generate
  if (METHOD == 0) begin
    reg [7:0] o;
    always @(in) begin
      case (in)
        8'h00: o = 8'h63;    8'h01: o = 8'h7c;    8'h02: o = 8'h77;    8'h03: o = 8'h7b;
        8'h04: o = 8'hf2;    8'h05: o = 8'h6b;    8'h06: o = 8'h6f;    8'h07: o = 8'hc5;
        8'h08: o = 8'h30;    8'h09: o = 8'h01;    8'h0a: o = 8'h67;    8'h0b: o = 8'h2b;
        8'h0c: o = 8'hfe;    8'h0d: o = 8'hd7;    8'h0e: o = 8'hab;    8'h0f: o = 8'h76;
        8'h10: o = 8'hca;    8'h11: o = 8'h82;    8'h12: o = 8'hc9;    8'h13: o = 8'h7d;
        8'h14: o = 8'hfa;    8'h15: o = 8'h59;    8'h16: o = 8'h47;    8'h17: o = 8'hf0;
        8'h18: o = 8'had;    8'h19: o = 8'hd4;    8'h1a: o = 8'ha2;    8'h1b: o = 8'haf;
        8'h1c: o = 8'h9c;    8'h1d: o = 8'ha4;    8'h1e: o = 8'h72;    8'h1f: o = 8'hc0;
        8'h20: o = 8'hb7;    8'h21: o = 8'hfd;    8'h22: o = 8'h93;    8'h23: o = 8'h26;
        8'h24: o = 8'h36;    8'h25: o = 8'h3f;    8'h26: o = 8'hf7;    8'h27: o = 8'hcc;
        8'h28: o = 8'h34;    8'h29: o = 8'ha5;    8'h2a: o = 8'he5;    8'h2b: o = 8'hf1;
        8'h2c: o = 8'h71;    8'h2d: o = 8'hd8;    8'h2e: o = 8'h31;    8'h2f: o = 8'h15;
        8'h30: o = 8'h04;    8'h31: o = 8'hc7;    8'h32: o = 8'h23;    8'h33: o = 8'hc3;
        8'h34: o = 8'h18;    8'h35: o = 8'h96;    8'h36: o = 8'h05;    8'h37: o = 8'h9a;
        8'h38: o = 8'h07;    8'h39: o = 8'h12;    8'h3a: o = 8'h80;    8'h3b: o = 8'he2;
        8'h3c: o = 8'heb;    8'h3d: o = 8'h27;    8'h3e: o = 8'hb2;    8'h3f: o = 8'h75;
        8'h40: o = 8'h09;    8'h41: o = 8'h83;    8'h42: o = 8'h2c;    8'h43: o = 8'h1a;
        8'h44: o = 8'h1b;    8'h45: o = 8'h6e;    8'h46: o = 8'h5a;    8'h47: o = 8'ha0;
        8'h48: o = 8'h52;    8'h49: o = 8'h3b;    8'h4a: o = 8'hd6;    8'h4b: o = 8'hb3;
        8'h4c: o = 8'h29;    8'h4d: o = 8'he3;    8'h4e: o = 8'h2f;    8'h4f: o = 8'h84;
        8'h50: o = 8'h53;    8'h51: o = 8'hd1;    8'h52: o = 8'h00;    8'h53: o = 8'hed;
        8'h54: o = 8'h20;    8'h55: o = 8'hfc;    8'h56: o = 8'hb1;    8'h57: o = 8'h5b;
        8'h58: o = 8'h6a;    8'h59: o = 8'hcb;    8'h5a: o = 8'hbe;    8'h5b: o = 8'h39;
        8'h5c: o = 8'h4a;    8'h5d: o = 8'h4c;    8'h5e: o = 8'h58;    8'h5f: o = 8'hcf;
        8'h60: o = 8'hd0;    8'h61: o = 8'hef;    8'h62: o = 8'haa;    8'h63: o = 8'hfb;
        8'h64: o = 8'h43;    8'h65: o = 8'h4d;    8'h66: o = 8'h33;    8'h67: o = 8'h85;
        8'h68: o = 8'h45;    8'h69: o = 8'hf9;    8'h6a: o = 8'h02;    8'h6b: o = 8'h7f;
        8'h6c: o = 8'h50;    8'h6d: o = 8'h3c;    8'h6e: o = 8'h9f;    8'h6f: o = 8'ha8;
        8'h70: o = 8'h51;    8'h71: o = 8'ha3;    8'h72: o = 8'h40;    8'h73: o = 8'h8f;
        8'h74: o = 8'h92;    8'h75: o = 8'h9d;    8'h76: o = 8'h38;    8'h77: o = 8'hf5;
        8'h78: o = 8'hbc;    8'h79: o = 8'hb6;    8'h7a: o = 8'hda;    8'h7b: o = 8'h21;
        8'h7c: o = 8'h10;    8'h7d: o = 8'hff;    8'h7e: o = 8'hf3;    8'h7f: o = 8'hd2;
        8'h80: o = 8'hcd;    8'h81: o = 8'h0c;    8'h82: o = 8'h13;    8'h83: o = 8'hec;
        8'h84: o = 8'h5f;    8'h85: o = 8'h97;    8'h86: o = 8'h44;    8'h87: o = 8'h17;
        8'h88: o = 8'hc4;    8'h89: o = 8'ha7;    8'h8a: o = 8'h7e;    8'h8b: o = 8'h3d;
        8'h8c: o = 8'h64;    8'h8d: o = 8'h5d;    8'h8e: o = 8'h19;    8'h8f: o = 8'h73;
        8'h90: o = 8'h60;    8'h91: o = 8'h81;    8'h92: o = 8'h4f;    8'h93: o = 8'hdc;
        8'h94: o = 8'h22;    8'h95: o = 8'h2a;    8'h96: o = 8'h90;    8'h97: o = 8'h88;
        8'h98: o = 8'h46;    8'h99: o = 8'hee;    8'h9a: o = 8'hb8;    8'h9b: o = 8'h14;
        8'h9c: o = 8'hde;    8'h9d: o = 8'h5e;    8'h9e: o = 8'h0b;    8'h9f: o = 8'hdb;
        8'ha0: o = 8'he0;    8'ha1: o = 8'h32;    8'ha2: o = 8'h3a;    8'ha3: o = 8'h0a;
        8'ha4: o = 8'h49;    8'ha5: o = 8'h06;    8'ha6: o = 8'h24;    8'ha7: o = 8'h5c;
        8'ha8: o = 8'hc2;    8'ha9: o = 8'hd3;    8'haa: o = 8'hac;    8'hab: o = 8'h62;
        8'hac: o = 8'h91;    8'had: o = 8'h95;    8'hae: o = 8'he4;    8'haf: o = 8'h79;
        8'hb0: o = 8'he7;    8'hb1: o = 8'hc8;    8'hb2: o = 8'h37;    8'hb3: o = 8'h6d;
        8'hb4: o = 8'h8d;    8'hb5: o = 8'hd5;    8'hb6: o = 8'h4e;    8'hb7: o = 8'ha9;
        8'hb8: o = 8'h6c;    8'hb9: o = 8'h56;    8'hba: o = 8'hf4;    8'hbb: o = 8'hea;
        8'hbc: o = 8'h65;    8'hbd: o = 8'h7a;    8'hbe: o = 8'hae;    8'hbf: o = 8'h08;
        8'hc0: o = 8'hba;    8'hc1: o = 8'h78;    8'hc2: o = 8'h25;    8'hc3: o = 8'h2e;
        8'hc4: o = 8'h1c;    8'hc5: o = 8'ha6;    8'hc6: o = 8'hb4;    8'hc7: o = 8'hc6;
        8'hc8: o = 8'he8;    8'hc9: o = 8'hdd;    8'hca: o = 8'h74;    8'hcb: o = 8'h1f;
        8'hcc: o = 8'h4b;    8'hcd: o = 8'hbd;    8'hce: o = 8'h8b;    8'hcf: o = 8'h8a;
        8'hd0: o = 8'h70;    8'hd1: o = 8'h3e;    8'hd2: o = 8'hb5;    8'hd3: o = 8'h66;
        8'hd4: o = 8'h48;    8'hd5: o = 8'h03;    8'hd6: o = 8'hf6;    8'hd7: o = 8'h0e;
        8'hd8: o = 8'h61;    8'hd9: o = 8'h35;    8'hda: o = 8'h57;    8'hdb: o = 8'hb9;
        8'hdc: o = 8'h86;    8'hdd: o = 8'hc1;    8'hde: o = 8'h1d;    8'hdf: o = 8'h9e;
        8'he0: o = 8'he1;    8'he1: o = 8'hf8;    8'he2: o = 8'h98;    8'he3: o = 8'h11;
        8'he4: o = 8'h69;    8'he5: o = 8'hd9;    8'he6: o = 8'h8e;    8'he7: o = 8'h94;
        8'he8: o = 8'h9b;    8'he9: o = 8'h1e;    8'hea: o = 8'h87;    8'heb: o = 8'he9;
        8'hec: o = 8'hce;    8'hed: o = 8'h55;    8'hee: o = 8'h28;    8'hef: o = 8'hdf;
        8'hf0: o = 8'h8c;    8'hf1: o = 8'ha1;    8'hf2: o = 8'h89;    8'hf3: o = 8'h0d;
        8'hf4: o = 8'hbf;    8'hf5: o = 8'he6;    8'hf6: o = 8'h42;    8'hf7: o = 8'h68;
        8'hf8: o = 8'h41;    8'hf9: o = 8'h99;    8'hfa: o = 8'h2d;    8'hfb: o = 8'h0f;
        8'hfc: o = 8'hb0;    8'hfd: o = 8'h54;    8'hfe: o = 8'hbb;    8'hff: o = 8'h16;
            default: o = 8'h0;
      endcase
    end
    assign out = o;
  end
  else if (METHOD == 1) begin
      eight_input_rom r0 (.in(in),.out(out[0]));
        defparam r0 .mask = 256'h4f1ead396f247a0410bdb210c006eab568ab4bfa8acb7a13b14ede67096c6eed;
      eight_input_rom r1 (.in(in),.out(out[1]));
        defparam r1 .mask = 256'hc870974094ead8a96a450b2ef33486b4e61a4c5e97816f7a7bae007d4c53fc7d;
      eight_input_rom r2 (.in(in),.out(out[2]));
        defparam r2 .mask = 256'hac39b6c0d6ce2efc577d64e03b0c3ffb23a869a2a428c424a16387fb3b48b4c6;
      eight_input_rom r3 (.in(in),.out(out[3]));
        defparam r3 .mask = 256'h4e9ddb76c892fb1be9da849cf6ac6c1b2568ea2effa8527d109020a2193d586a;
      eight_input_rom r4 (.in(in),.out(out[4]));
        defparam r4 .mask = 256'hf210a3aece472e532624b286bc48ecb4f7f17a494ce30f58c2b0f97752b8b11e;
      eight_input_rom r5 (.in(in),.out(out[5]));
        defparam r5 .mask = 256'h54b248130b4f256f7d8dcc4706319e086bc2aa4e0d787aa4f8045f7b6d98dd7f;
      eight_input_rom r6 (.in(in),.out(out[6]));
        defparam r6 .mask = 256'h21e0b833255917823f6bcb91b30db559e4851b3bf3ab2560980a3cc2c2fdb4ff;
      eight_input_rom r7 (.in(in),.out(out[7]));
        defparam r7 .mask = 256'h52379de7b844e3e14cb3770196ca0329e7bac28f866aac825caa2ec7bf977090;
  end
endgenerate
endmodule

//////////////////////////////////////////////
// Single Rijndael Inverse SBOX
//////////////////////////////////////////////
module inv_sbox (in,out);
input [7:0] in;
output [7:0] out;
wire [7:0] out;

parameter METHOD = 1;

generate
  if (METHOD == 0) begin
    reg [7:0] o;
    always @(in) begin
      case (in)
        8'h00: o = 8'h52;    8'h01: o = 8'h09;    8'h02: o = 8'h6a;    8'h03: o = 8'hd5;
        8'h04: o = 8'h30;    8'h05: o = 8'h36;    8'h06: o = 8'ha5;    8'h07: o = 8'h38;
        8'h08: o = 8'hbf;    8'h09: o = 8'h40;    8'h0a: o = 8'ha3;    8'h0b: o = 8'h9e;
        8'h0c: o = 8'h81;    8'h0d: o = 8'hf3;    8'h0e: o = 8'hd7;    8'h0f: o = 8'hfb;
        8'h10: o = 8'h7c;    8'h11: o = 8'he3;    8'h12: o = 8'h39;    8'h13: o = 8'h82;
        8'h14: o = 8'h9b;    8'h15: o = 8'h2f;    8'h16: o = 8'hff;    8'h17: o = 8'h87;
        8'h18: o = 8'h34;    8'h19: o = 8'h8e;    8'h1a: o = 8'h43;    8'h1b: o = 8'h44;
        8'h1c: o = 8'hc4;    8'h1d: o = 8'hde;    8'h1e: o = 8'he9;    8'h1f: o = 8'hcb;
        8'h20: o = 8'h54;    8'h21: o = 8'h7b;    8'h22: o = 8'h94;    8'h23: o = 8'h32;
        8'h24: o = 8'ha6;    8'h25: o = 8'hc2;    8'h26: o = 8'h23;    8'h27: o = 8'h3d;
        8'h28: o = 8'hee;    8'h29: o = 8'h4c;    8'h2a: o = 8'h95;    8'h2b: o = 8'h0b;
        8'h2c: o = 8'h42;    8'h2d: o = 8'hfa;    8'h2e: o = 8'hc3;    8'h2f: o = 8'h4e;
        8'h30: o = 8'h08;    8'h31: o = 8'h2e;    8'h32: o = 8'ha1;    8'h33: o = 8'h66;
        8'h34: o = 8'h28;    8'h35: o = 8'hd9;    8'h36: o = 8'h24;    8'h37: o = 8'hb2;
        8'h38: o = 8'h76;    8'h39: o = 8'h5b;    8'h3a: o = 8'ha2;    8'h3b: o = 8'h49;
        8'h3c: o = 8'h6d;    8'h3d: o = 8'h8b;    8'h3e: o = 8'hd1;    8'h3f: o = 8'h25;
        8'h40: o = 8'h72;    8'h41: o = 8'hf8;    8'h42: o = 8'hf6;    8'h43: o = 8'h64;
        8'h44: o = 8'h86;    8'h45: o = 8'h68;    8'h46: o = 8'h98;    8'h47: o = 8'h16;
        8'h48: o = 8'hd4;    8'h49: o = 8'ha4;    8'h4a: o = 8'h5c;    8'h4b: o = 8'hcc;
        8'h4c: o = 8'h5d;    8'h4d: o = 8'h65;    8'h4e: o = 8'hb6;    8'h4f: o = 8'h92;
        8'h50: o = 8'h6c;    8'h51: o = 8'h70;    8'h52: o = 8'h48;    8'h53: o = 8'h50;
        8'h54: o = 8'hfd;    8'h55: o = 8'hed;    8'h56: o = 8'hb9;    8'h57: o = 8'hda;
        8'h58: o = 8'h5e;    8'h59: o = 8'h15;    8'h5a: o = 8'h46;    8'h5b: o = 8'h57;
        8'h5c: o = 8'ha7;    8'h5d: o = 8'h8d;    8'h5e: o = 8'h9d;    8'h5f: o = 8'h84;
        8'h60: o = 8'h90;    8'h61: o = 8'hd8;    8'h62: o = 8'hab;    8'h63: o = 8'h00;
        8'h64: o = 8'h8c;    8'h65: o = 8'hbc;    8'h66: o = 8'hd3;    8'h67: o = 8'h0a;
        8'h68: o = 8'hf7;    8'h69: o = 8'he4;    8'h6a: o = 8'h58;    8'h6b: o = 8'h05;
        8'h6c: o = 8'hb8;    8'h6d: o = 8'hb3;    8'h6e: o = 8'h45;    8'h6f: o = 8'h06;
        8'h70: o = 8'hd0;    8'h71: o = 8'h2c;    8'h72: o = 8'h1e;    8'h73: o = 8'h8f;
        8'h74: o = 8'hca;    8'h75: o = 8'h3f;    8'h76: o = 8'h0f;    8'h77: o = 8'h02;
        8'h78: o = 8'hc1;    8'h79: o = 8'haf;    8'h7a: o = 8'hbd;    8'h7b: o = 8'h03;
        8'h7c: o = 8'h01;    8'h7d: o = 8'h13;    8'h7e: o = 8'h8a;    8'h7f: o = 8'h6b;
        8'h80: o = 8'h3a;    8'h81: o = 8'h91;    8'h82: o = 8'h11;    8'h83: o = 8'h41;
        8'h84: o = 8'h4f;    8'h85: o = 8'h67;    8'h86: o = 8'hdc;    8'h87: o = 8'hea;
        8'h88: o = 8'h97;    8'h89: o = 8'hf2;    8'h8a: o = 8'hcf;    8'h8b: o = 8'hce;
        8'h8c: o = 8'hf0;    8'h8d: o = 8'hb4;    8'h8e: o = 8'he6;    8'h8f: o = 8'h73;
        8'h90: o = 8'h96;    8'h91: o = 8'hac;    8'h92: o = 8'h74;    8'h93: o = 8'h22;
        8'h94: o = 8'he7;    8'h95: o = 8'had;    8'h96: o = 8'h35;    8'h97: o = 8'h85;
        8'h98: o = 8'he2;    8'h99: o = 8'hf9;    8'h9a: o = 8'h37;    8'h9b: o = 8'he8;
        8'h9c: o = 8'h1c;    8'h9d: o = 8'h75;    8'h9e: o = 8'hdf;    8'h9f: o = 8'h6e;
        8'ha0: o = 8'h47;    8'ha1: o = 8'hf1;    8'ha2: o = 8'h1a;    8'ha3: o = 8'h71;
        8'ha4: o = 8'h1d;    8'ha5: o = 8'h29;    8'ha6: o = 8'hc5;    8'ha7: o = 8'h89;
        8'ha8: o = 8'h6f;    8'ha9: o = 8'hb7;    8'haa: o = 8'h62;    8'hab: o = 8'h0e;
        8'hac: o = 8'haa;    8'had: o = 8'h18;    8'hae: o = 8'hbe;    8'haf: o = 8'h1b;
        8'hb0: o = 8'hfc;    8'hb1: o = 8'h56;    8'hb2: o = 8'h3e;    8'hb3: o = 8'h4b;
        8'hb4: o = 8'hc6;    8'hb5: o = 8'hd2;    8'hb6: o = 8'h79;    8'hb7: o = 8'h20;
        8'hb8: o = 8'h9a;    8'hb9: o = 8'hdb;    8'hba: o = 8'hc0;    8'hbb: o = 8'hfe;
        8'hbc: o = 8'h78;    8'hbd: o = 8'hcd;    8'hbe: o = 8'h5a;    8'hbf: o = 8'hf4;
        8'hc0: o = 8'h1f;    8'hc1: o = 8'hdd;    8'hc2: o = 8'ha8;    8'hc3: o = 8'h33;
        8'hc4: o = 8'h88;    8'hc5: o = 8'h07;    8'hc6: o = 8'hc7;    8'hc7: o = 8'h31;
        8'hc8: o = 8'hb1;    8'hc9: o = 8'h12;    8'hca: o = 8'h10;    8'hcb: o = 8'h59;
        8'hcc: o = 8'h27;    8'hcd: o = 8'h80;    8'hce: o = 8'hec;    8'hcf: o = 8'h5f;
        8'hd0: o = 8'h60;    8'hd1: o = 8'h51;    8'hd2: o = 8'h7f;    8'hd3: o = 8'ha9;
        8'hd4: o = 8'h19;    8'hd5: o = 8'hb5;    8'hd6: o = 8'h4a;    8'hd7: o = 8'h0d;
        8'hd8: o = 8'h2d;    8'hd9: o = 8'he5;    8'hda: o = 8'h7a;    8'hdb: o = 8'h9f;
        8'hdc: o = 8'h93;    8'hdd: o = 8'hc9;    8'hde: o = 8'h9c;    8'hdf: o = 8'hef;
        8'he0: o = 8'ha0;    8'he1: o = 8'he0;    8'he2: o = 8'h3b;    8'he3: o = 8'h4d;
        8'he4: o = 8'hae;    8'he5: o = 8'h2a;    8'he6: o = 8'hf5;    8'he7: o = 8'hb0;
        8'he8: o = 8'hc8;    8'he9: o = 8'heb;    8'hea: o = 8'hbb;    8'heb: o = 8'h3c;
        8'hec: o = 8'h83;    8'hed: o = 8'h53;    8'hee: o = 8'h99;    8'hef: o = 8'h61;
        8'hf0: o = 8'h17;    8'hf1: o = 8'h2b;    8'hf2: o = 8'h04;    8'hf3: o = 8'h7e;
        8'hf4: o = 8'hba;    8'hf5: o = 8'h77;    8'hf6: o = 8'hd6;    8'hf7: o = 8'h26;
        8'hf8: o = 8'he1;    8'hf9: o = 8'h69;    8'hfa: o = 8'h14;    8'hfb: o = 8'h63;
        8'hfc: o = 8'h55;    8'hfd: o = 8'h21;    8'hfe: o = 8'h0c;    8'hff: o = 8'h7d;
            default: o = 8'h0;
      endcase
    end
    assign out = o;
  end
  else if (METHOD == 1) begin
      eight_input_rom r0 (.in(in),.out(out[0]));
        defparam r0 .mask = 256'hbb23f64cbbbe99eb224883fb66f0853ebf6869447a703000fa244cc2c4f6f54a;
      eight_input_rom r1 (.in(in),.out(out[1]));
        defparam r1 .mask = 256'h08fb36349c4492694b3edf05c519cfb1eafca1c41d80c095278af97aa6faed25;
      eight_input_rom r2 (.in(in),.out(out[2]));
        defparam r2 .mask = 256'hd4ed0858cba4d063a8174b51f4f76d70066ecb30ff317f9c914a87953be14968;
      eight_input_rom r3 (.in(in),.out(out[3]));
        defparam r3 .mask = 256'hc21a4f3ceddcc8177b4df9b4da220cd1c67e14b661f51c623a33ab82e2758986;
      eight_input_rom r4 (.in(in),.out(out[4]));
        defparam r4 .mask = 256'h94796cc45c368f8bdb67e21e7645b347242535634bdad5c743a0248f2155e9b9;
      eight_input_rom r5 (.in(in),.out(out[5]));
        defparam r5 .mask = 256'habba8ef7872d518c98c5572aaf7ef2a1862233241073622f95de21da4167a5f4;
      eight_input_rom r6 (.in(in),.out(out[6]));
        defparam r6 .mask = 256'h9b68a34aa647c842fe7b054beb14def8811147420dbf3d2f5b28f323fc43e20d;
      eight_input_rom r7 (.in(in),.out(out[7]));
        defparam r7 .mask = 256'h015057d3fa286156af3152c24bb37fc247193377f0f0cb5664a46534f2dafd48;
  end
endgenerate
endmodule

////////////////////////////////////////////////////
// sub_bytes implemented as 4 by 4 array of SBOXes
////////////////////////////////////////////////////
module sub_bytes (in,out);
input [16*8-1 : 0] in;
output [16*8-1 : 0] out;
wire [16*8-1 : 0] out;

genvar i;
generate
    for (i=0; i<16; i=i+1)
    begin : sb
        sbox s (.in(in[8*i+7:8*i]), .out(out[8*i+7:8*i]));
    end
endgenerate
endmodule

////////////////////////////////////////////////////
// inv_sub_bytes implemented as 4x4 inv_SBOXes
////////////////////////////////////////////////////
module inv_sub_bytes (in,out);
input [16*8-1 : 0] in;
output [16*8-1 : 0] out;
wire [16*8-1 : 0] out;

genvar i;
generate
    for (i=0; i<16; i=i+1)
    begin : sb
        inv_sbox s (.in(in[8*i+7:8*i]), .out(out[8*i+7:8*i]));
    end
endgenerate
endmodule

