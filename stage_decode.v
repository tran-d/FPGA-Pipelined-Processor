module stage_decode(

	opcode,
	ALU_op,
	rd,
	rs,
	rt,
	ctrl_readRegA,
	ctrl_readRegB);
	
	
	input [4:0] opcode, ALU_op, rd, rs, rt;
	output [4:0] ctrl_readRegA, ctrl_readRegB;
	
	decode_controls dc(opcode, ALU_op, rd, rs, rt, ctrl_readRegA, ctrl_readRegB);
	
endmodule


module decode_controls(opcode, ALU_op, rd, rs, rt, ctrl_readRegA, ctrl_readRegB);

	input [4:0] opcode, ALU_op, rd, rs, rt;
	output [4:0]  ctrl_readRegA, ctrl_readRegB;
	
	wire r_insn, bex;
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
	assign bex			=  opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//10110
	
	assign ctrl_readRegA 	= bex 	? 5'd30	 : rs[4:0];			// always read from rs except for bex ($r30)
	assign ctrl_readRegB    = r_insn ? rt[4:0] : rd[4:0];			// read from rt for R insn, else read from rd for I or JII insn.

endmodule