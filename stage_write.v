module stage_write(

	insn,
	o_in,	
	d_in,  //q_dmem
	write_exception,
	
	data_writeReg, 
	data_writeStatusReg,
	ctrl_writeReg,
	ctrl_writeEnable
	);
	
	input [31:0] insn, o_in, d_in;
	input write_exception;
	output [31:0] data_writeReg;
	output [4:0] ctrl_writeReg;
	output ctrl_writeEnable;
	
	
	wire write_rstatus_exception, lw, jal, setx;
	
	write_controls	wc(insn, write_rstatus_exception, lw, jal, setx, ctrl_writeEnable);
	
	wire [4:0] rd;

	assign rd 			= insn[26:22];
	
	/* Determine reg & data to write to regfile */
	
	wire [31:0] intermediate;
	wire [4:0] ctrl_writeReg_alt1;
	
	assign data_writeReg 		= lw ? d_in : o_in;
	assign ctrl_writeReg 		= jal ? 5'd31 : ctrl_writeReg_alt1;
	assign ctrl_writeReg_alt1	= ( write_exception | setx ) ? 5'd30 : rd;
	
endmodule

module write_controls(insn, write_rstatus_exception, lw, jal, setx, ctrl_writeEnable);
	
	input [31:0] insn;
	output write_rstatus_exception, lw, jal, ctrl_writeEnable, setx;
	
	wire add, addi, sub, mul, div, custom_r;
	wire r_insn;
	wire ALU_add, ALU_sub, ALU_mul, ALU_div;
	wire [4:0] opcode, ALU_op;
	
	assign opcode 		= insn[31:27];
	assign ALU_op 		= insn[6:2];
	
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
	assign setx			=  opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101
	assign custom_r   = 1'b0; // CHANGE THIS LATER
	
	
	assign write_rstatus_exception = add || addi || sub || mul || div;
	assign ctrl_writeEnable = r_insn || addi || lw || jal || setx || custom_r;		//includes write to $rstatus
	

endmodule