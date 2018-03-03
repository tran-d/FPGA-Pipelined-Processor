module FD_latch(pc_plus_1, pc_insn);

	input [31:0] pc_plus_1, pc_insn;
	

endmodule

module DX_latch(pc_plus_1, pc_insn, a_in, b_in, a_out, b_out);
	
	input [31:0] pc_plus_1, pc_insn,a_in, b_in;
	output [31:0] a_out, b_out;
	

endmodule

module XM_latch(pc_insn, o_in, b_in, o_out, b_out);

	input [31:0] pc_plus_1, pc_insn;
	output [31:0] o_out, b_out;
	

endmodule

module MW_latch(pc_insn, o_in, d_in, o_out, d_out);

	input [31:0] pc_plus_1, pc_insn;
	output [31:0] o_out, d_out;
	

endmodule
