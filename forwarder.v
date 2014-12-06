<<<<<<< HEAD
module forwarder (
  input clk, rst,
  input [15:0] inWord,
  output reg [15:0] outWord
);

reg [15:0] temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 0;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 0;
  else
    outWord = temp;

endmodule

module forwarder2bit (
  input clk, rst,
  input [1:0] inWord,
  output reg [1:0] outWord
);

reg [1:0] temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 0;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 0;
  else
    outWord = temp;

endmodule

module forwarder4bit (
  input clk, rst,
  input [3:0] inWord,
  output reg [3:0] outWord
);

reg [3:0] temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 0;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 0;
  else
    outWord = temp;

endmodule

module forwarder1bit (
  input clk, rst,
  input inWord,
  output reg outWord
);

reg temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 1;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 1;
  else
    outWord = temp;

endmodule
=======
module flipflop (
	clk, rst,
	in, out
);
parameter width = 1;
input clk;
input rst;
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

>>>>>>> 4c73a4a27c17f9e1732ec14b0fdd4ad8673bece9
