//------------------------------------------------------------------------------
// axi4_if.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------


// INFO ------------------------------------------------------------------------
// AXI4-M instantiation
//


interface axi4_if #( parameter
  ADDR_W = 32,
  DATA_W = 32,

  ID_W   = 8,

  ARUSER_W = 0,
  AWUSER_W = 0,
  BUSER_W = 0,
  RUSER_W = 0,
  WUSER_W = 0
);


  localparam STRB_W = DATA_W/8;

  logic [  ADDR_W-1:0] araddr;
  logic [         1:0] arburst;
  logic [         3:0] arcache;
  logic [    ID_W-1:0] arid;
  logic [         7:0] arlen;
  logic [         1:0] arlock;
  logic [         2:0] arprot;
  logic [         3:0] arqos;
  logic                arready;
  logic [         3:0] arregion;
  logic [         2:0] arsize;
  logic [ARUSER_W-1:0] aruser;
  logic                arvalid;

  logic [  ADDR_W-1:0] awaddr;
  logic [         1:0] awburst;
  logic [         3:0] awcache;
  logic [    ID_W-1:0] awid;
  logic [         7:0] awlen;
  logic [         1:0] awlock;
  logic [         2:0] awprot;
  logic [         3:0] awqos;
  logic                awready;
  logic [         3:0] awregion;
  logic [         2:0] awsize;
  logic [AWUSER_W-1:0] awuser;
  logic                awvalid;

  logic [    ID_W-1:0] bid;
  logic                bready;
  logic [         1:0] bresp;
  logic [ BUSER_W-1:0] buser;
  logic                bvalid;

  logic [  DATA_W-1:0] rdata;
  logic [    ID_W-1:0] rid;
  logic                rlast;
  logic                rready;
  logic [         1:0] rres
  logic [ RUSER_W-1:0] ruser;
  logic                rvalid;

  logic [  DATA_W-1:0] wdata;
  logic                wid;
  logic                wlast;
  logic                wready;
  logic [  STRB_W-1:0] wstrb;
  logic [ WUSER_W-1:0] wuser;
  logic                wvalid;


  modport master_mp(

    input arready,
    input awready,
    input bid,
    input bresp,
    input bvalid,
    input rdata,
    input rid,
    input rlast,
    input rresp,
    input rvalid,
    input wready,

    output araddr,
    output arburst,
    output arcache,
    output arid,
    output arlen,
    output arlock,
    output arprot,
    output arqos,
    output arregion,
    output arsize,
    output aruser,
    output arvalid,
    output awaddr,
    output awburst,
    output awcache,
    output awid,
    output awlen,
    output awlock,
    output awprot,
    output awqos,
    output awregion,
    output awsize,
    output awuser,
    output awvalid,
    output bready,
    output buser,
    output rready,
    output ruser,
    output wdata,
    output wid,
    output wlast,
    output wstrb,
    output wuser,
    output wvalid
  );


  modport slave_mp(

    input araddr,
    input arburst,
    input arcache,
    input arid,
    input arlen,
    input arlock,
    input arprot,
    input arqos,
    input arregion,
    input arsize,
    input aruser,
    input arvalid,
    input awaddr,
    input awburst,
    input awcache,
    input awid,
    input awlen,
    input awlock,
    input awprot,
    input awqos,
    input awregion,
    input awsize,
    input awuser,
    input awvalid,
    input bready,
    input buser,
    input rready,
    input ruser,
    input wdata,
    input wid,
    input wlast,
    input wstrb,
    input wuser,
    input wvalid,

    output arready,
    output awready,
    output bid,
    output bresp,
    output bvalid,
    output rdata,
    output rid,
    output rlast,
    output rresp,
    output rvalid,
    output wready
  );


endinterface

