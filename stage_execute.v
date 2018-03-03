module stage_execute(

	// inputs
	insn,
	regfile_operandA,
	regfile_operandB,
	pc_plus_1,
	pc_upper_5,

	// outputs
	o_out,
	b_out,
	take_branch,
	overflow,
	pc_in
	);

	input [4:0] pc_upper_5;
	input [31:0] insn, regfile_operandA, regfile_operandB, pc_plus_1;
	
	output [31:0] o_out, b_out;
	output take_branch, overflow;
	output [31:0] pc_in;

	wire isNotEqual, isLessThan;
	
	wire [31:0] ALU_operandA, ALU_operandB;
	wire [4:0] mux_ALU_op, shamt;
	
	
	assign shamt = insn[11:7];
		
	execute_controls ec(insn, regfile_operandA, regfile_operandB, pc_plus_1, pc_upper_5, 
								ALU_operandA, ALU_operandB, isNotEqual, isLessThan, take_branch, pc_in, mux_ALU_op);
		
	alu my_alu(ALU_operandA, ALU_operandB, mux_ALU_op, shamt, o_out, isNotEqual, isLessThan, overflow);
	
	assign b_out = regfile_operandB;
	

endmodule


module execute_controls(insn, regfile_operandA, regfile_operandB, pc_plus_4, pc_upper_5, 
							ALU_operandA, ALU_operandB, isNotEqual, isLessThan, take_branch, pc_in, mux_ALU_op);

	input [4:0] pc_upper_5;
	input [31:0] insn, regfile_operandA, regfile_operandB, pc_plus_4; 
	input  isNotEqual, isLessThan;
	
	output [31:0] ALU_operandA, ALU_operandB, pc_in;
	output take_branch;
	output [4:0] mux_ALU_op;
	
	/* Insn Controls */
	wire [4:0] opcode, ALU_op;
	wire [16:0] immediate;
	wire [26:0] target;
	
	assign opcode 		= insn[31:27];
	assign ALU_op 		= insn[6:2];
	assign immediate 	= insn[16:0];
	assign target 		= insn[26:0];
	
	
	/* ALU Controls */
	wire addi, immed_insn, bne, blt, bex, j, jal, jr;
	wire [31:0] immediate_ext, inter1;
	wire [4:0] interm_ALU_op;
	
	signextender_16to32 my_se(immediate, immediate_ext);
	
	assign addi 		= (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]); // addi needs ALU_op = 00000
	
	assign immed_insn =  (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || // addi
								(~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0]) || // sw
								(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);   // lw
	
	
	assign ALU_operandA 	= regfile_operandA[31:0];
	assign ALU_operandB 	= immed_insn  	? immediate_ext	: inter1[31:0];
	assign inter1[31:0] 	= bex				? 32'd0				: regfile_operandB;
	
	assign mux_ALU_op 	= addi ? 5'd0 : interm_ALU_op;
	assign interm_ALU_op = (blt | bne | bex)  ? 5'd1 : ALU_op;
	
	
	/* Branch Controls */ 
	wire take_bne, take_blt, take_bex;
	
	assign bne	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] & ~opcode[0];	//00010
	assign blt	 		= ~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//00110
	assign bex			=  opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] & ~opcode[0];	//10110
	assign j		 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] &  opcode[0];	//00001
	assign jal	 		= ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011
	assign jr			= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] & ~opcode[0];	//00100
	
	assign take_bne 		= bne && isNotEqual;
	assign take_blt		= blt && ~isLessThan && isNotEqual;  // rs > rd ---> rs 	notLT & NE rd
	assign take_bex		= bex && isNotEqual;
	assign take_branch 	= take_bne || take_blt || take_bex;
	
	
	/* PC controls */ 
	wire [31:0] pc_plus_4_plus_immediate;
	wire dovf, dne, dlt;
	wire [31:0] inter2, inter3;
	
	assign pc_in 			= (j | jal | take_bex) 	? {pc_upper_5, target} 		:  inter2; 		// PC = T, 				j/jal/take_bex
	assign inter2 			= (take_bne | take_blt) ? pc_plus_4_plus_immediate :	inter3; 		// PC = PC + 1 + N, 	take_bne/take_blt
	assign inter3			= jr 							? regfile_operandB			: 	pc_plus_4;	// PC = $rd				jr  (else PC = PC + 1)
	
	adder32 my_adder32(pc_plus_4, immediate_ext, 1'b0, pc_plus_4_plus_immediate, dovf, dne, dlt);
	
	
endmodule
