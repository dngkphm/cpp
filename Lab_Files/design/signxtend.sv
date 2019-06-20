
`timescale 1ns / 1ps

module signxtend( //only for readdata (load instructions)
    input logic [31:0] data,
    //input logic control,
    input logic [2:0] Funct3, 
    output logic [31:0] out);

always_comb
/*    case(control)
	1'b1:
	begin	
		case(Funct3)
			3'b000:		//SB
			out = {24'b0, data[7:0]};
			3'b001:		//SH
			out = {16'b0, data[15:0]};
			default:
				out = data;
		endcase
	end

	2'b10:
*/	begin
		case(Funct3)
			3'b000:		//LB
			out = $signed(data[7:0]);
			3'b001:		//LH
			out = $signed(data[15:0]);
			3'b100:		//LBU
			out = {24'b0, data[7:0]};
			3'b101:		//LHU
			out = {16'b0, data[15:0]};
			default:
				out = data;
		endcase
        end
/*	default:
		out = data;
    endcase
*/    
endmodule
