module stage_execute(

	opcode,
	ALU_op,
	immediate,
	shamt,
	target,
	regfile_operandA,
	regfile_operandB,
	pc_plus_4,
	pc_upper_5, 
	b_out,
	o_out,
	take_branch,
	overflow,
	pc_in
	);

	input [4:0] opcode, ALU_op, shamt, pc_upper_5;
	input [16:0] immediate;
	input [31:0] regfile_operandA, regfile_operandB, pc_plus_4;
	input [26:0] target;
	
	output [31:0] o_out, b_out;
	output take_branch, overflow;
	output [31:0] pc_in;

	wire isNotEqual, isLessThan;
	wire [31:0] ALU_operandA;
		
	execute_controls ec(opcode, ALU_op, immediate, target, regfile_operandA, regfile_operandB, 
					pc_plus_4, pc_upper_5, ALU_operandA, b_out,  isNotEqual, isLessThan, take_branch, pc_in);
		
	alu my_alu(ALU_operandA, b_out, ALU_op, shamt, o_out, isNotEqual, isLessThan, overflow);
	

endmodule


module execute_controls(opcode, ALU_op, immediate, target, regfile_operandA, regfile_operandB, 
					pc_plus_4, pc_upper_5, ALU_operandA, ALU_operandB,  isNotEqual, isLessThan, take_branch, pc_in);

	input [4:0] opcode, ALU_op, pc_upper_5;
	input [26:0] target;
	input [31:0] regfile_operandA, regfile_operandB, pc_plus_4; 
	input [16:0] immediate;
	input  isNotEqual, isLessThan;
	
	output [31:0] ALU_operandA, ALU_operandB, pc_in;
	output take_branch;
	
	wire immed_insn, bne, blt, bex, j, jal, jr, take_bne, take_blt, take_bex;
	wire [31:0] immediate_ext, inter1, inter2, inter3;
	
	signextender_16to32 my_se(immediate, immediate_ext);
	
	assign immed_insn =  (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || // addi
								(~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0]) || // sw
								(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);   // lw
	
	
	assign bne	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] & ~opcode[0];	//00010
	assign blt	 		= ~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//00110
	assign bex			=  opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//10110
	assign j		 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] &  opcode[0];	//00001
	assign jal	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
	assign jr			= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] & ~opcode[0];	//00100
	
	
	
	assign ALU_operandA 	= regfile_operandA[31:0];
	
	assign ALU_operandB 	= immed_insn  		? immediate_ext	 				: inter1[31:0];
	assign inter1[31:0] 	= bex					? 32'd0							: regfile_operandB;
	
	
	/* Branch Controls */ 
	assign take_bne 		= bne && isNotEqual;
	assign take_blt		= blt && ~isLessThan && isNotEqual;  // rs > rd ---> rs 	notLT & NE rd
	assign take_bex		= bex && isNotEqual;
	
	assign take_branch 	= take_bne || take_blt || take_bex;
	
	
	wire [31:0] pc_plus_4_plus_immediate;
	wire dovf, dne, dlt;
	
	/* PC controls */ 
	assign pc_in 			= (j | jal | take_bex) 	? {pc_upper_5, target} 		:  inter2; 		// PC = T, 				j/jal/take_bex
	assign inter2 			= (take_bne | take_blt) ? pc_plus_4_plus_immediate :	inter3; 		// PC = PC + 1 + N, 	take_bne/take_blt
	assign inter3			= jr 							? regfile_operandB			: 	pc_plus_4;	// PC = $rd				jr  (else PC = PC + 1)
	
	adder32 my_adder32(pc_plus_4, immediate_ext, 1'b0, pc_plus_4_plus_immediate, dovf, dne, dlt);
	
	
endmodule
