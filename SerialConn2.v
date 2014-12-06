module serialConn2(
  input clk, rst,              // clk & rst
//  input tbre, tsre, dataReady,    // wires linked with CPLD
  input [1:0] mode,
  input [2:0] index,
  input [7:0] dataToSend,    // toggle switches controlling data to send to serial port
//  input [7:0] uart2serial,       // bus
//  output [7:0] serial2uart,
//  output reg rdn, wrn,
//  output ram1Oe, ram1We, ram1En,
  output reg [7:0] data,
  output [3:0] status,
  input u_txd,
  output u_rxd
);

localparam MODE_WRITE = 2'b01;
localparam MODE_READ = 2'b10;
localparam IDLE = 2'b00,
  READ = 2'b10,
  WRITE = 2'b01,
  READ_IDLE = 2'b11;

wire [7:0] serial2uart;
wire [7:0] uart2serial;
wire tbre, tsre, dataReady,  ram1Oe, ram1We, ram1En;
wire parity_error, framing_error;
reg rdn, wrn;

wire busWritten;

assign status = {dataReady, tbre & tsre};

assign busWritten = (mode == MODE_WRITE);
//assign ram1Data = busWritten ? dataToSend : 8'bzzzzzzzz;
assign serial2uart = dataToSend;
always @ (*) 
begin
	data = uart2serial;
end
assign ram1Oe = 1;
assign ram1We = 1;
assign ram1En = 1;

uart2 Uart2(
.RST(rst),
.CLK(clk),
.rxd(u_txd),
.rdn(rdn),
.wrn(wrn),
.data_in(serial2uart),
.data_out(uart2serial),
.data_ready(dataReady),
.parity_error(parity_error),
.framing_error(framing_error),
.tbre(tbre),
.tsre(tsre),
.sdo(u_rxd)
);

always @(*) begin
  rdn = 1;
  wrn = 1;
  if (!rst)
  begin
	 rdn = 1;
	 wrn = 1;
  end
  else
  begin
    if (clk) // posedge
	 if (index == 3'b110 && mode == MODE_WRITE)
		wrn = 0;
    else if (index == 3'b110 && mode == MODE_READ)
	 begin
      rdn = 0;
      //data <= ram1Data;
	end
	end
end



endmodule
