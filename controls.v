/***************************************************************************************************************/

module controls(opcode, ALU_op, Rwe, br, DMwe, ALUinB, Rwd, j_sig, jr_sig, jal_sig);

	input [4:0] opcode, ALU_op;
	output Rwe, br, DMwe, ALUinB, Rwd, j_sig, jr_sig, jal_sig;
	
	wire add, addi, sub, and_insn, or_insn, sll, sra, mul, div, sw, lw, j, bne, jal, jr, blt, bex, setx, custom_r;
	wire r_insn;
	wire ALU_add, ALU_sub, ALU_and, ALU_or, ALU_sll, ALU_sra, ALU_mul, ALU_div;
	
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
//	
//	assign ALU_add 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] & ~ALU_op[0];	//00000
//	assign ALU_sub 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] &  ALU_op[0];	//00001
//	assign ALU_and 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] &  ALU_op[1] & ~ALU_op[0];	//00010
//	assign ALU_or	 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] &  ALU_op[1] &  ALU_op[0];	//00011
//	assign ALU_sll 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] & ~ALU_op[1] & ~ALU_op[0];	//00100
//	assign ALU_sra 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] & ~ALU_op[1] &  ALU_op[0];	//00101
//	assign ALU_mul 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] & ~ALU_op[0];	//00110
//	assign ALU_div 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] &  ALU_op[0];	//00111
	
	
//	assign add 			= r_insn && ALU_add;
	assign addi 		= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//00101
//	assign sub 			= r_insn && ALU_sub;
//	assign and_insn 	= r_insn && ALU_and;
//	assign or_insn 	= r_insn && ALU_or;
//	assign sll 			= r_insn && ALU_sll;
//	assign sra 			= r_insn && ALU_sra;
//	assign mul 			= r_insn && ALU_mul;
//	assign div 			= r_insn && ALU_div;
	
	assign sw			= ~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0];	//00111
	assign lw	 		= ~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];	//01000
	
	assign j		 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] &  opcode[0];	//00001
	assign bne	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] & ~opcode[0];	//00010
	assign jal	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
	assign jr			= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] & ~opcode[0];	//00100
	assign blt	 		= ~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//00110
	
	assign bex			=  opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//10110
	assign setx			=  opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101
	assign custom_r 	=  1'b0; 																			//01000 - 11111 Change this later...
	

	assign Rwe 			= r_insn || addi || lw || jal || setx || custom_r;		//includes write to $rstatus
	assign br 			= bne || blt || bex;
	assign j_sig 		= j;
	assign DMwe			= sw;
	assign ALUinB 		= addi || sw || lw; 
	assign Rwd			= lw;
	assign jr_sig 		= jr;
	assign jal_sig 	= jal; // used to write to reg $31 and set PC = T.
	
	
endmodule

/***************************************************************************************************************/

//module controls_regfile(opcode, ALU_op, rd, rs, rt, jal, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg);
//
//	input [4:0] opcode, ALU_op, rd, rs, rt;
//	input jal; 
//	output [4:0] ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
//	
//	wire r_insn;
//	
//	assign r_insn = (~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);
//	assign ctrl_writeReg 	= jal ? 5'b01111 : rd[4:0];
//	assign ctrl_readRegA 	= rs[4:0];									// always read from rs
//	assign ctrl_readRegB    = r_insn ? rt[4:0] : rd[4:0];			// read from rt for R insn, else read from rd for I or JII insn.
//
//endmodule

/***************************************************************************************************************/

//module controls_dmem(opcode, wren);
//
//	input [4:0] opcode;
//	output wren;
//	
//	assign wren = (~opcode[4] & ~opcode[3] & opcode[2] &  opcode[1] &  opcode[0]); 		//sw
//
//endmodule


/***************************************************************************************************************/
//
//module controls_ALU(opcode, ALU_op, immediate, regfile_operandA, regfile_operandB, ALU_operandA, ALU_operandB);
//
//	input [4:0] opcode, ALU_op;
//	input [31:0] regfile_operandA, regfile_operandB;
//	input [16:0] immediate;
//	output [31:0] ALU_operandA, ALU_operandB;
//	
//	wire immed_insn;
//	wire [31:0] immediate_ext;
//	
//	signextender_16to32 my_se(immediate, immediate_ext);
//	
//	assign immed_insn =  (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || // addi
//								(~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0]) || // sw
//								(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);   // lw
//	
//	assign ALU_operandA = regfile_operandA[31:0];
//	
//	
//	assign ALU_operandB = immed_insn ? immediate_ext : regfile_operandB;
//
//endmodule

/***************************************************************************************************************/