/*This the the pipeline register between the fetch and decode stages*/

module IFID#(
	
	parameter PC_WIDTH = 9,
	parameter DATA_WIDTH = 32	 
   )
   (
   input clk, rst,
   input logic enable,
   input logic [DATA_WIDTH-1:0] instri,
   input logic [PC_WIDTH-1:0] pci,
   output logic [PC_WIDTH-1:0] pco,
   output logic [DATA_WIDTH-1:0] instro
   );

//input... write enable for hazard detection
   
reg [DATA_WIDTH-1:0] instr_reg;
reg [PC_WIDTH-1:0] pc_reg;

always @ (posedge clk) begin

	if(rst==1'b1)
	begin
		pc_reg <= 0;		
		instr_reg <= 0;
	end 

	if (enable == 1)
	begin
		instr_reg <= instri;
		pc_reg <= pci;
	end
	else
	begin
		instr_reg <= 0;
		pc_reg <= 0;
	end
end

always_comb begin

	if (enable == 1)
	begin
		instro = instr_reg;
		pco = pc_reg;
	end
end

endmodule
