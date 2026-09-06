"""
RV32I Assembler for : ADDI, ADD, SW, LW, BEQ, BNE, JAL, JALR
"""

import sys

def reg_to_num(token):

    """
    Converts register "x5" into index 5
    Raises Error if token is out of range (0-31) or broken
    """

    clean_token = token.strip()
    if clean_token[0] != 'x':
        raise ValueError(f"expected register like 'x5', got '{token}'")
    else:
        int_token = int(clean_token[1:])
        if (int_token > 31) or (int_token < 0):
            raise ValueError(f"register out of range (0-31): '{token}'")

        return int_token 
def to_unsigned(value, width):
    """
    Convert signed int into unsigned two's complement
    """
    mask = (value & ((1 << width) - 1))
    return mask



def bits(value, width):

    """
    Converts non-negative int to zero-padded binary string of "width" bits.
    """
    padded_bits = f"{value:0{width}b}"
    return padded_bits

def r_type(funct7, rs2, rs1, funct3, rd, opcode):
    """
    Builds 32-bit R-type instruction string
    """
    instruction = f"{bits(funct7,7)}{bits(rs2,5)}{bits(rs1,5)}{bits(funct3,3)}{bits(rd,5)}{bits(opcode,7)}"
    assert len(instruction) == 32, f"expected 32 bits, but got {len(instruction)}"
    return instruction

def i_type(imm, rs1, funct3, rd, opcode):
    """
    Builds 32-bit I-type instruction string
    """
    instruction = f"{bits(to_unsigned(imm,12),12)}{bits(rs1,5)}{bits(funct3,3)}{bits(rd,5)}{bits(opcode,7)}"
    assert len(instruction) == 32, f"expected 32 bits, but got {len(instruction)}"
    return instruction

if __name__ == "__main__":
    r1 = i_type(5, 0, 0b000, 1, 0b0010011)
    print(r1, f"{int(r1, 2):08X}")   # expect 00500093

    r2 = i_type(-1, 0, 0b000, 2, 0b0010011)
    print(r2, f"{int(r2, 2):08X}")   # expect FFF00113
    
    

