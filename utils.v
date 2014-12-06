module flipflop (clk, rst, in, out);
parameter width = 1;
input clk, rst;
input [width-1:0] in;
output reg [width-1:0] out;
reg [width-1:0] buffer;

always @ (negedge clk or negedge rst)
  if (!rst)
    buffer = 0;
  else
    buffer = in;

always @ (posedge clk or negedge rst)
  if (!rst)
    out = 0;
  else
    out = buffer;
endmodule

module muxCombine (chooseA, opA, opB, out);
parameter width = 16;
input chooseA;
input [width-1:0] opA, opB;
output [width-1:0] out;
assign out = chooseA? opA : opB;
endmodule

module mux_B_buffered (clk, rst, chooseA, opA, opB, result);
parameter width = 16;
input clk, rst, chooseA;
input [width-1:0] opA, opB;
output [width-1:0] result;
reg [width:0] opBbuffer;

always @ (negedge clk or negedge rst)
  if (!rst)
    opBbuffer = 0;
  else
    opBbuffer = opB;

assign result = chooseA? opA : opBbuffer;
endmodule

module byPass (
  input [3:0] sourceIndex,
  input [15:0] sourceValue,
  input [3:0] updateIndex,
  input [15:0] updateValue,
  output [15:0] selectedValue
);

assign selectedValue = updateIndex == sourceIndex? updateValue : sourceValue;

endmodule