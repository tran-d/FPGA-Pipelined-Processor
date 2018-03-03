module stage_fetch(pc_out, address_imem, pc_plus_4, pc_upper_5);
	
	input [31:0] pc_out;
	
	output [31:0] pc_plus_4;
	output [11:0] address_imem;
	output [4:0] pc_upper_5;
	
	
	assign address_imem[11:0] = pc_out[11:0];
	assign pc_upper_5[4:0] = pc_out[31:27];
	
	wire dovf, dne, dlt;

	adder32 my_adder32(pc_out, 32'd0, 1'b1, pc_plus_4, dovf, dne, dlt);

endmodule