`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;

logic [2:0] ALUop;
logic [3:0] idex_op;
//logic [6:0] Funct7;
logic Funct7;
logic [2:0] Funct3;
logic [1:0] signextend;
logic [3:0] Operation;

    Controller c(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop);
    
    ALUController ac(idex_op[2:0], Funct7, Funct3, /*signextend,*/ Operation);

    Datapath dp(clk, reset, RegWrite, MemtoReg, ALUSrc , MemWrite, MemRead, Branch, /*signextend,*/ Operation, ALUop, idex_op, opcode, Funct7, Funct3, WB_Data);
        
endmodule
