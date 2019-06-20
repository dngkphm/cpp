
module MEMWB#(
	
	parameter DATA_WIDTH = 32	 
   )
   (
   input clk, rst,
   input logic [DATA_WIDTH-1:0] data,
   input logic [DATA_WIDTH-1:0] addr,
   input logic [1:0] wb, 
   input logic [4:0] rdout2,
   output logic [4:0] rdout3,
   output logic [DATA_WIDTH-1:0] mux1,
   output logic [DATA_WIDTH-1:0] mux0,
   output logic [1:0] wbout
   );

   
reg [4:0] rd_reg;
reg [DATA_WIDTH-1:0] data_reg;
reg [DATA_WIDTH-1:0] addr_reg;
reg [1:0] wb_reg;

always @ (posedge clk) begin

	if (rst == 1'b1) 
	begin
	rd_reg <= 0;
	data_reg <= 0;
	addr_reg <= 0;
	wb_reg <= 0;
	end

	else
	begin
	rd_reg <= rdout2;
	data_reg <= data;
	addr_reg <= addr;
	wb_reg <= wb;
	end
end

always_comb begin

	rdout3 = rd_reg;
	mux0 = addr_reg;
	mux1 = data_reg;
	wbout = wb_reg;

end

endmodule
