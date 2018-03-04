module stage_fetch(pc_out, exec_pc_out, j_took_branch, address_imem, pc_upper_5, pc_in);
	
	input [31:0] pc_out, exec_pc_out;
	input j_took_branch;
	
	output [31:0] pc_in;
	output [11:0] address_imem;
	output [4:0] pc_upper_5;
	
	assign address_imem[11:0] = pc_out[11:0];
	assign pc_upper_5[4:0] = pc_out[31:27];
	
	wire dovf, dne, dlt;
	wire [31:0] pc_plus_1;

	adder32 my_adder32(pc_out, 32'd0, 1'b1, pc_plus_1, dovf, dne, dlt);
	
	assign pc_in = j_took_branch ? exec_pc_out : pc_plus_1;

endmodule