module latch_PC(clock, reset, enable, pc_in, pc_out);

	input [31:0] pc_in;
	input clock, reset, enable;
	output [31:0] pc_out;
	
	reg32_neg pc(pc_in, clock, reset, enable, pc_out);

endmodule


module latch_FD(clock, reset, enable, pc_in, pc_out, pc_plus_1_in, insn_in, pc_plus_1_out, insn_out);

	input  [31:0] pc_plus_1_in, insn_in, pc_in;
	input  clock, reset, enable;
	output [31:0] pc_plus_1_out, insn_out, pc_out;
	
	reg32 pc_address(pc_plus_1_in, clock, reset, enable, pc_plus_1_out);
	reg32 pc_insn(insn_in, clock, reset, enable, insn_out);
	
	//
	reg32 pc_out_reg(pc_in, clock, reset, enable, pc_out);

endmodule

module latch_DX(clock, reset, enable, pc_in, pc_out, pc_plus_1_in, insn_in, pc_plus_1_out, insn_out, a_in, b_in, a_out, b_out);
	
	input  [31:0]  pc_plus_1_in, insn_in, a_in, b_in, pc_in;
	input  clock, reset, enable;
	output [31:0] pc_plus_1_out, insn_out, a_out, b_out, pc_out;
	
	reg32 pc_address(pc_plus_1_in, clock, reset, enable, pc_plus_1_out);
	reg32 pc_insn(insn_in, clock, reset, enable, insn_out);
	
	reg32 data_regA(a_in, clock, reset, enable, a_out);
	reg32 data_regB(b_in, clock, reset, enable, b_out);
	
	//
	reg32 pc_out_reg(pc_in, clock, reset, enable, pc_out);

endmodule

module latch_XM(clock, reset,  enable, write_exception_in, write_exception_out,insn_in, insn_out, o_in, b_in, o_out, b_out);

	input  [31:0] insn_in, o_in, b_in;
	input  clock, reset, enable, write_exception_in;
	output [31:0] insn_out, o_out, b_out;
	output write_exception_out;
	
	reg32 pc_insn(insn_in, clock, reset, enable, insn_out);
	
	reg32 o(o_in, clock, reset, enable, o_out);
	reg32 b(b_in, clock, reset, enable, b_out);
	
	dflipflop my_dffe(write_exception_in, clock, reset, enable, write_exception_out);
	

endmodule

module latch_MW(clock, reset, enable, write_exception_in, write_exception_out, insn_in, insn_out, o_in, d_in, o_out, d_out);

	input  [31:0] insn_in, o_in, d_in;
	input  clock, reset, enable, write_exception_in;
	output [31:0] insn_out, o_out, d_out;
	output write_exception_out;
	
	reg32 pc_insn(insn_in, clock, reset, enable, insn_out);
	
	reg32 o(o_in, clock, reset, enable, o_out);
	reg32 d(d_in, clock, reset, enable, d_out);
	
	dflipflop my_dffe(write_exception_in, clock, reset, enable, write_exception_out);

endmodule
