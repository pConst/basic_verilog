//------------------------------------------------------------------------------
// wb_if.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------


// INFO ------------------------------------------------------------------------
// Wishbone instantiation
//


interface wb_if #( parameter
  ADDR_W = 32,
  DATA_W = 32,
  SEL_W  = 4
  //TAG_W  = 4
);


  logic              ack;
  logic [ADDR_W-1:0] adr;
  logic              cyc;
  logic [DATA_W-1:0] dat;
  logic [DATA_W-1:0] dat;
  logic              err;
  logic              rty;
  logic [ SEL_W-1:0] sel;
  logic              stb;
  //logic [ TAG_W-1:0] tgd; // user-defined TAG signals
  logic              we;


  modport master_mp(

    input ack,
    input dat,
    input err,
    input rty,

    output adr,
    output cyc,
    output dat,
    output sel,
    output stb,
    //output tgd,
    output we
  );


  modport slave_mp(

    input adr,
    input cyc,
    input dat,
    input sel,
    input stb,
    //input tgd,
    input we,

    output ack,
    output dat,
    output err,
    output rty
  );


endinterface

