module stage_write(
	
	// inputs
	insn_in,
	o_in,	
	d_in,  				//q_dmem
	multdiv_result,
	multdiv_RDY,
	write_exception,
	
	// outputs
	data_writeReg,
	ctrl_writeReg,
	ctrl_writeEnable
);
	
	input [31:0] insn_in, o_in, d_in, multdiv_result;
	input multdiv_RDY, write_exception;
	
	output [31:0] data_writeReg;
	output [4:0] ctrl_writeReg;
	output ctrl_writeEnable;
	
	wire [31:0] data_writeReg_alt;
	wire [4:0] rd, ctrl_writeReg_alt1;
	wire lw, jal, setx, mul, div;
	
	assign rd 						= insn_in[26:22];
	assign data_writeReg 		= lw 								? d_in	: data_writeReg_alt;
	assign data_writeReg_alt	= (mul || div)					? multdiv_result : o_in;
	
	assign ctrl_writeReg 		= jal 							? 5'd31 	: ctrl_writeReg_alt1;
	assign ctrl_writeReg_alt1	= (write_exception | setx) ? 5'd30 	: rd;
	
	write_controls	wc(insn_in, multdiv_RDY, lw, jal, setx, mul, div, ctrl_writeEnable);
	
endmodule

module write_controls(insn_in, multdiv_RDY, lw, jal, setx, mul, div, ctrl_writeEnable);
	
	input [31:0] insn_in;
    input multdiv_RDY;
	output lw, jal, ctrl_writeEnable, setx, mul, div;
	

	wire [4:0] opcode, ALU_op;
	wire addi, cap, custom_r, r_insn;
	
	assign opcode 		= insn_in[31:27];
	assign ALU_op		= insn_in[6:2];
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];	
	assign cap			= ~opcode[4] &  opcode[3] &  opcode[2] & ~opcode[1] & ~opcode[0];	//01100
	assign addi 		= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//00101
	assign lw	 		= ~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];	//01000
	assign jal	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
	assign setx			=  opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101
	assign custom_r     = 1'b0; // CHANGE THIS FOR PROJECT
	
	assign mul		 	= r_insn && (~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] & ~ALU_op[0]);	//00110
	assign div		 	= r_insn && (~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] &  ALU_op[0]);	//00111

	assign ctrl_writeEnable = cap || (r_insn && ~mul && ~div) || ((mul || div) && multdiv_RDY) || addi || lw || jal || setx || custom_r;		// includes write to $rstatus


endmodule