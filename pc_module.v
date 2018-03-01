module pc_module(pc_in, clock, reset, pc_ena, pc_out, pc_plus_1);

	input [31:0] pc_in;
	input clock, reset, pc_ena;
	output [31:0] pc_out, pc_plus_1;
	
	wire dovf, dne, dlt;
	
	PC my_PC(pc_in, clock, reset, pc_ena, pc_out);
	
	adder32 my_adder32(pc_in, {{29{1'b0}}, 1'b1, 2'b00}, 1'b0, pc_plus_1, dovf, dne, dlt);

	
endmodule

/***************************************************************************************************/

module PC(in, clock, reset, ena, out);

	input [31:0] in;
	input clock, reset, ena;
	output [31:0] out;

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin: loop1
			dflipflop mydffe(in[i], clock, reset, ena, out[i]);
		end
	endgenerate

endmodule

