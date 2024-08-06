module riscv_core_mul_in
#(
  parameter XLEN = 64
)
( 
  input   logic [XLEN-1:0] i_mul_in_srcA,
  input   logic [XLEN-1:0] i_mul_in_srcB,
  input   logic [1:0]      i_mul_in_control,
  input   logic            i_mul_in_isword,
  output  logic [XLEN:0] o_mul_in_multiplicand,
  output  logic [XLEN:0] o_mul_in_multiplier
);


localparam [1:0] MUL    = 2'b00;        //XLEN-bit x XLEN-bit multiplication of signed rs1 by signed rs2 and places the *lower* XLEN bits in the destination register.
localparam [1:0] MULH   = 2'b01;        //XLEN-bit x XLEN-bit multiplication of signed rs1 by signed rs2 and places the *upper* XLEN bits in the destination register.
localparam [1:0] MULHSU = 2'b10;        //XLEN-bit x XLEN-bit multiplication of *signed* rs1 by *unsigned* rs2 and places the *upper* XLEN bits in the destination register.
localparam [1:0] MULHU  = 2'b11;        //XLEN-bit x XLEN-bit multiplication of *unsigned* rs1 by *unsigned* rs2 and places the *upper* XLEN bits in the destination register.
localparam [1:0] MULW   = 2'b00;        //multiplies the lower 32 bits of the source registers, placing the sign-extension of the lower 32 bits of the result into the destination register.


always_comb
  begin: instr_proc
    if (!i_mul_in_isword) 
      begin
        case (i_mul_in_control)
          MUL:
            begin
              o_mul_in_multiplicand = {i_mul_in_srcA[XLEN-1], i_mul_in_srcA};
              o_mul_in_multiplier = {i_mul_in_srcB[XLEN-1], i_mul_in_srcB};
            end
          MULH:
            begin
              o_mul_in_multiplicand = {i_mul_in_srcA[XLEN-1], i_mul_in_srcA};
              o_mul_in_multiplier = {i_mul_in_srcB[XLEN-1], i_mul_in_srcB};
            end
          MULHSU:
            begin
              o_mul_in_multiplicand = {i_mul_in_srcA[XLEN-1], i_mul_in_srcA};
              o_mul_in_multiplier = {1'b0, i_mul_in_srcB};
            end
          MULHU:
            begin
              o_mul_in_multiplicand = {1'b0, i_mul_in_srcA};
              o_mul_in_multiplier = {1'b0, i_mul_in_srcB};
            end
          default:
            begin
              o_mul_in_multiplicand = {i_mul_in_srcA[XLEN-1], i_mul_in_srcA};
              o_mul_in_multiplier = {i_mul_in_srcB[XLEN-1], i_mul_in_srcB};
            end
        endcase
      end
    else
      begin
        case (i_mul_in_control)
          MULW:
            begin
              o_mul_in_multiplicand = i_mul_in_srcA[XLEN/2-1:0];
              o_mul_in_multiplier = i_mul_in_srcB[XLEN/2-1:0];
            end
          default:
            begin
              o_mul_in_multiplicand = i_mul_in_srcA[XLEN/2-1:0];
              o_mul_in_multiplier = i_mul_in_srcB[XLEN/2-1:0];
            end
        endcase
      end
  end
endmodule