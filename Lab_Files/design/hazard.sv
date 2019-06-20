`timescale 1ns / 1ps

module hazard #(
	parameter REG_WIDTH = 5	
 )
 (

	input logic [REG_WIDTH-1:0] rdout,
	input logic [REG_WIDTH-1:0] instr_rs1,
	input logic [REG_WIDTH-1:0] instr_rs2,
	input logic idex_memread,
	input logic idex_branch,
	input logic exmem_branch,
	output logic [8:0] pcwrite,
	output logic ifid_write, 
	output logic stallmux
);

always_comb
begin

	if (idex_memread)
	begin
		if (rdout == instr_rs1)
		begin
			ifid_write = 0;
			pcwrite = 9'b000000000;
			stallmux = 0;	
		end
		else if (rdout == instr_rs2)
		begin
			ifid_write = 0;
			pcwrite = 9'b000000000;
			stallmux = 0;	
		end
	end
	else	if (idex_branch)
	begin
		ifid_write = 0;
			pcwrite = 9'b000000000;
			stallmux = 0;	
	end
	else
	begin
			ifid_write = 1;
			pcwrite = 9'b000000100;
			stallmux = 1;	
			
	end
end

endmodule
