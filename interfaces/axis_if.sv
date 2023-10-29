//------------------------------------------------------------------------------
// axis_if.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------


// INFO ------------------------------------------------------------------------
// AXI4-Stream instantiation
//


interface axis_if #( parameter
  DATA_W = 32,
  ID_W   = 8,
  USER_W = 0
);


  localparam KEEP_W = DATA_W/8;

  logic [DATA_W-1:0] tdata;
  logic [  ID_W-1:0] tdest;
  logic [  ID_W-1:0] tid;
  logic [KEEP_W-1:0] tkeep;
  logic              tlast;
  logic              tready;
  logic [USER_W-1:0] tuser;
  logic              tvalid;


  modport master_mp(

    input  tready,

    output tdata,
    output tdest,
    output tid,
    output tkeep,
    output tlast,
    output tuser,
    output tvalid
  );


  modport slave_mp(

    input tdata,
    input tdest,
    input tid,
    input tkeep,
    input tlast,
    input tuser,
    input tvalid,

    output tready
  );


endinterface

