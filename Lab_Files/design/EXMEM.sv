
module EXMEM#(
	
	parameter PC_WIDTH = 9,
	parameter DATA_WIDTH = 32	 
   )
   (
   input clk, rst,
   input logic [1:0] wb,
   input logic [2:0] mem,
   input logic [PC_WIDTH-1:0] pcres,
   input logic zero,
   input logic [DATA_WIDTH-1:0] alures,
   input logic [DATA_WIDTH-1:0] src2,
   input logic [4:0] rd,
   input logic [3:0] funct,		//for sign extension
   output logic [1:0] wbout,
   output logic [2:0] memout,
   output logic [PC_WIDTH-1:0] pco,
   output logic zero_out,
   //branch inside datapath
   output logic [DATA_WIDTH-1:0] addr,
   output logic [DATA_WIDTH-1:0] wrt_data,
   output logic [4:0] rdout,
   output logic [3:0] functout
   );

   
reg [1:0] wb_reg;
reg [2:0] mem_reg;
reg zero_reg;
reg [DATA_WIDTH-1:0] alures_reg;
reg [DATA_WIDTH-1:0] src2_reg;
reg [4:0] rd_reg;
reg [3:0] funct_reg;
reg [PC_WIDTH-1:0] pc_reg;

always @ (posedge clk) begin
	
	if(rst==1'b1)
	begin
		wb_reg <= 0;
		mem_reg <= 0;
		zero_reg <= 0;
		alures_reg <= 0;
		src2_reg <= 0;
		pc_reg <= 0;
		rd_reg <= 0;
		funct_reg <= 0;
	end
	
	else 
	begin
		wb_reg <= wb;
		mem_reg <= mem;
		zero_reg <= zero;
		alures_reg <= alures;
		src2_reg <= src2;
		pc_reg <= pcres;
		rd_reg <= rd;
		funct_reg <= funct;
	end
end

always_comb begin

	wbout = wb_reg;
	memout = mem_reg;
	zero_out = zero_reg;
	addr = alures_reg;
	wrt_data = src2_reg;
	rdout = rd_reg;
	functout = funct_reg;
	pco = pc_reg;

end

endmodule
