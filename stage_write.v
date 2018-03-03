module stage_write(
	opcode, 
	ALU_op, 
	o_in,
	rd,	
	pc_plus_4, 
	pc_upper_5,
	target,
	d_in,  //q_dmem
	exception, 
	data_writeReg, 
	data_writeStatusReg,
	ctrl_writeReg);

	input [4:0] opcode, ALU_op, rd, pc_upper_5;
	input [31:0] o_in, pc_plus_4, d_in;
	input exception; 
	input [26:0] target;
	output [31:0] data_writeReg, data_writeStatusReg;
	output [4:0] ctrl_writeReg;
	
	
	wire write_rstatus_exception, lw, jal;
	
	write_controls	wc(opcode, ALU_op, write_rstatus_exception, lw, jal);
	
	/* Determine reg & data to write to regfile */
	
	wire [31:0] intermediate;
	
	assign intermediate  	 	= lw 	? d_in	   : o_in;
	assign data_writeReg		   = jal ? pc_plus_4 : intermediate;		// lw, jal, ALU_result
	assign data_writeStatusReg = write_rstatus_exception ? {{31{1'b0}}, exception} : {pc_upper_5, target};  // rstatus = T (setx) or exception (add, addi, sub, mul, div)
	assign ctrl_writeReg 		= jal ? 5'd31 : rd;
	
endmodule

module write_controls(opcode, ALU_op, write_rstatus_exception, lw, jal);
	
	input [4:0] opcode, ALU_op;
	output write_rstatus_exception, lw, jal;
	
	wire add, addi, sub, mul, div;
	wire r_insn;
	wire ALU_add, ALU_sub, ALU_mul, ALU_div;
	
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];

	assign ALU_add 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] & ~ALU_op[0];	//00000
	assign ALU_sub 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] &  ALU_op[0];	//00001
	assign ALU_mul 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] & ~ALU_op[0];	//00110
	assign ALU_div 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] &  ALU_op[0];	//00111	
	
	assign add 			= r_insn && ALU_add;
	assign addi 		= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//00101
	assign sub 			= r_insn && ALU_sub;
	assign mul 			= r_insn && ALU_mul;
	assign div 			= r_insn && ALU_div;
	
	
	assign lw	 		= ~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];	//01000
	assign jal	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
//	assign setx			=  opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101
	
	assign write_rstatus_exception = add || addi || sub || mul || div;

endmodule