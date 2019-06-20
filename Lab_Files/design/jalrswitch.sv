
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


module jalrswitch
    (
     input logic [8:0] pcm,		
     input logic [31:0] alur,
     input logic [3:0] Operation,
     output logic [31:0] alur_out,		
     output logic [8:0] pcm_out
    );
always_comb
begin
	case(Operation)
		4'b0101:
		begin
			pcm_out = alur[8:0];
			alur_out = {23'b0, pcm};
		end
/*
		4'b0100:
		begin
			pcm_out = alur[8:0];
			alur_out = {23'b0, pcm};
		end
*/						
		default:
		begin
			pcm_out = pcm;
			alur_out = alur;
		end
	endcase
end

endmodule
