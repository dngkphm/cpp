`timescale 1ns / 1ps

module ext23
    #(parameter  WIDTH = 9)	
    (input logic [WIDTH-1:0] short,
    output logic [31:0] out);

assign out = {23'b0, short};

endmodule
