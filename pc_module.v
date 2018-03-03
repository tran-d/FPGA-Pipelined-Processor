module pc_module(pc_in, clock, reset, pc_ena, address_imem, pc_plus_4, pc_upper_5, pc_out);

	input [31:0] pc_in;
	input clock, reset, pc_ena;
	output [31:0] pc_plus_4;
	output [11:0] address_imem;
	output [4:0] pc_upper_5;
	
	

	output [31:0] pc_out;
	
	assign address_imem[11:0] = pc_out[11:0];
	
	wire dovf, dne, dlt;
	
	pc_reg my_PC(pc_in, clock, reset, pc_ena, pc_out);
//	reg32 my_pc_reg(pc_in, clock, reset, pc_ena, pc_out);
	
	adder32 my_adder32(pc_out, 32'd0, 1'b1, pc_plus_4, dovf, dne, dlt);

//	adder32 my_adder32(pc_out, {{29{1'b0}}, 1'b1, 2'b00}, 1'b0, pc_plus_4, dovf, dne, dlt);

	assign pc_upper_5[4:0] = pc_out[31:27];
	
endmodule

/***************************************************************************************************/

module pc_reg(in, clock, reset, ena, out);

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

/***************************************************************************************************/