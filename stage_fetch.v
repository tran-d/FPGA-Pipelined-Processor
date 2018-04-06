module stage_fetch(pc_in, execute_pc_out, branched_jumped, address_imem, pc_upper_5, pc_out);
	
	input [31:0] pc_in, execute_pc_out;
	input branched_jumped;
	
	output [31:0] pc_out;
	output [11:0] address_imem;
	output [4:0]  pc_upper_5;
	
	wire [31:0] pc_plus_1;
	wire dovf, dne, dlt; // dummy vars
	
	assign address_imem[11:0] 	= pc_in[11:0];
	assign pc_upper_5[4:0] 		= pc_in[31:27];
	assign pc_out 					= branched_jumped ? execute_pc_out : pc_plus_1;
	
	adder32 my_adder32(pc_in, 32'd0, 1'b1, pc_plus_1, dovf, dne, dlt);

endmodule