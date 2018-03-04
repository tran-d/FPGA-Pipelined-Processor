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
	write_exception,
	pc_in,
	j_took_branch);

	input [4:0] pc_upper_5;
	input [31:0] insn, regfile_operandA, regfile_operandB, pc_plus_1;
	
	output [31:0] o_out, b_out;
	output take_branch, write_exception, j_took_branch; // might need this
	output [31:0] pc_in;

	wire isNotEqual, isLessThan, exception;
	
	wire [31:0] ALU_operandA, ALU_operandB, ALU_result;
	wire [4:0] mux_ALU_op, shamt;
	
	
	assign shamt = insn[11:7];
		
	execute_controls ec(insn, regfile_operandA, regfile_operandB, pc_plus_1, pc_upper_5, exception,
								ALU_operandA, ALU_operandB, ALU_result, isNotEqual, isLessThan, take_branch, pc_in, mux_ALU_op, 
								j_took_branch, o_out, write_exception);
		
	alu my_alu(ALU_operandA, ALU_operandB, mux_ALU_op, shamt, ALU_result, isNotEqual, isLessThan, exception);
	
	assign b_out 		= regfile_operandB;
	

endmodule


module execute_controls(insn, regfile_operandA, regfile_operandB, pc_plus_1, pc_upper_5, exception,
							ALU_operandA, ALU_operandB, ALU_result, isNotEqual, isLessThan, take_branch, pc_in, mux_ALU_op, 
							j_took_branch, o_out, write_exception);

	input [4:0] pc_upper_5;
	input [31:0] insn, regfile_operandA, regfile_operandB, ALU_result, pc_plus_1; 
	input  isNotEqual, isLessThan, exception;
	
	output [31:0] ALU_operandA, ALU_operandB, pc_in, o_out;
	output take_branch, j_took_branch, write_exception;
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
	wire r_insn, addi, add, sub, mul, div, ALU_add, ALU_sub, ALU_mul, ALU_div, immed_insn, bne, blt, bex, j, jr, jal, setx;
	wire [31:0] immediate_ext, inter1;
	wire [4:0] interm_ALU_op;
	
	signextender_16to32 my_se(immediate, immediate_ext);
	
	
	assign ALU_add 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] & ~ALU_op[0];	//00000
	assign ALU_sub 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] &  ALU_op[0];	//00001
	assign ALU_mul 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] & ~ALU_op[0];	//00110
	assign ALU_div 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] &  ALU_op[0];	//00111
	
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
	
	assign addi 		= (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]); // addi needs ALU_op = 00000
	assign add 			= r_insn && ALU_add;
	assign sub 			= r_insn && ALU_sub;
	assign mul 			= r_insn && ALU_mul;
	assign div 			= r_insn && ALU_div;
	
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
	assign setx			=  opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101
	
	assign take_bne 		= bne && isNotEqual;
	assign take_blt		= blt && ~isLessThan && isNotEqual;  // rs > rd ---> rs 	notLT & NE rd
	assign take_bex		= bex && isNotEqual;
	assign take_branch 	= take_bne || take_blt || take_bex;
	
	
	/* PC controls */ 
	wire [31:0] pc_plus_1_plus_immediate;
	wire dovf, dne, dlt;
	wire [31:0] inter2, inter3;
	
	assign pc_in 			= (j | jal | take_bex) 	? {pc_upper_5, target} 		:  inter2; 		// PC = T, 				j/jal/take_bex
	assign inter2 			= (take_bne | take_blt) ? pc_plus_1_plus_immediate :	inter3; 		// PC = PC + 1 + N, 	take_bne/take_blt
	assign inter3			= jr 							? regfile_operandB			: 	32'd0;		// PC = $rd				jr  (else PC = PC + 1) ?= 0
	
	adder32 my_adder32(pc_plus_1, immediate_ext, 1'b0, pc_plus_1_plus_immediate, dovf, dne, dlt);
	
	assign j_took_branch = j | jal | take_bex | take_blt | take_bne | jr;
	
	
	/* LATCH Controls */ 
	wire [31:0] o_out_alt1, o_out_alt2, o_out_alt3, o_out_alt4, o_out_alt5, o_out_alt6;
	
	assign o_out 		= jal ? pc_plus_1 : o_out_alt1;
	assign o_out_alt1 = (add  && exception) ? 32'd1 : o_out_alt2;
	assign o_out_alt2 = (addi && exception) ? 32'd2 : o_out_alt3;
	assign o_out_alt3 = (sub  && exception) ? 32'd3 : o_out_alt4;
	assign o_out_alt4 = (mul  && exception) ? 32'd4 : o_out_alt5;
	assign o_out_alt5 = (div  && exception) ? 32'd5 : o_out_alt6;
	assign o_out_alt6 = setx ? {pc_upper_5, target} : ALU_result;
	
	assign write_exception = exception && (add | addi | sub | mul | div);
	
endmodule
