`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: mux2
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


module jalrmux
    (input logic [8:0] PCaddout, 
     input logic [31:0]	ALUResult,
     input logic [4:0] s, //jumxin, ALUOP
     output logic [31:0] y);

always_comb
begin
	case(s)
		5'b10100:
			y = {23'b0, PCaddout};	//current address + offset
		5'b11110: //LUI
			y = 32'b0;
		5'b01110:
			y = {23'b0, PCaddout};
		default:
			y = ALUResult;
	endcase
end

endmodule
