
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: brdriver
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


module brdriver
    (
     input logic Prealu,		//Zero from alu.sv
     input logic [31:0] aluout,
     input logic [3:0] Operation,
     input logic Branch,
     output logic [31:0] ALUResult);

always_comb
begin
	case(Branch)
		1'b1:
			case(Operation)
				
				//BEQ
				4'b0010:
					ALUResult = {31'b0, Prealu ? 1'b0: 1'b1};
				//BNE
				4'b1011:
					ALUResult = (Prealu ? $signed(Prealu)-2: 32'b0);
				//BLT
				4'b0011:
					ALUResult = {31'b0, Prealu ? 1'b1: 1'b0};
				//BGE
				4'b1100:
					ALUResult = {31'b0, Prealu ? 1'b1: 1'b0};
				//BGE
				4'b1101:
					ALUResult = {31'b0, Prealu ? 1'b1: 1'b0};
				//BLTU
				4'b0001:
					ALUResult = {31'b0, Prealu ? 1'b1: 1'b0};
				//BGEU
				4'b0111:
					ALUResult = {31'b0, Prealu ? 1'b1: 1'b0};
				default:
					ALUResult = aluout;
			endcase
		1'b0:
			ALUResult = aluout;	
	endcase
end

endmodule
