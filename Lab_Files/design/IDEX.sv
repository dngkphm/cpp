

module IDEX#(
	
	parameter PC_WIDTH = 9,
	parameter DATA_WIDTH = 32	 
   )
   (
   input clk, rst,
   input logic [1:0] wb,
   input logic [2:0] mem,
   input logic [3:0] ex,
   input logic [PC_WIDTH-1:0] pci,
   input logic [DATA_WIDTH-1:0] rd1,
   input logic [DATA_WIDTH-1:0] rd2,
   input logic [4:0] ifid_rs1,
   input logic [4:0] ifid_rs2,
   input logic [DATA_WIDTH-1:0] immgen, 
   input logic [4:0] rd,
   input logic [3:0] funct,
   input logic aui,
   output logic [PC_WIDTH-1:0] pco,
   output logic [1:0] wbout,
   output logic [2:0] memout,
   output logic [3:0] exout,
   output logic [DATA_WIDTH-1:0] src1,
   output logic [DATA_WIDTH-1:0] src2,
   output logic [4:0] idex_rs1,
   output logic [4:0] idex_rs2,
   output logic [DATA_WIDTH-1:0] immout, 
   output logic [4:0] rdout,
   output logic [3:0] aluin,
   output logic ipc
   );

reg [4:0] rs1_reg;
reg [4:0] rs2_reg;
reg [1:0] wb_reg;
reg [2:0] mem_reg;
reg [4:0] ex_reg;
reg [DATA_WIDTH-1:0] rd1_reg;
reg [DATA_WIDTH-1:0] rd2_reg;
reg [DATA_WIDTH-1:0] immgen_reg;
reg [4:0] rd_reg;
reg [4:0] funct_reg;
reg uipc_reg;
reg [PC_WIDTH-1:0] pc_reg;

always @ (posedge clk) begin
	
	if(rst==1'b1)
	begin
	wb_reg <= 0;
	mem_reg <= 0;
	ex_reg <= 0;
//	wb_reg = wb;
//	mem_reg = mem;
//	ex_reg = ex;
	rd1_reg <= 0;
	pc_reg <= 0;
	rd2_reg <= 0;
	immgen_reg <= 0;
	rd_reg <= 0;
	funct_reg <= 0;
	rs1_reg <= 0;
	rs2_reg <= 0;
	uipc_reg <= 0;
	end

	else
	begin
	wb_reg <= wb;
	mem_reg <= mem;
	ex_reg <= ex;
	rd1_reg <= rd1;
	pc_reg <= pci;
	rd2_reg <= rd2;
	immgen_reg <= immgen;
	rd_reg <= rd;
	funct_reg <= funct;
	rs1_reg <= ifid_rs1;
	rs2_reg <= ifid_rs2;
	uipc_reg <= aui;
	end

end

always_comb begin

	wbout = wb_reg;
	memout = mem_reg;
	exout = ex_reg;
	src1 = rd1_reg;
	src2 = rd2_reg;
	immout = immgen_reg;
	rdout = rd_reg;
	aluin = funct_reg;
	pco = pc_reg;
	idex_rs1 = rs1_reg;
	idex_rs2 = rs2_reg;
	ipc = uipc_reg;

end

endmodule
