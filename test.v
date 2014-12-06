
module test;

	// Inputs
	reg clk;
	reg rst;
	reg [15:0] AmemRead;
	reg [15:0] BmemRead;

	// Outputs
	wire [15:0] MeAaddr;
	wire [15:0] Baddr;
	wire [15:0] ExCalResult;
	wire [15:0] MeMemResult;
	wire [1:0] MeMemControl;
	wire [175:0] registerValue;
	wire [15:0] nextPC;
	wire [15:0] IfIR;
	wire [3:0] registerS;
	wire [3:0] registerM;
	wire [3:0] IdRegisterT;
	wire [3:0] MeRegisterT;
	wire [15:0] MeCalResult;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.clk(clk), 
		.rst(rst), 
		.MeAaddr(MeAaddr), 
		.Baddr(Baddr), 
		.ExCalResult(ExCalResult), 
		.MeMemResult(MeMemResult), 
		.MeMemControl(MeMemControl), 
		.AmemRead(AmemRead), 
		.BmemRead(BmemRead), 
		.registerValue(registerValue), 
		.nextPC(nextPC), 
		.IfIR(IfIR), 
		.registerS(registerS), 
		.registerM(registerM), 
		.IdRegisterT(IdRegisterT), 
		.MeRegisterT(MeRegisterT), 
		.MeCalResult(MeCalResult)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		AmemRead = 0;
		BmemRead = 16'h0000;

		// Wait 100 ns for global reset to finish
		#100;
		
		rst = 1;
		
		#1;
		BmemRead = 16'h0000;
		#1;
		BmemRead = 16'h0800;
		#1;
		BmemRead = 16'h1044;
		// Add stimulus here

	end
   
	always
		#1 clk = !clk;
endmodule

