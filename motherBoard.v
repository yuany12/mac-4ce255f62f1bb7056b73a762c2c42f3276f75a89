module motherBoard (
  input clk, rst, clkClick, clk11M,
  inout [15:0] physical_mem_bus,
  output [17:0] physical_mem_addr,
  output physical_mem_read, physical_mem_write, physical_mem_enable,
	// debugger
  output vgaHs, vgaVs,
  output [2:0] vgaR, vgaG, vgaB,
  output [15:0] leddebug,
  // CPLD Seiral
  input tbre_1, tsre_1, dataReady_1,    // wires linked with CPLD
  inout [7:0] ram1DataBus,       // bus
  output rdn_1, wrn_1,
  output ram1Oe_1, ram1We_1, ram1En_1,
  
  // USB Serial
  input u_txd,
  output u_rxd


);
reg clk25M, clk12M, clk6M;

wire [175:0] registerValue; //vga
wire [15:0] memAaddr, memBaddr, memAdataRead, memBdataRead, MeMemResult;

//wire [7:0] serialPortDataRead_1, serialPortDataRead_2;
//wire [3:0] serialPortState_1, serialPortState_2;

wire [1:0] memRW;
wire [2:0] index;
wire [15:0] physicalMemAaddr, physicalMemBaddr, ramAdataRead, ramBdataRead, IfPC, IfIR,
		ExCalResult, MeCalResult;


wire [3:0] registerS, registerM, IdRegisterT, MeRegisterT; //vga

assign leddebug = IfPC;

cpu naive (
  clk11M, rst,
  memAaddr, memBaddr,
  ExCalResult, MeMemResult, memRW,
  memAdataRead, memBdataRead,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  MeCalResult
);

GraphicCard graphic (
  clk25M, rst,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  ExCalResult, MeCalResult,
  vgaHs, vgaVs,
  vgaR, vgaG, vgaB
);

//memoryMapping mapingA (
//  memAaddr,
//  physicalMemAaddr,
//  ramAdataRead,
//  serialPortDataRead_1,
//  serialPortState_1[1:0],
//  serialPortDataRead_2,
//  serialPortState_2[1:0],
//  memAdataRead,
//  index
//);
//
//memoryMapping mapingB (
//  memBaddr,
//  physicalMemBaddr,
//  ramBdataRead,
//  serialPortDataRead_1,
//  serialPortState_1[1:0],
//  serialPortDataRead_2,
//  serialPortState_2[1:0],
//  memBdataRead
//);

//memoryController memory(
//  clk11M,
//  physicalMemAaddr, MeMemResult,
//  memRW,
//  ramAdataRead,//out
//  physicalMemBaddr,
//  ramBdataRead,//out
//  physical_mem_bus,//out
//  physical_mem_addr,
//  physical_mem_read, physical_mem_write, physical_mem_enable
//);

//serialConn serial1 (
//  clk11M, rst,
//  tbre_1, tsre_1, dataReady_1,
//  memRW, index,
//  MeMemResult,
//  ram1DataBus,
//  rdn_1, wrn_1,
//  ram1Oe_1, ram1We_1, ram1En_1,
//  serialPortDataRead_1,
//  serialPortState_1
//);
//
//
//serialConn2 serial2(
//  clk11M, rst,
////  tbre_2, tsre_2, dataReady_2,
//  memRW, index,
//  MeMemResult,
////  uart2serial,
////  serial2uart,
////  rdn_2, wrn_2,
////  ram1Oe_2, ram1We_2, ram1En_2,
//  serialPortDataRead_2,
//  serialPortState_2,
//  u_txd,
//  u_rxd
//);


//wire indexB;

VirtualMemory virtualMemory(
  .clk(clk11M),
  .rst(rst),
  .memRW(memRW),
  .MeMemResult(MeMemResult), 
  
  .virtualAddrA(memAaddr),
  .actualRamAddrA(physicalMemAaddr),
  .ramDataA(ramAdataRead),
  .realDataA(memAdataRead),
  .indexA(index),
  
  .virtualAddrB(memBaddr),
  .actualRamAddrB(physicalMemBaddr),
  .ramDataB(ramBdataRead),
  .realDataB(memBdataRead),
//  .indexB(indexB),
  .tbre_1(tbre_1),
  .tsre_1(tsre_1), 
  .dataReady_1(dataReady_1),    // wires linked with CPLD
  .ram1DataBus(ram1DataBus),       // bus
  .rdn_1(rdn_1), 
  .wrn_1(wrn_1),
  .ram1Oe_1(ram1Oe_1),
  .ram1We_1(ram1We_1),
  .ram1En_1(ram1En_1),
  
  // USB Serial
  .u_txd(u_txd),
  .u_rxd(u_rxd),
	
	// physical memory
	.physical_mem_bus(physical_mem_bus),
	.physical_mem_addr(physical_mem_addr),
	.physical_mem_read(physical_mem_read),
	.physical_mem_write(physical_mem_write),
	.physical_mem_enable(physical_mem_enable)
);

// to be deleted if not used

always @ (negedge clk, negedge rst)
begin
  if (!rst)
    clk25M = 0;
  else
    clk25M = ~ clk25M;
end

always @ (negedge clk25M or negedge rst)
  if (!rst)
    clk12M = 0;
  else
    clk12M = ~ clk12M;
	 
always @ (negedge clk12M or negedge rst)
  if (!rst)
    clk6M = 0;
  else
    clk6M = ~ clk6M;

endmodule
