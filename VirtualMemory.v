module VirtualMemory(
  input clk,
  input rst,
  
  input [1:0] memRW, 
  input [15:0] MeMemResult,

  input [15:0] virtualAddrA,
  output reg [15:0] actualRamAddrA,
 // input [15:0] ramDataA,
  output reg [15:0] realDataA,
  output reg [2:0] indexA,
  
  input [15:0] virtualAddrB,
  output reg [15:0] actualRamAddrB,
//  input [15:0] ramDataB,
  output reg [15:0] realDataB,
  

  input tbre_1, tsre_1, dataReady_1,    // wires linked with CPLD
  inout [7:0] ram1DataBus,       // bus
  output rdn_1, wrn_1,
  output ram1Oe_1, ram1We_1, ram1En_1,
  
  // USB Serial
  input u_txd,
  output u_rxd,
  
  // physical memory
  inout [15:0] physical_mem_bus,
  output [17:0] physical_mem_addr,
  output physical_mem_read, physical_mem_write, physical_mem_enable
  
);

wire [7:0] serialPortData_1;
wire [1:0] serialPortState_1;
wire [7:0] serialPortData_2;
wire [1:0] serialPortState_2;
wire [15:0] ramDataA, ramDataB; 

reg [2:0] indexB;

serialConn serial1 (
  clk, rst,
  tbre_1, tsre_1, dataReady_1,
  memRW, indexA,
  MeMemResult[7:0],
  ram1DataBus,
  rdn_1, wrn_1,
  ram1Oe_1, ram1We_1, ram1En_1,
  serialPortData_1,
  serialPortState_1
);

serialConn2 serial2(
  clk, rst,
  memRW, indexA,
  MeMemResult[7:0],
  serialPortData_2,
  serialPortState_2,
  u_txd,
  u_rxd
);

memoryController physicalMemory(
  .clk(clk), 
  .Aaddr(actualRamAddrA), //actualRamAddrA
  .dataWrite(MeMemResult),
  .rw(memRW),
  .AdataRead(ramDataA),//out
  .Baddr(actualRamAddrB),
  .BdataRead(ramDataB),//out
  .dataBus(physical_mem_bus),//inout
  .addrBus(physical_mem_addr),//out
  .memRead(physical_mem_read), //out
  .memWrite(physical_mem_write), //out
  .memEnable(physical_mem_enable) //out
);

  
localparam RAM = 3'b000,
  SERIALPORT_DATA_1 = 3'b010,
  SERIALPORT_STATE_1 = 3'b011,
  SERIALPORT_DATA_2 = 3'b110,
  SERIALPORT_STATE_2 = 3'b111;


always @ (virtualAddrA)
begin
  actualRamAddrA = virtualAddrA;
  if (virtualAddrA == 16'hbf00)
    indexA = SERIALPORT_DATA_1;
  else if (virtualAddrA == 16'hbf01)
    indexA = SERIALPORT_STATE_1;
  else if (virtualAddrA == 16'hbf02)
	 indexA = SERIALPORT_DATA_2;
  else if (virtualAddrA == 16'hbf03)
    indexA = SERIALPORT_STATE_2;
  else
    indexA = RAM;
end

always @ (*)
  case (indexA)
    RAM:
      realDataA = ramDataA;
    SERIALPORT_DATA_1:
      realDataA = {8'h00, serialPortData_1};
    SERIALPORT_STATE_1:
      realDataA = {14'b00000000000000, serialPortState_1};
	 SERIALPORT_DATA_2:
		realDataA = {8'h00, serialPortData_2};
	 SERIALPORT_STATE_2:
	   realDataA = {14'b00000000000000, serialPortState_2};
    default:
      realDataA = 0;
  endcase

always @ (virtualAddrB)
begin
  actualRamAddrB = virtualAddrB;
//  if (virtualAddrB == 16'hbf00)
//    indexB = SERIALPORT_DATA_1;
//  else if (virtualAddrB == 16'hbf01)
//    indexB = SERIALPORT_STATE_1;
//  else if (virtualAddrB == 16'hbf02)
//	 indexB = SERIALPORT_DATA_2;
//  else if (virtualAddrB == 16'hbf03)
//    indexB = SERIALPORT_STATE_2;
//  else
//    indexB = RAM;
end

always @ (*)
//  case (indexB)
//    RAM:
      realDataB = ramDataB;
//    SERIALPORT_DATA_1:
//      realDataB = {8'h00, serialPortData_1};
//    SERIALPORT_STATE_1:
//      realDataB = {14'b00000000000000, serialPortState_1};
//	 SERIALPORT_DATA_2:
//		realDataB = {8'h00, serialPortData_2};
//	 SERIALPORT_STATE_2:
//	   realDataB = {14'b00000000000000, serialPortState_2};
//    default:
//      realDataB = 0;
//  endcase
  
endmodule
