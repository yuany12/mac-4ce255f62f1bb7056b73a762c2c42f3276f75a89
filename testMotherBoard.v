`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:47:23 12/02/2014
// Design Name:   motherBoard
// Module Name:   Z:/Documents/2014fall/co/naivecpu/testMotherBoard.v
// Project Name:  naivecpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: motherBoard
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testMotherBoard;

	// Inputs
	reg clk;
	reg rst;
	reg clkHand;
	reg clkUART;
	reg tbre;
	reg tsre;
	reg dataReady;

	// Outputs
	wire [17:0] memAddrBus;
	wire memRead;
	wire memWrite;
	wire memEnable;
	wire vgaHs;
	wire vgaVs;
	wire [2:0] vgaR;
	wire [2:0] vgaG;
	wire [2:0] vgaB;
	wire [15:0] leddebug;
	wire rdn;
	wire wrn;
	wire ram1Oe;
	wire ram1We;
	wire ram1En;

	// Bidirs
	reg [15:0] memDataBus;
	wire [7:0] ram1DataBus;

	// Instantiate the Unit Under Test (UUT)
	motherBoard uut (
		.clk(clk), 
		.rst(rst), 
		.clkHand(clkHand), 
		.clkUART(clkUART), 
		.memDataBus(memDataBus), 
		.memAddrBus(memAddrBus), 
		.memRead(memRead), 
		.memWrite(memWrite), 
		.memEnable(memEnable), 
		.vgaHs(vgaHs), 
		.vgaVs(vgaVs), 
		.vgaR(vgaR), 
		.vgaG(vgaG), 
		.vgaB(vgaB), 
		.leddebug(leddebug), 
		.tbre(tbre), 
		.tsre(tsre), 
		.dataReady(dataReady), 
		.ram1DataBus(ram1DataBus), 
		.rdn(rdn), 
		.wrn(wrn), 
		.ram1Oe(ram1Oe), 
		.ram1We(ram1We), 
		.ram1En(ram1En)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		clkHand = 0;
		clkUART = 0;
		tbre = 0;
		tsre = 0;
		dataReady = 0;
		
		memDataBus = 16'h1044;
		// Wait 100 ns for global reset to finish
		#100;
       
		rst = 1;
		// Add stimulus here

	end
	
	always
	begin
		#1 clk = !clk;
		#10 clkUART = !clkUART;
		#100 clkHand = !clkHand;
	end
		
endmodule

