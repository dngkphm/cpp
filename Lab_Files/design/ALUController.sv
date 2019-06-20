`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Inputs
    input logic [2:0] ALUOp,  //7-bit opcode field from the instruction
    //input logic [6:0] Funct7, // bits 25 to 31 of the instruction
	input logic  Funct7, // bit 30 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    
    //Output
    //output logic [1:0] signextend,
    output logic [3:0] Operation //operation selection for ALU
);

	logic [3:0] in;
	/*
	100 BR
	111 JALR
	110 JAL
	101 UIPC/LUI
	010 RTypeI
	000 RType
	011 LW
	001 SW
	*/
	
	assign in = {Funct7,Funct3};
	//assign in = {Funct7[5], Funct3, ALUOp};

        always_comb
        begin
			case(ALUOp)
			
			3'b000:		//RType
			begin
				case(in)
				4'b0000://ADD
					Operation = 4'b0010;
				4'b1000://SUB
					Operation = 4'b0110;
				4'b0001://SLL
					Operation = 4'b1011;
				4'b0010://SLT
					Operation = 4'b0111;
				4'b0011://SLTU
					Operation = 4'b1000;
				4'b0100://XOR
					Operation = 4'b0011;
				4'b0101://SRL
					Operation = 4'b1100;
				4'b1101://SRA
					Operation = 4'b1101;
				4'b0110://OR
					Operation = 4'b0001;
				4'b0111://AND
					Operation = 4'b1111;
				//default:
					//signextend = 2'b00;
				endcase
			end
			
			3'b010:		//RTypeI
			begin
				//signextend = 2'b00;
				case(in)
				4'b0000://ADDI
					Operation = 4'b0010;
				4'b1000://ADDI
					Operation = 4'b0010;
				4'b0001://SLLI
					Operation = 4'b1011;
				4'b0010://SLTI
					Operation = 4'b0111;
				4'b1010://SLTI
					Operation = 4'b0111;
				4'b0011://SLTIU
					Operation = 4'b1000;
				4'b1011://SLTIU
					Operation = 4'b1000;
				4'b0100://XORI
					Operation = 4'b0011;
				4'b1100://XORI
					Operation = 4'b0011;
				4'b0101://SRL
					Operation = 4'b1100;
				4'b1101://SRAI
					Operation = 4'b1101;
				4'b0110://ORI
					Operation = 4'b0001;
				4'b1110://ORI
					Operation = 4'b0001;
				4'b0111://ANDI
					Operation = 4'b1111;
				4'b1111://ANDI
					Operation = 4'b1111;	
				endcase
			end
			3'b011:		//LW
			begin
				Operation = 4'b0010;
				//signextend = 2'b10;
			end
			3'b001:		//SW
			begin
				Operation = 4'b0010;
				//signextend = 2'b01;
			end


			3'b100:		//BR
			begin
				case(Funct3)
				3'b000://BEQ -> ADD
					Operation = 4'b0010;
				3'b001://BNE -> SLL
					Operation = 4'b1011;
				3'b100://BLT -> XOR
					Operation = 4'b0011;
				3'b101://BGE -> SRL
					Operation = 4'b1100;
				3'b110://BLTU -> OR
					Operation = 4'b0001;
				3'b111://BGEU -> SLT(I)
					Operation = 4'b0111;
				endcase
			end
			3'b101:		//LUI AUIPC
			begin
				Operation = 4'b1110;
			end
			3'b110:		//JAL
			begin
				Operation = 4'b0100;
			end
			3'b111:		//JALR 
			begin
				Operation = 4'b0101;
			end
            default:
				begin
					Operation = 4'b0000;
					//Zero = 1'b1;
					//signextend = 2'b00;
				end
            endcase
        end
endmodule
