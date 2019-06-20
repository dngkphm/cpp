`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:23:43 PM
// Design Name: 
// Module Name: alu
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


module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )(
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic Zero,
	output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            //ALUResult = 'd0;
            case(Operation)
            4'b1111:        //AND, ANDI (moved BGEU to SLT due to stalls)
			begin
					ALUResult = SrcA & SrcB;
					Zero = 1'b0;
			end
            4'b0001:        //OR, ORI		BLTU
		begin
                    ALUResult = SrcA | SrcB;
                    Zero = (((SrcB - SrcA) > 32'b0)? 1'b1:1'b0);	
	    	end

            4'b0010:        //ADD, ADDI, SW, LW, SH, SB, LH, LB 	BEQ
		begin
                    ALUResult = SrcA + SrcB;
                    Zero = ((($signed(SrcA) - $signed(SrcB)) == 32'b0)? 1'b1:1'b0);	
	    	end

	    4'b0011:        //XOR, XORI		BLT
		begin
	            ALUResult=SrcA^SrcB;
                    Zero = ((($signed(SrcB) - $signed(SrcA)) > 32'b0)? 1'b1:1'b0);	
	    	end

	    4'b0100:	    //JAL
		begin
		    ALUResult = SrcA + 4;
                    Zero = 1'b1;	
		end
	    4'b0101:	    //JALR  AUIPC adds lower 9 bits PC(SrcA) + upper 20b imm(SrcB)
		begin
		    ALUResult = SrcA + SrcB;
		    Zero = 1'b1; //branch flag disabled for AUIPC
		end
            4'b0110:        //Subtract		BEQ
		begin
                    ALUResult = $signed(SrcA) - $signed(SrcB); 
                    Zero = ((($signed(SrcA) - $signed(SrcB)) == 32'b0)? 1'b1:1'b0);	
	    	end

	    4'b0111:        //SLT SLTI BGEU				
		begin
                    ALUResult = (($signed(SrcA) < $signed(SrcB)) ? {31'b0,1'b1}:32'b0);
                    Zero = (((SrcA - SrcB) >= 32'b0)? 1'b1:1'b0);	
		end
	    4'b1000:	    //SLTU SLTIU
                    ALUResult = ((SrcA < SrcB) ? {31'b0,1'b1}:32'b0);
                    //Zero = ((($signed(SrcA) - $signed(SrcB)) < 32'b0)? 1'b1:1'b0);	
	    4'b1011:	    //SLL SLLI		BNE
		begin
		    ALUResult = SrcA << SrcB[4:0];
                    Zero = ((($signed(SrcA) - $signed(SrcB)) != 32'b0)? 1'b1:1'b0);
	    	end

	    4'b1100:	    //SRL SRLI		BGE
		begin
		    ALUResult = SrcA >> SrcB[4:0];
                    Zero = ((($signed(SrcA) - $signed(SrcB)) >= 32'b0)? 1'b1:1'b0);
	    	end

	    4'b1101: 	    //SRA SRAI		BGE
		begin
		    ALUResult = $signed(SrcA) >>> SrcB[4:0];
                    Zero = ((($signed(SrcA) - $signed(SrcB)) >= 32'b0)? 1'b1:1'b0);
	    	end

	    4'b1110:	    //AUIPC/LUI 				32bit
		begin
		    ALUResult = SrcA + SrcB;
			Zero = 1'b0;
		end
		4'b0000: //No OP
		begin
			ALUResult = 32'b0;
			Zero = 1'b0;
		end
		
		
		/*
		Operations left: LW/B,BU/H,HU. SW/B/H
		permutations: 1001,1010
		*/

            default:
		begin
                    ALUResult = 32'b0;
		    Zero = 0;
		end
            endcase
        end
endmodule

