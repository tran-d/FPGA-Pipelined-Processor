module stage_write(
	
	// inputs
	insn_in,
	o_in,	
	d_in,  				//q_dmem
	write_exception,
	
	// outputs
	data_writeReg,
	ctrl_writeReg,
	ctrl_writeEnable
);
	
	input [31:0] insn_in, o_in, d_in;
	input write_exception;
	
	output [31:0] data_writeReg;
	output [4:0] ctrl_writeReg;
	output ctrl_writeEnable;
	
	wire [4:0] rd, ctrl_writeReg_alt1;
	wire lw, jal, setx;
	
	assign rd 			= insn_in[26:22];
	assign data_writeReg 		= lw 								? d_in	: o_in;
	
	assign ctrl_writeReg 		= jal 							? 5'd31 	: ctrl_writeReg_alt1;
	assign ctrl_writeReg_alt1	= (write_exception | setx) ? 5'd30 	: rd;
	
	write_controls	wc(insn_in, lw, jal, setx, ctrl_writeEnable);
	
endmodule

module write_controls(insn_in, lw, jal, setx, ctrl_writeEnable);
	
	input [31:0] insn_in;
	output lw, jal, ctrl_writeEnable, setx;
	
	wire [4:0] opcode;
	wire addi, custom_r, r_insn;
	
	assign opcode 		= insn_in[31:27];
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];	
	assign addi 		= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//00101
	assign lw	 		= ~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];	//01000
	assign jal	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
	assign setx			=  opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101
	assign custom_r   = 1'b0; // CHANGE THIS FOR PROJECT
	
	assign ctrl_writeEnable = r_insn || addi || lw || jal || setx || custom_r;		// includes write to $rstatus

endmodule