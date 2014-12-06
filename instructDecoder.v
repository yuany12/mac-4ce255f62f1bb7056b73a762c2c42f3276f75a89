module instructionDecoder (
  input clk, rst,
  input [15:0] instruction,
  output reg [3:0] id_registerX, id_registerY, id_registerZ,
  output reg [2:0] jumpControl
);

localparam  IDLE = 3'b000,
  EQZ = 3'b001,
  NEZ = 3'b010,
  TEQZ = 3'b011,
  TNEZ = 3'b100,
  JUMP = 3'b101,
  DB = 3'b110;

reg [15:0] instructionBuffer;

always @ (negedge clk or negedge rst)
  if (!rst)
    instructionBuffer = 16'b0000100000000000; // nop
  else
    instructionBuffer = instruction;

always @ (posedge clk or negedge rst)
begin
  id_registerX = 0;
  id_registerY = 0;
  id_registerZ = 4'hf;
  jumpControl = 0;
  if (!rst) // the negedge of rst
  begin
    id_registerX = 0;
    id_registerY = 0;
    id_registerZ = 4'hf;
    jumpControl = 0;
  end
  else
  begin
    case (instructionBuffer[15:11])
      5'b00000:                         // addsp3
      begin
        id_registerX = 4'b1001;            // sp
        id_registerZ = instructionBuffer[10:8];
      end
      5'b00010:                         // b
        jumpControl = DB;
      5'b00100:                         // beqz
      begin
        id_registerX = instructionBuffer[10:8];
        jumpControl = EQZ;
      end
      5'b00101:                         // bnez
      begin
        id_registerX = instructionBuffer[10:8];
        jumpControl = NEZ;
      end
      5'b00110:                         // sll, srl, sra
      begin
        id_registerX = instructionBuffer[7:5];
        id_registerZ = instructionBuffer[10:8];
      end
      5'b01000:                         // addiu3
      begin
        id_registerX = instructionBuffer[10:8];
        id_registerZ = instructionBuffer[7:5];
      end
      5'b01001:                         // addiu
      begin
        id_registerX = instructionBuffer[10:8];
        id_registerZ = instructionBuffer[10:8];
      end
      5'b01010:                         // slti
        id_registerX = instructionBuffer[10:8];
      5'b01100:                         // addsp, bteqz, btnez, mtsp
        case (instructionBuffer[10:8])
          3'b000:                       // bteqz
            jumpControl = TEQZ;
          3'b001:                       // btnez
            jumpControl = TNEZ;
          3'b011:                       // addsp
          begin
            id_registerX = 4'b1001;        // sp
            id_registerZ = 4'b1001;        // sp
          end
          3'b100:                       // mtsp
          begin
            id_registerX = instructionBuffer[7:5];
            id_registerZ = 4'b1001;        // sp
          end
        endcase
      5'b01101:                         // li
        id_registerZ = instructionBuffer[10:8];
      5'b01111:                         // move
      begin
        id_registerX = instructionBuffer[7:5];
        id_registerZ = instructionBuffer[10:8];
      end
      5'b10010:                         // lw_sp
      begin
        id_registerY = 4'b1001;            // sp
        id_registerZ = instructionBuffer[10:8];
      end
      5'b10011:                         // lw
      begin
        id_registerY = instructionBuffer[10:8];
        id_registerZ = instructionBuffer[7:5];
      end
      5'b11010:                         // sw_sp
      begin
        id_registerX = instructionBuffer[10:8];
        id_registerY = 4'b1001;            // sp
      end
      5'b11011:                         // sw
      begin
        id_registerX = instructionBuffer[7:5];
        id_registerY = instructionBuffer[10:8];
      end
      5'b11100:                         // addu, subu
      begin
        id_registerX = instructionBuffer[10:8];
        id_registerY = instructionBuffer[7:5];
        id_registerZ = instructionBuffer[4:2];
      end
      5'b11101:                         // jr, mfpc, srav, srlv, cmp, neg, and, or, xor, not
        case (instructionBuffer[4:0])
          5'b00000:                     // jalr, jr, jrra, mfpc
            case (instructionBuffer[7:5])
              3'b000:                   // jr
              begin
                id_registerX = instructionBuffer[10:8];
                jumpControl = JUMP;
              end
              3'b010:                   // mfpc
                id_registerZ = instructionBuffer[10:8];
            endcase
          5'b00110:                     // srlv
          begin
            id_registerX = instructionBuffer[7:5];
            id_registerY = instructionBuffer[10:8];
            id_registerZ = instructionBuffer[7:5];
          end
          5'b00111:                     // srav
          begin
            id_registerX = instructionBuffer[7:5];
            id_registerY = instructionBuffer[10:8];
            id_registerZ = instructionBuffer[7:5];
          end
          5'b01010:                     // cmp
          begin
            id_registerX = instructionBuffer[7:5];
            id_registerY = instructionBuffer[10:8];
          end
          5'b01100:                     // and
          begin
            id_registerX = instructionBuffer[7:5];
            id_registerY = instructionBuffer[10:8];
            id_registerZ = instructionBuffer[10:8];
          end
          5'b01101:                     // or
          begin
            id_registerX = instructionBuffer[7:5];
            id_registerY = instructionBuffer[10:8];
            id_registerZ = instructionBuffer[10:8];
          end
        endcase
      5'b11110:                         // mfih, mtih
        case (instructionBuffer[0])
          1'b0:                         // mfih
          begin
            id_registerX = 4'b1000;        // ih
            id_registerZ = instructionBuffer[10:8];
          end
          1'b1:                         // mtih
          begin
            id_registerX = instructionBuffer[10:8];
            id_registerZ = 4'b1000;        // ih
          end
        endcase
      default:
      begin
        id_registerX = 0;
        id_registerY = 0;
        id_registerZ = 4'hF;
        jumpControl = 0;
      end
    endcase
  end
end

endmodule

