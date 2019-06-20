`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead ,                 // Memroy Reading Enable
    Branch ,
//    input logic [1:0] signextend,	//From ALUController
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    input logic [2:0] ALUop,
    output logic [3:0] idex_ex,		//WHERE DOES THIS COME FROM?
    output logic [6:0] opcode,
    output logic       Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data //ALU_Result
    );

logic [PC_W-1:0] PC, PCPlus4, PCAddOut, pcm, pcm_tojs, pcwrite,pco, pco2, pcimm ; //PCjmux; //PCAddOut (wire) connects PCadder result to PC and RegData
logic [8:0] control;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] PCresult, pcinstr;
logic [DATA_W-1:0] Reg1, Reg2, src1, src2, TwotoB, srcA, srcA_out, SrcB, cut;
logic [DATA_W-1:0] ReadData, ext, resmux0, resmux1;
logic [DATA_W-1:0] alur, alur_tojs, ALUResult, brdin;
logic [DATA_W-1:0] ExtImm, immout;
logic [RF_ADDRESS-1:0] rdout, rdout2, rdout3, idex_rs1, idex_rs2;
logic [3:0] idex_funct,exmem_funct;
logic [2:0] idex_mem,exmem_mem;
logic [1:0] idex_wb, exmem_wb, mw_wb, ffa, ffb;

logic andout, ifid_enbl, stallmux, jmux_in;
logic Zero, alures_zero;
// next PC
    adder #(9) pcadd (PC, pcwrite, PCPlus4); //change PCPlus4 to pcmux
    flopr #(9) pcreg(clk, reset, PCAddOut, PC); //change PCPlus4 to PCAddOut
    /*NEW*/
    adder #(9) pcaddImm(pco2,ExtImm[8:0], pcm_tojs); //takes PC+Imm into pcmux
//    mux2 #(9) pcmux(PCPlus4, pcimm, andout, PCAddOut);
    mux2 #(9) pcmux(PCPlus4, pcm, andout, PCAddOut);

//JALR pcmux


 //Instruction memory
    instructionmemory instr_mem (PC, pcinstr);
    
    assign opcode = Instr[6:0];
//    assign Funct7 = Instr[31:25];
//    assign Funct3 = Instr[14:12];

// //Register File
    //RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20], Result, Reg1, Reg2);
    RegFile rf(clk, reset, mw_wb[0], rdout3, Instr[19:15], Instr[24:20],
            PCresult, Reg1, Reg2);

// Pipeline Registers
   IFID fetch (clk, reset, ifid_enbl, pcinstr, PC, pco, Instr); 
   IDEX exe (clk, reset, control[1:0], control[4:2], control[8:5],pco, Reg1, Reg2, Instr[19:15], Instr[24:20], immout, Instr[11:7], {Instr[30],Instr[14:12]}, Instr[5],
	pco2, idex_wb, idex_mem, idex_ex, src1, src2, idex_rs1, idex_rs2, ExtImm, rdout, idex_funct, jmux_in);		//idex_funct not defined in IDEX.sv
   //{MemtoReg, RegWrite}, {MemWrite, MemRead, Branch}, {ALUsrc, ALUop}, 
    assign Funct7 = idex_funct[3];
    assign Funct3 = idex_funct[2:0];      
   EXMEM mem (clk, reset, idex_wb, idex_mem, pcm, Zero, alur, src2, rdout, idex_funct, exmem_wb, exmem_mem, pcimm, alures_zero, ALUResult, cut, rdout2,
	exmem_funct);
   MEMWB #(32) wb (clk, reset, ext, ALUResult, exmem_wb, rdout2, rdout3, resmux1, resmux0, mw_wb);

   FFU #(5) fwdunit (rdout2, rdout3, idex_rs1, idex_rs2, exmem_wb, mw_wb, ffa, ffb); 
   //mux3 src1_mux(src1, ALUResult, PCresult, ffa, srcA);
   mux3 src1_mux(src1, PCresult, ALUResult, ffa, srcA);
   //mux3 src2_mux(src2, ALUResult, PCresult, ffb, TwotoB);
   mux3 src2_mux(src2, PCresult, ALUResult, ffb, TwotoB);

   hazard hzdunit (rdout, Instr[19:15], Instr[24:20], idex_mem[1], idex_mem[0], exmem_mem[0],pcwrite, ifid_enbl, stallmux);	//exmem_mem[0]?, ifid_write -> ifid_enbl?
   mux2 #(9) conmux(9'b0, {ALUsrc,ALUop,MemWrite, MemRead, Branch,MemtoReg, RegWrite}, stallmux, control);   

//Halfword n Byte extenders
    //signxtend storex (Reg2, signextend, Funct3, cut); 
    signxtend loadx (ReadData, exmem_funct[2:0], ext);            

    mux2 #(32) resmux(resmux0, resmux1, mw_wb[1], PCresult); //change Result to PCresult
           
//// sign extend
    imm_Gen Ext_Imm (Instr, immout);

//// ALU
    mux2 #(32) srcbmux(TwotoB, ExtImm, idex_ex[3], SrcB);
    /*NEW*/
    jalrmux jmux (pco2, srcA,{jmux_in,ALU_CC}, srcA_out);
    alu alu_module(srcA_out, SrcB, ALU_CC, Zero, brdin);
    //andgate andg(exmem_mem[0], alures_zero, andout);
    jalrswitch js(pcm_tojs, alur_tojs, ALU_CC,alur, pcm); 
    andgate andg(idex_mem[0], Zero, andout);
//Branch output driver

    brdriver brd (Zero, brdin, ALU_CC, idex_mem[0], alur_tojs);

// JALR AUIPC mux
    //ext23 #(9) pcaoext (PCPlus4, extpcout);
    //mux2 #(32) umux (ext, extpcout, Branch, umuxout);

    assign WB_Data = PCresult;
    
////// Data memory 
	datamemory data_mem (clk, exmem_mem[1], exmem_mem[2], ALUResult[DM_ADDRESS-1:0], cut, ReadData);
endmodule
