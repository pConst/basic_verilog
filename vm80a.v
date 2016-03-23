//
// copyright (c) 2014 by 1801BM1@gmail.com
// Licensed under CC-BY 3.0 (https://creativecommons.org/licenses/by/3.0/)
//
//______________________________________________________________________________
//
`timescale 1ns / 1ns

module vm80a
(
   input          pin_clk,       // global module clock (no in original 8080)
   input          pin_f1,        // clock phase 1 (used as clock enable)
   input          pin_f2,        // clock phase 2 (used as clock enable)
   input          pin_reset,     // module reset
   output[15:0]   pin_a,         // address bus outputs
   inout [7:0]    pin_d,         //
   input          pin_hold,      //
   output         pin_hlda,      //
   input          pin_ready,     //
   output         pin_wait,      //
   input          pin_int,       //
   output         pin_inte,      //
   output         pin_sync,      //
   output         pin_dbin,      //
   output         pin_wr_n
);

wire pin_aena, pin_dena;
wire [7:0] pin_din, pin_dout;
wire [15:0] pin_addr;
reg f1_core, f2_core;

assign pin_a = pin_aena ? pin_addr : 16'hZZZZ;
assign pin_d = pin_dena ? pin_dout : 8'hZZ;
assign pin_din = pin_d;

always @(posedge pin_clk)
begin
   f1_core <= pin_f1;
   f2_core <= pin_f2;
end

vm80a_core core
(
   .pin_clk    (pin_clk),
   .pin_f1     (f1_core),
   .pin_f2     (f2_core),
   .pin_reset  (pin_reset),
   .pin_a      (pin_addr),
   .pin_dout   (pin_dout),
   .pin_din    (pin_din),
   .pin_aena   (pin_aena),
   .pin_dena   (pin_dena),
   .pin_hold   (pin_hold),
   .pin_hlda   (pin_hlda),
   .pin_ready  (pin_ready),
   .pin_wait   (pin_wait),
   .pin_int    (pin_int),
   .pin_inte   (pin_inte),
   .pin_sync   (pin_sync),
   .pin_dbin   (pin_dbin),
   .pin_wr_n   (pin_wr_n)
);
endmodule

module vm80a_core
(
   input          pin_clk,       // global module clock (no in original 8080)
   input          pin_f1,        // clock phase 1 (used as clock enable)
   input          pin_f2,        // clock phase 2 (used as clock enable)
   input          pin_reset,     // module reset
   output[15:0]   pin_a,         // address bus outputs
   output[7:0]    pin_dout,      // data bus output
   input [7:0]    pin_din,       // data bus input
   output         pin_aena,      // address outputs enable
   output         pin_dena,      // data outputs enable
   input          pin_hold,      //
   output         pin_hlda,      //
   input          pin_ready,     //
   output         pin_wait,      //
   input          pin_int,       //
   output         pin_inte,      //
   output         pin_sync,      //
   output         pin_dbin,      //
   output         pin_wr_n
);

//______________________________________________________________________________
//
wire  [7:0]    d;
reg   [7:0]    db, di;
reg   [15:0]   a;
wire           clk, f1, f2;
reg            abufena, db_ena, db_stb, dbin_pin, dbinf2;
reg            reset;
wire           ready;
wire           dbin_ext;

reg            t851, t404, t382, t383, t712, t735, t773;
reg            hold, hlda_pin;
wire           hlda, h889;

reg            wr_n, t1124, t1011, sync;
wire           ready_int;

reg   [15:0]   r16_pc, r16_hl, r16_de, r16_bc, r16_sp, r16_wz, mxo;
wire  [15:0]   mxi;
wire           mxr0, mxr1, mxr2, mxr3, mxr4, mxr5;
wire           mxwh, mxwl, mxrh, mxrl, mxw16, mxwadr;
wire           dec16, inc16, iad16;
reg            xchg_dh, xchg_tt, t3144;
wire           t1460, t1467, t1513, t1514, t1519;

wire           sy_inta, sy_wo_n, sy_hlta, sy_out, sy_m1, sy_inp, sy_memr;
reg            sy_stack;

wire           thalt, twt2;
reg            t1, t2, tw, t3, t4, t5;
reg            t1f1, t2f1, twf1, t3f1, t4f1, t5f1;
reg            m1, m2, m3, m4, m5;
reg            m1f1, m2f1, m3f1, m4f1, m5f1;

wire           start, ms0, ms1, m836, m839, m871;
reg            eom, t789, t887, t953, t976, t980;

reg            intr, inta, inte, mstart, minta;
wire           irq;

reg   [7:0]    i;
reg            i25, i14, i03;
wire           imx, acc_sel;
wire           id_op, id_io, id_in, id_popsw, id_pupsw,
               id_nop, id_lxi, id_inx, id_inr, id_dcr, id_idr, id_mvi, id_dad,
               id_dcx, id_opa, id_idm, id_hlt, id_mov, id_opm, id_pop, id_rst,
               id_cxx, id_jxx, id_rxx, id_ret, id_jmp, id_opi, id_out, id_11x,
               id_rlc, id_rxc, id_rar, id_sha, id_daa, id_cma, id_stc, id_cmc,
               id_add, id_adc, id_sub, id_sbb, id_ana, id_xra, id_ora, id_cmp,
               id_lsax, id_mvim, id_shld, id_lhld, id_mvmr, id_mvrm, id_push,
               id_xthl, id_sphl, id_pchl, id_xchg, id_call, id_eidi, id_stlda;

wire           id80, id81, id82, id83, id84, id85, id86, id00, id01,
               id02, id03, id04, id05, id06, id07, id08, id09, id10;
wire           goto, jmpflag;
reg            jmptake, tree0, tree1, tree2;
reg            t2806, t2817, t2819, t3047, t2998, t3363, t3403, t3335, t3361;

reg   [7:0]    xr, r, acc;
wire  [7:0]    x, s, c;
wire           cl, ch, daa, daa_6x, daa_x6;
wire           a398;
reg            a327, a357, a358;
wire           alu_xout, alu_xwr, alu_xrd, alu_ald, alu_awr, alu_ard,
               alu_rld, alu_r00, alu_rwr, alu_srd, alu_zrd, alu_frd;

reg            psw_z, psw_s, psw_p, psw_c, psw_ac, tmp_c;
reg            t2222, t1375, t1497, t1698, t1668, t1780, t1993, t1994;
reg            psw_ld, psw_wr, t2046, t2133, t2175;

//_____________________________________________________________________________
//
assign clk        = pin_clk;
assign f1         = pin_f1;
assign f2         = pin_f2;

assign pin_a      = a;
assign pin_aena   = abufena;
assign pin_dout   = db;
assign pin_dena   = db_ena;

assign dbin_ext = dbinf2;
assign d[7]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[7]
               | mxrl & mxo[7]
               | mxrh & mxo[15]
               | t1f1 & sy_memr
               | alu_xrd & xr[7]
               | alu_ard & acc[7]
               | alu_frd & psw_s
               | alu_srd & s[7] );

assign d[6]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[6]
               | mxrl & mxo[6]
               | mxrh & mxo[14]
               | t1f1 & sy_inp
               | alu_xrd & xr[6]
               | alu_ard & acc[6]
               | alu_frd & psw_z
               | alu_srd & s[6] );

assign d[5]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[5]
               | mxrl & mxo[5]
               | mxrh & mxo[13]
               | t1f1 & sy_m1
               | alu_xrd & xr[5]
               | alu_ard & acc[5]
               | alu_frd & 1'b0
               | alu_srd & s[5] );

assign d[4]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[4]
               | mxrl & mxo[4]
               | mxrh & mxo[12]
               | t1f1 & sy_out
               | alu_xrd & xr[4]
               | alu_ard & acc[4]
               | alu_frd & psw_ac
               | alu_srd & s[4] );

assign d[3]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[3]
               | mxrl & mxo[3]
               | mxrh & mxo[11]
               | t1f1 & sy_hlta
               | alu_xrd & xr[3]
               | alu_ard & acc[3]
               | alu_frd & 1'b0
               | alu_srd & s[3] );

assign d[2]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[2]
               | mxrl & mxo[2]
               | mxrh & mxo[10]
               | t1f1 & sy_stack
               | alu_xrd & xr[2]
               | alu_ard & acc[2]
               | alu_frd & psw_p
               | alu_srd & s[2] );

assign d[1]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[1]
               | mxrl & mxo[1]
               | mxrh & mxo[9]
               | t1f1 & sy_wo_n
               | alu_xrd & xr[1]
               | alu_ard & acc[1]
               | alu_frd & 1'b1
               | alu_srd & s[1] );

assign d[0]    = ~reset & ~alu_zrd &
               ( dbin_ext & di[0]
               | mxrl & mxo[0]
               | mxrh & mxo[8]
               | t1f1 & sy_inta
               | alu_xrd & xr[0]
               | alu_ard & acc[0]
               | alu_frd & psw_c
               | alu_srd & s[0] );

always @(posedge clk)
begin
   if (f2 & db_stb) db <= d;
   if (f2) abufena <=  (~twt2 | ~thalt) & ~hlda_pin;
   if (f1) db_stb <= t1 | (~sy_wo_n & t2);
   if (f1) t851 <= t1 | (~sy_wo_n & (t2 | tw | t3));
   if (f2) db_ena <= ~reset & t851;
end

//______________________________________________________________________________
//
// reset input buffer
//
always @(posedge clk)
begin
   if (f1) t404  <= pin_reset;
   if (f2) reset <= t404;
end

//______________________________________________________________________________
//
// hold input buffer
//
assign pin_hlda = hlda_pin;
assign hlda = hold & (t773 | (t3 & sy_wo_n) | (~m1 & sy_hlta) | t735);
assign h889 = t2f1 | twf1;

always @(posedge clk)
begin
   if (f1)  t712 <= ~sy_wo_n & t3;
   if (f2)  t735 <= t712;
   if (~f2) t382 <= pin_hold;
   if (f2)  t383 <= ((~t382 & hold) | t383); // extend the front detector pulse for entire F2 duration
   if (~f2) t383 <= 1'b0;
   if (f2)  t773 <= hlda_pin;
   if (f1)  hlda_pin <= hlda;
end

always @(posedge clk)
begin
   if (reset)
      hold <= 1'b0;
   else
      if (f2)
         begin
            if (t382)
               begin
                  if (~sy_inta & h889) hold <= 1'b1;
               end
            else
               hold <= 1'b0;
         end
end

//______________________________________________________________________________
//
assign pin_dbin   = dbin_pin;
assign pin_wr_n   = wr_n;
assign pin_sync   = sync;

always @(posedge clk)
begin
   dbinf2 <= (f2 | dbin_pin) & ((t1124 & (m1f1 | ~sy_hlta)) | dbinf2);

   if (dbin_pin) di <= pin_din;
   if (f2) dbin_pin <= t1124 & (m1f1 | ~sy_hlta);
   if (f2) sync <= ~ready_int & t1011;
   if (f1) t1011 <= t1 & ~reset;
   if (f1) t1124 <= (t2 | tw) & sy_wo_n;
   if (f1) wr_n <= ~(t3 | tw) | ready_int | sy_wo_n;
end

//______________________________________________________________________________
//
// ready pin and internal circuits
//
assign ready_int = (m4 | m5) & id_dad;
assign ready = ready_int | pin_ready;
assign pin_wait = twf1;

//______________________________________________________________________________
//
// register unit - 6 16-bit registers
//
//    r0 - pc
//    r1 - hl, de
//    r2 - de, hl
//    r3 - bc
//    r4 - sp
//    r5 - wz
//
assign      t1467    = tree1 | (id04 & t4f1 & ~id_xthl);
assign      t1519    = tree2 | (id00 & t4f1 & ~id_xthl);
assign      mxi      = inc16 ? (a + 16'h0001)
                     : dec16 ? (a - 16'h0001)
                     : a;

assign      inc16    = iad16 & ~dec16;
assign      dec16    = iad16 & id05 & (t4f1 | t5f1 | m4f1 | m5f1);
assign      iad16    = ~(id00 & (t4f1 | t5f1)) & (~minta | m5 | t3144);

assign      mxw16    = t3403;
assign      mxwadr   = t3363 | (t4f1 & ~id_dad & ~id_hlt);
assign      t1513    = (t4f1 & id07) | t3335;
assign      t1514    = (t4f1 & id08) | t3361;

assign      mxrh     = t2998 | (id08 & t4f1 & ~i03);
assign      mxrl     = t3047 | (id08 & t4f1 & i03);
assign      mxwh     = t2817 | (t2806 & ~i03);
assign      mxwl     = t2819 | (t2806 & i03);

assign      mxr0     = tree0;
assign      mxr1     =  xchg_dh & (((t1513 | t1514) & (~i14 & i25)) | t1519)
                     | ~xchg_dh & (t1513 | t1514) & (i14 & ~i25);
assign      mxr2     =  xchg_dh & (t1513 | t1514) & (i14 & ~i25)
                     | ~xchg_dh & (((t1513 | t1514) & (~i14 & i25)) | t1519);
assign      mxr3     = (t1513 | t1514) & (~i14 & ~i25);
assign      mxr4     = t1467 | (t1513 & i14 & i25);
assign      mxr5     = ~(t1467 | t1513 | t1514 | t1519 | mxr0);

always @ (posedge clk)
begin
      if (f1) t3144 <= t4 | t5 | (m4 & ~id02);
      xchg_tt <= id_xchg & t2;
      xchg_dh <= ~reset & ((xchg_tt & ~(id_xchg & t2)) ? ~xchg_dh : xchg_dh);
end

always @ (*)
case ({mxr0, mxr1, mxr2, mxr3, mxr4, mxr5})
   6'b100000:  mxo = r16_pc;
   6'b010000:  mxo = r16_hl;
   6'b001000:  mxo = r16_de;
   6'b000100:  mxo = r16_bc;
   6'b000010:  mxo = r16_sp;
   6'b000001:  mxo = r16_wz;
   default:    mxo = 16'h0000;
endcase

always @ (posedge clk)
if (f2)
begin
   if (mxwadr) a <= mxo;
   if (mxw16)
      begin
         if (mxr0) r16_pc <= mxi;
         if (mxr1) r16_hl <= mxi;
         if (mxr2) r16_de <= mxi;
         if (mxr3) r16_bc <= mxi;
         if (mxr4) r16_sp <= mxi;
         if (mxr5) r16_wz <= mxi;
      end
   else
      begin
         if (mxwl)
            begin
               if (mxr0) r16_pc[7:0] <= d;
               if (mxr1) r16_hl[7:0] <= d;
               if (mxr2) r16_de[7:0] <= d;
               if (mxr3) r16_bc[7:0] <= d;
               if (mxr4) r16_sp[7:0] <= d;
               if (mxr5) r16_wz[7:0] <= d;
            end
         if (mxwh)
            begin
               if (mxr0) r16_pc[15:8] <= d;
               if (mxr1) r16_hl[15:8] <= d;
               if (mxr2) r16_de[15:8] <= d;
               if (mxr3) r16_bc[15:8] <= d;
               if (mxr4) r16_sp[15:8] <= d;
               if (mxr5) r16_wz[15:8] <= d;
            end
      end
end

//______________________________________________________________________________
//
// processor state
//
assign sy_hlta = id_hlt;
assign sy_m1   = m1;
assign sy_inp  = m5 & id_in;
assign sy_out  = m5 & id_out;
assign sy_inta = inta;
assign sy_memr = sy_wo_n & ~sy_inp & ~minta;
assign sy_wo_n  = m1 | m2 | m3 | (((m4 & ~id86) | (m5 & ~id85)) & ~ready_int);

always @(posedge clk)
begin
   if (f1)
      begin
         sy_stack <= (t1 & t1460)
                   | (t3 & m3 & id_cxx & ~jmptake)
                   | (t5 & m1 & id_rxx & ~jmptake);
      end
end
//______________________________________________________________________________
//
// ticks state machine
//
assign twt2    = (t2f1 | twf1) & ~start;
assign thalt   = ~m1 & sy_hlta;

always @(posedge clk)
begin
   if (f1)
      begin
         t1f1 <= t1 & ~reset; // ensure the reliable start after reset
         t2f1 <= t2;
         twf1 <= tw;
         t3f1 <= t3;
         t4f1 <= t4;
         t5f1 <= t5;
      end
   if (f2)
      begin
         t1 <= start;
         t2 <= ~start & t1f1;
         tw <= ~start & (t2f1 | twf1) & (~ready | thalt);
         t3 <= ~start & (t2f1 | twf1) &  ready & ~thalt;
         t4 <= ~start & t3f1 & ms0 & ~ms1;
         t5 <= ~start & t4f1 & ms0 & ~ms1;
      end
end

//______________________________________________________________________________
//
assign m836 = m1f1 & id82;
assign m839 = ~t976 | ~sy_hlta;
assign m871 = t789 | id81;

assign start = ~m839
             | t953
             | (eom & ~(hold & t887))
             | (f2 & ((~t382 & hold) | t383) & ~(twf1 | t3f1 | t4f1 | t5f1));

assign ms0 = ~reset & m839 & ~(sy_stack & ~t1f1) & ~(eom & ~m836);
assign ms1 = ~reset & m839 & ~(sy_stack & ~t1f1) & ~(m871 & ~m836) & eom;

always @(posedge clk)
begin
   if (f1)
      begin
         t789 <= (id84 & m3) | (id83 & ~id_mvim & m4) | m5;
         t887 <= hold;
         t953 <= reset;
         t976 <= t980 & m4;
         eom <= t5
              | t4 & m1 & id80
              | t3 & m2
              | t3 & m3
              | t3 & m4
              | t3 & m5 & ~id_xthl;
      end
   if (f2)
      begin
         t980 <= sy_inta;
      end
end

//______________________________________________________________________________
//
// processor cycles state machine
//
always @(posedge clk)
begin
   if (f1)
      begin
         m1f1 <= m1;
         m2f1 <= m2;
         m3f1 <= m3;
         m4f1 <= m4;
         m5f1 <= m5;
      end
   if (f2)
      begin
         m1 <= (~ms0 & ~ms1) | (~ms1 & m1f1);
         m2 <= (~ms0 | ~ms1) & ((ms0 & m2f1) | (ms1 & m1f1));
         m3 <= (ms0 & m3f1) | (ms1 & m2f1);
         m4 <= (ms0 & m4f1) | (ms1 & m3f1) | (ms0 & ms1);
         m5 <= (ms0 & m5f1) | (ms1 & m4f1);
      end
end

//______________________________________________________________________________
//
// interrupt logic
//
assign irq = intr & inte & ~reset & ~hold;
assign pin_inte = inte;

always @(posedge clk)
begin
   if (f2) intr <= pin_int;
   if (f2) mstart <= ~ms0 & ~ms1;
   if (sy_inta) minta <= 1;
   if (f1 & t1 & m1) minta <= 0;
end

always @(posedge clk or posedge reset)
begin
   if (reset)
      begin
         inta <= 0;
         inte <= 0;
      end
   else
      begin
         if (f1)
            begin
               if (irq & ((tw & sy_hlta) | (mstart & ~id_eidi))) inta <= 1;
               if (~intr | id_eidi | (t5 & id_rst)) inta <= 0;
            end
         if (f2)
            begin
               if (t1f1 & id_eidi) inte <= i[3];
               if (t1f1 & sy_inta) inte <= 0;
            end
      end
end
//______________________________________________________________________________
//
// instruction register and decoder
//
function cmp
(
   input [7:0] i,
   input [7:0] c,
   input [7:0] m
);
   cmp = &(~(i ^ c) | m);
endfunction

assign imx     = ~(id_op | (id_mov & t4));
assign acc_sel = imx ? (i[5:3] == 3'b111) : (i[2:0] == 3'b111);
assign jmpflag =    (psw_c &  i14 & ~i25)    // Intel original: d[0] instead of psw_c
                  | (psw_p & ~i14 &  i25)    // Intel original: d[2] instead of psw_p
                  | (psw_z & ~i14 & ~i25)    // Intel original: d[6] instead of psw_z
                  | (psw_s &  i14 &  i25);   // Intel original: d[7] instead of psw_s

always @(posedge clk)
begin
   //
   // Simplify the D-bus multiplexer and feed the I-register by input pins directly
   //
   if (~f2 & (reset | (m1 & t3))) i <= pin_din;
   if (f1)
      begin
         i25 <= imx ? i[5] : i[2];
         i14 <= imx ? i[4] : i[1];
         i03 <= imx ? i[3] : i[0];
      end
end

assign goto    = id_rst | id_jmp | id_call | (jmptake & (id_cxx | id_jxx));
assign t1460   = (t1 & ( (m2 & id00)
                      | (m3 & id00)
                      | (m4 & (id01 | id04))
                      | (m5 & (id01 | id04)))
               | t2 & ( (m2 & id00)
                      | (m4 & id01)
                      | (m5 & id01))
               | t3 & ( (m4 & (id04 | id_sphl)))
               | t5 & ( (m1 & (id04 | id_sphl)))) & ~(~jmptake & id_cxx & t5);

always @(posedge clk)
begin
   if (f2 & t4f1)
      begin
         jmptake <= i03 ? jmpflag : ~jmpflag;
      end
   if (f1)
      begin
         tree0 <= t1 & ( (m1 & ~goto)
                       | (m2 & ~id_xthl)
                       | (m3 & ~id_xthl)
                       | (m4 & id02))
                | t2 & (  m1
                       | (m2 & ~id_xthl)
                       | (m3 & ~id_xthl)
                       | (m4 & (id02 | id_rst | id_cxx | id_call))
                       | (m5 & (id_rst | id_cxx | id_call)))
                | t3 & ( (m4 & (id_ret | id_rxx))
                       | (m5 & (id_ret | id_rxx)))
                | t5 & id_pchl;

         tree1 <= t1460;

         tree2 <= t1 & ( (m4 & (id_mov | id_idr | id_op))
                       | (m5 & id08))
                | t2 & ( (m4 & (id_shld | id00 | id_dad))
                       | (m5 & (id_shld | id00 | id_dad)))
                | t3 & ( (m4 & (id_lhld | id_dad))
                       | (m5 & (id_lhld | id_dad)))
                | t5 & m5;

         t2806 <= id08 & ((t3 & m4) | (t5 & m1));
         t2817 <= reset | (t3 & (m1 | m3 | (m4 & id_io) | (m5 & id06)));
         t2819 <= reset | (t3 & (m2 | (m4 & id06) | (m5 & id_rst)));

         t3047 <= m4 & (t1 | t2) & id_dad
                | t2 & ((m4 & id_shld) | (m5 & id03));

         t2998 <= (t1 | t2) & m5 & id_dad
                | t2 & ((m5 & id_shld) | (m4 & id03));

         t3403 <= t2 & ( (m1 | m2)
                       | (m3 & ~id_xthl)
                       | ((m4 | m5) & ~id_dad & ~id09))
                | t3 & m4 & id09
                | t5 & (m5 | (m1 & ~id08));

         t3363 <= t1 & (m1 | m2 | m3 | ((m4 | m5) & ~id_hlt & ~id_dad));
         t3335 <= id07 & ((t1 & (m4 | m5)) | (t3 & (m2 | m3)) | t5);

         t3361 <= t1 & m4 & id_lsax
                | t2 & id10 & ~sy_wo_n
                | t3 & id10 & sy_wo_n & (m4 | m5)
                | t5 & id08 & m1;
      end
end

assign id_nop     = cmp(i, 8'b00xxx000, 8'b00111000);
assign id_lxi     = cmp(i, 8'b00xx0001, 8'b00110000);
assign id_lsax    = cmp(i, 8'b000xx010, 8'b00011000);
assign id_inx     = cmp(i, 8'b00xx0011, 8'b00110000);
assign id_inr     = cmp(i, 8'b00xxx100, 8'b00111000);
assign id_dcr     = cmp(i, 8'b00xxx101, 8'b00111000);
assign id_idr     = cmp(i, 8'b00xxx10x, 8'b00111001);
assign id_mvi     = cmp(i, 8'b00xxx110, 8'b00111000);
assign id_dad     = cmp(i, 8'b00xx1001, 8'b00110000);
assign id_dcx     = cmp(i, 8'b00xx1011, 8'b00110000);
assign id_opa     = cmp(i, 8'b00xxx111, 8'b00111000);
assign id_idm     = cmp(i, 8'b0011010x, 8'b00000001);
assign id_stlda   = cmp(i, 8'b0011x010, 8'b00001000);
assign id_mvim    = cmp(i, 8'b00110110, 8'b00000000);
assign id_shld    = cmp(i, 8'b00100010, 8'b00000000);
assign id_lhld    = cmp(i, 8'b00101010, 8'b00000000);
assign id_mvmr    = cmp(i, 8'b01110xxx, 8'b00000111) & ~id_hlt;
assign id_mvrm    = cmp(i, 8'b01xxx110, 8'b00111000) & ~id_hlt;
assign id_hlt     = cmp(i, 8'b01110110, 8'b00000000);
assign id_mov     = cmp(i, 8'b01xxxxxx, 8'b00111111);
assign id_op      = cmp(i, 8'b10xxxxxx, 8'b00111111);
assign id_opm     = cmp(i, 8'b10xxx110, 8'b00111000);
assign id_pop     = cmp(i, 8'b11xx0001, 8'b00110000);
assign id_push    = cmp(i, 8'b11xx0101, 8'b00110000);
assign id_rst     = cmp(i, 8'b11xxx111, 8'b00111000);
assign id_xthl    = cmp(i, 8'b11100011, 8'b00000000);
assign id_sphl    = cmp(i, 8'b11111001, 8'b00000000);
assign id_pchl    = cmp(i, 8'b11101001, 8'b00000000);
assign id_xchg    = cmp(i, 8'b11101011, 8'b00000000);
assign id_cxx     = cmp(i, 8'b11xxx100, 8'b00111000);
assign id_jxx     = cmp(i, 8'b11xxx010, 8'b00111000);
assign id_rxx     = cmp(i, 8'b11xxx000, 8'b00111000);
assign id_ret     = cmp(i, 8'b110x1001, 8'b00010000);
assign id_call    = cmp(i, 8'b11xx1101, 8'b00110000);
assign id_eidi    = cmp(i, 8'b1111x011, 8'b00001000);
assign id_jmp     = cmp(i, 8'b1100x011, 8'b00001000);
assign id_io      = cmp(i, 8'b1101x011, 8'b00001000);
assign id_opi     = cmp(i, 8'b11xxx110, 8'b00111000);
assign id_in      = cmp(i, 8'b11011011, 8'b00000000);
assign id_popsw   = cmp(i, 8'b11110001, 8'b00000000);
assign id_out     = cmp(i, 8'b11010011, 8'b00000000);
assign id_11x     = cmp(i, 8'b11xxxxxx, 8'b00111111);
assign id_pupsw   = cmp(i, 8'b11110101, 8'b00000000);

assign id_rxc     = ~i[5] & i[3] & id_opa;
assign id_sha     = ~i[5]        & id_opa;
assign id_rlc     = (i[5:3] == 3'b000) & id_opa;
assign id_rar     = (i[5:3] == 3'b011) & id_opa;
assign id_daa     = (i[5:3] == 3'b100) & id_opa;
assign id_cma     = (i[5:3] == 3'b101) & id_opa;
assign id_stc     = (i[5:3] == 3'b110) & id_opa;
assign id_cmc     = (i[5:3] == 3'b111) & id_opa;

assign id_add     = (i[5:3] == 3'b000) & (id_op | id_opi);
assign id_adc     = (i[5:3] == 3'b001) & (id_op | id_opi);
assign id_sub     = (i[5:3] == 3'b010) & (id_op | id_opi);
assign id_sbb     = (i[5:3] == 3'b011) & (id_op | id_opi);
assign id_ana     = (i[5:3] == 3'b100) & (id_op | id_opi);
assign id_xra     = (i[5:3] == 3'b101) & (id_op | id_opi);
assign id_ora     = (i[5:3] == 3'b110) & (id_op | id_opi);
assign id_cmp     = (i[5:3] == 3'b111) & (id_op | id_opi);

assign id80       = id_lxi  | id_pop   | id_opm  | id_idm  | id_dad
                  | id_xthl | id_xchg  | id_jxx  | id_ret  | id_eidi
                  | id_nop  | id_stlda | id_mvmr | id_mvrm | id_hlt
                  | id_opa  | id_mvim  | id_jmp  | id_io   | id_opi
                  | id_mvi  | id_lsax  | id_lhld | id_shld | id_op;
assign id81       = id_dcx  | id_inx   | id_sphl | id_pchl | id_xchg
                  | id_eidi | id_nop   | id_opa  | id_op   | id_mov
                  | (id_idr & ~id82);
assign id82       = id_pop  | id_push  | id_opm  | id_idm  | id_dad
                  | id_rst  | id_ret   | id_rxx  | id_mvrm | id_mvmr
                  | id_hlt  | id_mvim  | id_io   | id_opi  | id_mvi
                  | id_lsax;
assign id83       = id_opm  | id_stlda | id_mvmr | id_mvrm | id_opi
                  | id_mvi  | id_lsax;
assign id84       = id_lxi  | id_jxx   | id_jmp;
assign id85       = id_push | id_idm   | id_rst  | id_xthl | id_cxx
                  | id_call | id_mvim  | id_shld | (id_io & ~i[3]);
assign id86       = id_push | id_rst   | id_xthl | id_cxx  | id_call
                  | id_mvmr | id_shld  | (~i[3] & (id_lsax | id_stlda));

assign id00       = id_xthl   | id_pchl  | id_sphl;
assign id01       = id_pop    | id_rxx   | id_ret;
assign id02       = id_mvi    | id_opi   | id_io;
assign id03       = id_rst    | id_push  | id_xthl | id_cxx  | id_call;
assign id04       = id_rst    | id_push  | id_xthl | id_cxx  | id_call;
assign id05       = id_rst    | id_push  | id_xthl | id_cxx  | id_call | id_dcx;
assign id06       = id_pop    | id_rxx   | id_ret  | id_dad  | id_lhld | id_io;
assign id07       = id_dcx    | id_inx   | id_lxi  | id_dad;
assign id08       = id_mov    | id_mvi   | id_idr  | id_op;
assign id09       = id_rst    | id_push  | id_xthl | id_cxx  | id_call | id_shld;
assign id10       = id_pop    | id_push  | id_mvrm | id_mvi;

//______________________________________________________________________________
//
// function alu
// (
//    input    rxc,
//    input    ora,
//    input    ana,
//    input    xra,
//    input    x,
//    input    r,
//    input    nc,
//    input    rn,
//    input    cp
// );
// alu = x & r & cp        & ~(rxc | ora | ana | xra)
//     | nc & (cp | x | r) & ~(rxc | ora | ana | xra)
//     | rxc & rn
//     | ora & (x | r)
//     | ana & (x & r)
//     | xra & (x ^ r);
// endfunction
//
//
// assign s[0] = alu(id_rxc, id_ora, id_ana, id_xra, x[0], r[0], ~c[0], r[1], cl) | (id_rlc & c[7]);
// assign s[1] = alu(id_rxc, id_ora, id_ana, id_xra, x[1], r[1], ~c[1], r[2], c[0]);
// assign s[2] = alu(id_rxc, id_ora, id_ana, id_xra, x[2], r[2], ~c[2], r[3], c[1]);
// assign s[3] = alu(id_rxc, id_ora, id_ana, id_xra, x[3], r[3], ~c[3], r[4], c[2]);
// assign s[4] = alu(id_rxc, id_ora, id_ana, id_xra, x[4], r[4], ~c[4], r[5], c[3]);
// assign s[5] = alu(id_rxc, id_ora, id_ana, id_xra, x[5], r[5], ~c[5], r[6], c[4]);
// assign s[6] = alu(id_rxc, id_ora, id_ana, id_xra, x[6], r[6], ~c[6], r[7], c[5]);
// assign s[7] = alu(id_rxc, id_ora, id_ana, id_xra, x[7], r[7], ~c[7], ch,   c[6]);
//
//
//______________________________________________________________________________
//
// arithmetic and logic unit
//
// assign alu_xwr = (f1 & m1 & t3) | (f2 & (a327 | t4f1 & (id_out | ~id_11x)));
//
assign alu_xwr  =  (a327 | t4f1 & (id_rst | id_out | ~id_11x));
assign alu_xout = ~(id_sub | id_sbb | id_cmp | id_cma);
assign alu_xrd  = t1698 | a358;
assign x = alu_xout ? xr : ~xr;

assign alu_ald = t2222 & ( id_adc | id_add | id_daa | id_xra | id_sbb
                         | id_sub | id_ana | id_ora | id_sha | id_cma);
assign alu_ard = t1375 | a398;
assign alu_awr = t1497 | a357;

assign alu_r00 = id_dcr & t4f1;
assign alu_srd = t1668;
assign alu_rwr = t1780;
assign alu_rld = t4f1 & (id_sha | id_op | id_opi);

assign daa = id_daa & t4f1;
assign daa_x6 = (acc[3] & (acc[2] | acc[1])) | psw_ac;
assign daa_6x = ((acc[3] & (acc[2] | acc[1])) & acc[4] & acc[7])
              | (acc[7] & (acc[6] | acc[5])) | tmp_c;

assign s  = {7'b0000000, id_rlc & c[7]}
          | ((id_rxc | id_ora | id_ana | id_xra) ? 8'h00 : (x + r + cl))
          | (id_rxc  ? {ch, r[7:1]} : 8'h00)
          | (id_ora  ? (x | r) : 8'h00)
          | (id_ana  ? (x & r) : 8'h00)
          | (id_xra  ? (x ^ r) : 8'h00);

assign cl = tmp_c & ~id_daa & ~id_rlc & ~id_ora & ~id_xra & ~id_rxc;
assign ch = tmp_c & id_rar | r[0] & ~id_rar;

//
// wire ca0_n, ca2_n, ca1, ca3;
// assign ca0_n = ~(cl   & (x[0] | r[0])) & ~(x[0] & r[0]) & ~(id_ana & id_rxc);
// assign ca2_n = ~(ca1  & (x[2] | r[2])) & ~(x[2] & r[2]) & ~(id_ana & id_rxc);
// assign ca1   = ~(~x[1] & ~r[1]) & ~(ca0_n & (~x[1] | ~r[1])) & ~(id_ora | id_rxc | id_xra);
// assign ca3   = ~(~x[3] & ~r[3]) & ~(ca2_n & (~x[3] | ~r[3])) & ~(id_ora | id_rxc | id_xra);
//
assign c[0] = (r[0] & x[0]) | (cl & (r[0] | x[0]));
assign c[1] = (r[1] & x[1]) | (c[0] & (r[1] | x[1]));
assign c[2] = (r[2] & x[2]) | (c[1] & (r[2] | x[2]));
assign c[3] = (r[3] & x[3]) | (c[2] & (r[3] | x[3]));
assign c[4] = (r[4] & x[4]) | (c[3] & (r[4] | x[4]));
assign c[5] = (r[5] & x[5]) | (c[4] & (r[5] | x[5]));
assign c[6] = (r[6] & x[6]) | (c[5] & (r[6] | x[6]));
assign c[7] = (r[7] & x[7]) | (c[6] & (r[7] | x[7]));

assign alu_frd = t2046; /* | t4f1 & (id_11x & ~id_out); */
assign alu_zrd = m1f1 & t3f1;

assign a398 = t1993 & ((t1994 & id08) | id_opa | id_stlda | id_lsax | id_io);

always @(posedge clk)
begin
   if (f1)
      begin
         t1375 <= t2 & m4 & id_pupsw;
         t1497 <= t3 & m5 & id_popsw;
         t1698 <= t5 & m1 & ~id_inr & ~id_dcr
                | t3 & m5 & id_rst;
         t1668 <= t2 & m5 & (id_inr | id_dcr)
                | t3 & m5 & id_dad
                | t3 & m4 & id_dad
                | t5 & m1 & (id_inr | id_dcr);
         t1780 <= t3 & m1
                | t1 & (m4 | m5) & id_dad;
         t2222 <= (t2 & m1) | (t1 & m5);
         a327  <= t3 & m4 & ~(id_dad | id_out | id_rst)
                | t2 & (m4 | m5) & id_dad;
         a357  <= t3 & m5 & (id_io | id_mvim) & sy_wo_n
                | t3 & m4 & (id_stlda | id_lsax | id_mvmr) & sy_wo_n
                | acc_sel & id08 & (t5 & m1 | t3 & m4);
         a358  <= t2 &  ~sy_wo_n & (id_io | id_mvim | id_stlda | id_lsax | id_mvmr);

         psw_ld   <= t3 & m4 & id_popsw;
         psw_wr   <= t2 & m1 & (id_opi | id_inr | id_dcr | id_daa | id_op);
         t2046    <= t2 & m5 & id_pupsw;  /* | reset | t3 & m1; */
//
//       t2047    <= reset
//                 | t3 & m1
//                 | t3 & m5 & id_rst;
//
         t1993    <= t4 & m1;
         t1994    <= acc_sel;
         t2133    <= ~id_rxc & c[7];
         t2175    <= t3 & m1
                   | t2 & m5 & id_dad;
      end
end

always @(posedge clk)
begin
   if (f2)
      begin
         if (alu_xwr) xr <= id_rst ? (i & 8'b00111000) : d;
         if (alu_awr) acc <= d;
         if (alu_ald) acc <= s;
         if (alu_rld) r <= acc;
         if (alu_rwr) r <= d;
         if (alu_r00) r <= 8'hff;
         if (daa)
            begin
               r[1] <= daa_x6;
               r[2] <= daa_x6;
               r[5] <= daa_6x;
               r[6] <= daa_6x;
            end
         if (psw_ld)
            begin
               psw_c  <= d[0]; // x register was in original Intel design
               psw_p  <= d[2];
               psw_ac <= d[4];
               psw_z  <= d[6];
               psw_s  <= d[7];
            end
         if (psw_wr)
            begin
               psw_p  <= ~(^s);
               psw_ac <= (c[3] & ~id_xra & ~id_ora & ~id_rxc) | (id_ana & (x[3] | r[3]));
               psw_z  <= ~(|s);
               psw_s  <= s[7];
            end
         if (t2222)
            begin
               if (id_xra | id_stc | id_ora | id_ana | id_cmc)
                  psw_c <= ~tmp_c;
               if (id_cmp | id_sbb | id_sub)
                  psw_c <= ~(t2133 | id_rxc & x[0]);
               if (id_dad | id_sha | id_adc | id_add)
                  psw_c <= t2133 | id_rxc & x[0];
            end
         if (daa & daa_6x)
                  psw_c <= 1'b1;

         if (t2175)
            tmp_c <= psw_c;
         if (t4f1)
            begin
               if (id_sbb)
                  tmp_c <= ~psw_c;
               if (id_inr | id_ora | id_xra | id_ana | id_cmp | id_sub)
                  tmp_c <= 1'b1;
               if (id_dad | id_cma | id_dcr | id_add | id_stc)
                  tmp_c <= 1'b0;
            end
      end
end

//______________________________________________________________________________
//
endmodule
