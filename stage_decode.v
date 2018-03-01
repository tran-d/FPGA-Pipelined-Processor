module stage_decode(

	opcode,
	ALU_op,
	rd,
	rs,
	rt,
	ctrl_readRegA,
	ctrl_readRegB,
	ctrl_writeReg);
	
	
	input [4:0] opcode, ALU_op, rd, rs, rt;
	output [4:0] ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
	
	decode_controls(opcode, ALU_op, rd, rs, rt, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg);
	
endmodule


module decode_controls(opcode, ALU_op, rd, rs, rt, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg);

	input [4:0] opcode, ALU_op, rd, rs, rt;
	output [4:0]  ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
	
	wire r_insn;
	assign r_insn = (~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);
	
	
	assign jal	 				= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
	assign ctrl_writeReg 	= jal ? 5'b01111 : rd[4:0];
	assign ctrl_readRegA 	= rs[4:0];									// always read from rs
	assign ctrl_readRegB    = r_insn ? rt[4:0] : rd[4:0];			// read from rt for R insn, else read from rd for I or JII insn.

endmodule