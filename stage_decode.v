module stage_decode(

	insn_in,
	ctrl_readRegA,
	ctrl_readRegB);
	
	
	input [31:0] insn_in;
	output [4:0] ctrl_readRegA, ctrl_readRegB;
	
	decode_controls dc(insn_in, ctrl_readRegA, ctrl_readRegB);
	
endmodule


module decode_controls(insn, ctrl_readRegA, ctrl_readRegB);

	input [31:0] insn;
	output [4:0] ctrl_readRegA, ctrl_readRegB;
	
	wire [4:0] opcode, rd, rs, rt;
	
	assign opcode 		= insn[31:27];
	assign rd 			= insn[26:22];
	assign rs 			= insn[21:17];
	assign rt 			= insn[16:12];
	
	wire r_insn, bex;
	
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
	assign bex			=  opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//10110
	
	assign ctrl_readRegA 	= bex 	? 5'd30	 : rs[4:0];			// always read from rs except for bex ($r30)
	assign ctrl_readRegB    = r_insn ? rt[4:0] : rd[4:0];			// read from rt for R insn, else read from rd for I or JII insn.

endmodule