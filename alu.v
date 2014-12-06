module alu(
  input clk, rst,
  input[15:0] opXin, opYin,
  input[15:0] currentPCIn, instructionIn,
  output reg[15:0] res,
  output reg t_written, t
);

reg [15:0] currentPC, instruction, opX, opY;

wire[15:0] imm16 = {8'd0, instruction[7:0]};
wire[15:0] imm16s = { {8{instruction[7]}}, instruction[7:0]};
wire[15:0] imm16from4s = { {12{instruction[3]}}, instruction[3:0]};
wire[3:0] shift_imm4 = instruction[4:2] ? instruction[4:2] : 8;

always @ (negedge clk or negedge rst)
begin
  if (!rst)
  begin
    currentPC = 0;
	 instruction = 16'b0000100000000000; // nop
	 opX = 0;
	 opY = 0;
  end
  else
  begin
    currentPC = currentPCIn;
	 instruction = instructionIn;
	 opX = opXin;
	 opY = opYin;
  end
end

always @(posedge clk or negedge rst)
begin
  t_written = 1;
  t = 0;
  res = 0;
  if (!rst) // the negedge of rst
  begin
    t_written = 1;
    t = 0;
    res = 0;
  end
  else
  begin
    case (instruction[15:11])
      5'b00000:                         // addsp3
        res = opX + imm16s;
      5'b00110:                         // sll, srl, sra
        case (instruction[1:0])
          2'b00:   res = opX << shift_imm4;  // sll
          2'b10:   res = opX >> shift_imm4;  // srl
          2'b11:   res = opX >>> shift_imm4; // sra
        endcase
      5'b01000:                         // addiu3
        res = opX + imm16from4s;
      5'b01001:                         // addiu
        res = opX + imm16s;
      5'b01010:                         // slti
      begin
        t_written = 0;
        t = $signed(opX) < imm16s;
      end
      5'b01100:                         // addsp, bteqz, btnez, mtsp
        case (instruction[10:8])
          3'b011:                       // addsp
            res = opX + imm16s;
          3'b100:                       // mtsp
            res = opX;
        endcase
      5'b01101:                         // li
        res = imm16;
      5'b01111:                         // move
        res = opX;
      5'b11010:                         // sw_sp
        res = opX;
      5'b11011:                         // sw
        res = opX;
      5'b11100:                         // addu, subu
        case (instruction[1:0])
          2'b01:   res = opX + opY;           // addu
          2'b11:   res = opX - opY;           // subu
        endcase
      5'b11101:                         //  jr, mfpc, srav, srlv, cmp, and, or
        case (instruction[4:0])
          5'b00000:                     // jr, mfpc
            case (instruction[7:5])
              //3'b000:                   // jr
              3'b010:                   // mfpc
                res = currentPC;
            endcase
          5'b00010:                     // slt
          begin
            t_written = 0;
            t = $signed(opX) < $signed(opY);
          end
          5'b00110:                     // srlv
            res = opX >> opY;
          5'b00111:                     // srav
            res = opX >>> opY;
          5'b01010:                     // cmp
          begin
            t_written = 0;
            t = opX != opY;
          end
          5'b01100:                     // and
            res = opX & opY;
          5'b01101:                     // or
            res = opX | opY;
        endcase
      5'b11110:                         // mfih, mtih
        case (instruction[0])
          1'b0:                         // mfih
            res = opX;
          1'b1:                         // mtih
            res = opX;
        endcase
    endcase
  end
end

endmodule
