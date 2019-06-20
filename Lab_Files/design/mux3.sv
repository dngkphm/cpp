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


module mux3
    #(parameter WIDTH = 32)
    (input logic [WIDTH-1:0] d0, d1, d2,
     input logic [1:0] s,
     output logic [WIDTH-1:0] y);

always_comb 
begin

	case(s)
	2'b00:
	begin
		y = d0;
	end

	2'b01:
	begin
		y = d1;
	end

	2'b10:
	begin
		y = d2;
	end

	endcase	

end
//assign y = s ? d1 : d0;

endmodule
