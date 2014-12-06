module cpu (
  input clk, rst,
  output [15:0] MeAaddr, Baddr,
  output [15:0] ExCalResult,
  output [15:0] MeMemResult,
  output [1:0] MeMemControl,
  input [15:0] AmemRead, BmemRead,
  // vga debug signals
  output [175:0] registerValue,
  output [15:0] nextPC, IfIR,
  output [3:0] registerS, registerM, IdRegisterT, MeRegisterT,
  output [15:0] MeCalResult
);

wire [15:0] IfPC, IdIR, IdPC;
wire [15:0] rs, rm;
wire t;
wire tWriteEnable, tToWrite;
wire [2:0] jumpControl;
//wire [3:0] registerS, registerM;
wire [1:0] ExMemControl/*, MeMemControl*/;
wire [15:0] originValueS, originValueM;
wire [15:0] sourceValueS, sourceValueM;
wire [3:0] /*IdRegisterT,*/ ExRegisterT;//, MeRegisterT;
//wire [15:0] MeCalResult;
wire [15:0] ExAaddr/*, MeAaddr, MeMemResult*/;

PCadder pcAdder (
  clk, rst,
  nextPC,
  IfIR,
  rs,
  t,
  jumpControl,
  nextPC
);

instructionReader reader (
  clk, rst,
  nextPC,
  BmemRead,
  Baddr,
  IfIR
);

instructionDecoder decoder (
  clk, rst,
  IfIR,
  registerS, registerM, IdRegisterT,
  jumpControl
);

Register registerFile (
  clk, rst,
  registerS, registerM,
  tWriteEnable, tToWrite,
  MeRegisterT,
  MeCalResult,
  registerValue,
  originValueS, originValueM,
  t
);

flipflop #(16) IfPCFF (clk, rst, nextPC, IfPC);
flipflop #(16) IdIRFF (clk, rst, IfIR, IdIR);
flipflop #(4) ExRegisterTFF ( clk, rst, IdRegisterT, ExRegisterT );
flipflop #(4) MeRegisterTFF(clk, rst, ExRegisterT, MeRegisterT );
flipflop #(2) MeMemControlFF( clk, rst, ExMemControl, MeMemControl );
flipflop #(16) MeMemResultFF(clk, rst, ExCalResult, MeMemResult);
flipflop #(16) MeAaddrResultFF(clk, rst, ExAaddr, MeAaddr);

alu calculator (
  clk, rst,
  rs, rm,
  IfPC, IdIR,
  ExCalResult,
  tWriteEnable, tToWrite
);

memAddressCalculator addrCalculator(
  clk, rst,
  IdIR,
  rm,
  ExMemControl,
  ExAaddr
);
 
mux_B_buffered MeCalResultMux (
  clk, rst,
  MeMemControl[1],
  AmemRead,
  ExCalResult,
  MeCalResult
);

wire X_conflict_ME, Y_conflict_ME, X_conflict_EX, Y_CONFLICT_EX;
assign X_conflict_ME = (registerS != MeRegisterT);
assign Y_conflict_ME = (registerM != MeRegisterT);
assign X_conflict_EX = (registerS != ExRegisterT);
assign Y_conflict_EX = (registerM != ExRegisterT);
//
//muxCombine MeIdByPassS(X_conflict_ME, originValueS, MeCalResult, sourceValueS);
//muxCombine MeIdByPassM(Y_conflict_ME, originValueM, MeCalResult, sourceValueM);
//muxCombine ExIdByPassS(X_conflict_EX, sourceValueS, ExCalResult, rs);
//muxCombine ExIdByPassM(Y_conflict_EX, sourceValueM, ExCalResult, rm);

byPass MeIdByPassS (
  registerS,
  originValueS,
  MeRegisterT,
  MeCalResult,
  sourceValueS
);

byPass MeIdByPassM (
  registerM,
  originValueM,
  MeRegisterT,
  MeCalResult,
  sourceValueM
);

byPass ExIdByPassS (
  registerS,
  sourceValueS,
  ExRegisterT,
  ExCalResult,
  rs
);

byPass ExIdByPassM (
  registerM,
  sourceValueM,
  ExRegisterT,
  ExCalResult,
  rm
);

endmodule

