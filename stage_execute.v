module stage_execute(

	opcode,
	ALU_op,
	immediate,
	shamt,
	regfile_operandA,
	regfile_operandB,
	ALU_operandA, 
	ALU_operandB,
	ALU_result,
	take_branch,
	overflow);

	input [4:0] opcode, ALU_op, shamt;
	input [16:0] immediate;
	input [31:0] regfile_operandA, regfile_operandB;
	output [31:0] ALU_result, ALU_operandA, ALU_operandB;
	output take_branch, overflow;

	wire isNotEqual, isLessThan;
		
		
	execute_controls ec(opcode, ALU_op, immediate, regfile_operandA, regfile_operandB, ALU_operandA, ALU_operandB,  isNotEqual, isLessThan, take_branch);
		
	alu my_alu(ALU_operandA, ALU_operandB, ALU_op, shamt, ALU_result, isNotEqual, isLessThan, overflow);
	

endmodule

module execute_controls(opcode, ALU_op, immediate, regfile_operandA, regfile_operandB, ALU_operandA, ALU_operandB,  isNotEqual, isLessThan, take_branch);

	input [4:0] opcode, ALU_op;
	input [31:0] regfile_operandA, regfile_operandB; 
	input [16:0] immediate;
	input  isNotEqual, isLessThan;
	output [31:0] ALU_operandA, ALU_operandB;
	output take_branch;
	
	wire immed_insn, bne, blt, bex, take_bne, take_blt, take_bex;
	wire [31:0] immediate_ext, inter1, inter2;
	
	signextender_16to32 my_se(immediate, immediate_ext);
	
	assign immed_insn =  (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || // addi
								(~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0]) || // sw
								(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);   // lw
	
	
	assign bne	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] & ~opcode[0];	//00010
	assign blt	 		= ~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//00110
	assign bex			=  opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//10110
	
	
	assign ALU_operandA 	= regfile_operandA[31:0];
	
	assign ALU_operandB 	= immed_insn  		? immediate_ext	 				: inter1[31:0];
	assign inter1[31:0] 	= bex					? 32'd0							: regfile_operandB;
	
	/* Branch Controls */ 
	assign take_bne 		= bne && isNotEqual;
	assign take_blt		= blt && ~isLessThan && isNotEqual;  // rs > rd ---> rs 	notLT & NE rd
	assign take_bex		= bex && isNotEqual;
	
	assign take_branch 	= take_bne || take_blt || take_bex;

endmodule
