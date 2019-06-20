`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:22:44 PM
// Design Name: 
// Module Name: imm_Gen
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


module imm_Gen(
    input logic [31:0] inst_code,
    output logic [31:0] Imm_out);


always_comb
    case(inst_code[6:0])

        7'b0000011 /*I-type load*/     : 
            Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
        7'b0010011 /*I-type addi*/     : 
            Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
        7'b0100011 /*S-type*/    : 
            Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:25], inst_code[11:7]};
			
	7'b1100111: /*JALR*/		
	    //Imm_out = {inst_code[31]? 20'b1:20'b0 , inst_code[31:20]};
	    //Imm_out = {19'b0, inst_code[31:20], 1'b0};
		Imm_out = {inst_code[31]? 19'b1:19'b0 , inst_code[31:20], 1'b0}; //ignore the last bit, nein shift


	7'b1101111: /*JAL*/ 
	    //Imm_out = {inst_code[31]? 12'b1:12'b0, inst_code[31] , inst_code[19:12] , inst_code[20] , inst_code[30:21]};
	    //Imm_out = {11'b0, inst_code[31] , inst_code[19:12] , inst_code[20] , inst_code[30:21], 1'b0};
		Imm_out = {inst_code[31]? 11'b1:11'b0, inst_code[31] , inst_code[19:12] , inst_code[20] , inst_code[30:21],1'b0};
		
	7'b1100011 /*Conditional Branch----*/ :
	    //Imm_out = {20'b0, inst_code[31], inst_code[7] , inst_code[30:25] , inst_code[11:8]};
	    Imm_out = {19'b0, inst_code[31], inst_code[7] , inst_code[30:25] , inst_code[11:8], 1'b0};
	7'b0110111 /*LUI*/		:
	    //Imm_out = {inst_code[31:12], 12'b0};	
	    Imm_out = {inst_code[31:28],inst_code[27:24],inst_code[23:20],inst_code[19:16],inst_code[15:12], 12'b0};	
	7'b0010111 /*AUIPC---*/		:
	    //ideally it should be this:	Imm_out = {inst_code[31:12], 12'b0};
		//but our datapath needs its lower 9 bits, divided by 4
	    Imm_out = {inst_code[31:12],12'b0};

	7'b0000011 /*LW LB LH LBU LHU*/ :
	    Imm_out = {inst_code[31]? 20'b1: 20'b0, inst_code[31:20]};
	    
	7'b0100011 /*SW SB SH*/		:
	    Imm_out = {inst_code[31]? 20'b1: 20'b0, inst_code[31:25], inst_code[11:7]};
	

	/*assuming imm_gen is not turned on w R-type*/
        default                    : 
            Imm_out = {32'b0};
    endcase
    
endmodule
