module stage_write(opcode, ALU_op, ALU_result, pc_plus_1, q_dmem, exception, data_writeReg, data_writeStatusReg);

	input [4:0] opcode, ALU_op;
	input [31:0] ALU_result, pc_plus_1, q_dmem;
	input exception; 
	output [31:0] data_writeReg, data_writeStatusReg;
	
	wire write_rstatus_exception, lw, jal;
	
	write_controls	wc(opcode, ALU_op, write_rstatus_exception, lw, jal);

	// rstatus = T (setx) or exception (add, addi, sub, mul, div)
	assign data_writeStatusReg = write_rstatus_exception ? {{31{1'b0}}, exception} : pc_plus_1;

	wire [31:0] intermediate;
	
	assign intermediate[31:0] 	= lw 	? q_dmem[31:0] : ALU_result;
	assign data_writeReg[31:0] = jal ? pc_plus_1 : intermediate;
	
endmodule

module write_controls(opcode, ALU_op, write_rstatus_exception, lw, jal);
	
	input [4:0] opcode, ALU_op;
	output write_rstatus_exception, lw, jal;
	// lw, JAL, setx
	
	wire add, addi, sub, mul, div, setx;
	wire r_insn;
	wire ALU_add, ALU_sub, ALU_mul, ALU_div;
	
	
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];

	assign setx			=  opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101
	assign ALU_add 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] & ~ALU_op[0];	//00000
	assign ALU_sub 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] &  ALU_op[0];	//00001
	assign ALU_mul 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] & ~ALU_op[0];	//00110
	assign ALU_div 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] &  ALU_op[0];	//00111	
	
	assign add 			= r_insn && ALU_add;
	assign addi 		= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//00101
	assign sub 			= r_insn && ALU_sub;
	assign mul 			= r_insn && ALU_mul;
	assign div 			= r_insn && ALU_div;
	
	assign jal	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
	

	assign write_rstatus_exception = add || addi || sub || mul || div;

endmodule