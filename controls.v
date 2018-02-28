module controls(opcode, ALU_op, RWE);

	input [4:0] opcode, ALU_op;
	output RWE;

	/* write to regfile */
	assign RWE = (~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]) || //R insn
					(~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || //addi
					(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]) || //lw
					(~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0]) || //jal T
					( opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || //setx T
					(opcode[3]);																		  //custom_r
	
	
endmodule

module controls_readReg(opcode, ALU_op, rd, rs, rt, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg);

	input [4:0] opcode, ALU_op, rd, rs, rt;
	output [4:0] ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
	
	wire write_to_rd, write_to_rs, r_insn;
	
	assign r_insn = (~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);
	
	
	assign write_to_rd = (~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]) || //R insn
								(~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || //addi
								(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]) || //lw
								(opcode[3]);
								
	//status = $r30
	assign write_to_status 	= (r_insn     & ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] & ~ALU_op[0]) || //add  00000 00000
														 ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || //addi 00101
									  (r_insn     & ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] &  ALU_op[0]) || //sub  00000 00001
									  (r_insn     & ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] & ~ALU_op[0]) || //mul  00000 00110
									  (r_insn     & ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] &  ALU_op[0]) || //div  00000 00111
														( opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]);   //setx 10101
	
	//ra = $r31
	assign write_to_31 		= (~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0]) 	//jal T 00011
	assign ctrl_writeReg 	= write_to_rd ? rd : 1'b01111; 
	assign read_from_rt 		=
	

endmodule
