`timescale 1ns / 1ps

module FFU #(
	parameter REG_WIDTH = 5	
 )
 (

	input logic [REG_WIDTH-1:0] rdout2,
	input logic [REG_WIDTH-1:0] rdout3,
	input logic [REG_WIDTH-1:0] idex_rs1,
	input logic [REG_WIDTH-1:0] idex_rs2,
	input logic [1:0] exmem_wb,
	input logic [1:0] memwb_wb,
	output logic [1:0] ffa,
	output logic [1:0] ffb 
);
	

always_comb
begin

	ffa = 2'b0;
	ffb = 2'b0;

		
	/*MEM HAZARD*/
	if(memwb_wb[0]) 
	begin
		if(rdout3 != 5'b0)
		begin
			if (rdout3 == idex_rs1)
				ffa = 2'b01;
			if (rdout3 == idex_rs2)
				ffb = 2'b01;
		end
	end

	/*EX HAZARD*/ 
	if(exmem_wb[0])
	begin
		if(rdout2 != 5'b0)
		begin
			if (rdout2 == idex_rs1)
				ffa = 2'b10;
			if (rdout2 == idex_rs2)
				ffb = 2'b10;
		end
	end

	//ORDER MATTERS

end

endmodule
