module memoryMapping (
  input [15:0] virtualAddr,
  output reg [15:0] actualRamAddr,
  input [15:0] ramData,

  input [7:0] serialPortData_1,
  input [1:0] serialPortState_1,

  input [7:0] serialPortData_2,
  input [1:0] serialPortState_2,

  output reg [15:0] realData,
  output reg [2:0] index
);

localparam RAM = 3'b000,
  SERIALPORT_DATA_1 = 3'b010,
  SERIALPORT_STATE_1 = 3'b011,
  SERIALPORT_DATA_2 = 3'b110,
  SERIALPORT_STATE_2 = 3'b111;


always @ (virtualAddr)
begin
  actualRamAddr = virtualAddr;
  if (virtualAddr == 16'hbf00)
    index = SERIALPORT_DATA_1;
  else if (virtualAddr == 16'hbf01)
    index = SERIALPORT_STATE_1;
  else if (virtualAddr == 16'hbf02)
	 index = SERIALPORT_DATA_2;
  else if (virtualAddr == 16'hbf03)
    index = SERIALPORT_STATE_2;
  else
    index = RAM;
end

always @ (*)
  case (index)
    RAM:
      realData = ramData;
    SERIALPORT_DATA_1:
      realData = {8'h00, serialPortData_1};
    SERIALPORT_STATE_1:
      realData = {14'b00000000000000, serialPortState_1};
	 SERIALPORT_DATA_2:
		realData = {8'h00, serialPortData_2};
	 SERIALPORT_STATE_2:
	   realData = {14'b00000000000000, serialPortState_2};
    default:
      realData = 0;
  endcase

endmodule
