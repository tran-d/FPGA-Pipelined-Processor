module stage_execute(

	// inputs
	insn,
	regfile_operandA,
	regfile_operandB,
	pc_upper_5,
	pc_out,
	mx_bypass_A, 
	wx_bypass_A, 
	mx_bypass_B,
	wx_bypass_B,
	o_xm_out,
	data_writeReg,

	// outputs
	o_out,
	b_out,
	write_exception,
	pc_in,
	branched_jumped
);

	input [4:0] pc_upper_5;
	input [31:0] insn, regfile_operandA, regfile_operandB, pc_out, o_xm_out, data_writeReg;
	input mx_bypass_A, wx_bypass_A, mx_bypass_B, wx_bypass_B;  
	
	output [31:0] pc_in, o_out, b_out;
	output write_exception, branched_jumped;
	
	wire [31:0] ALU_operandA, ALU_operandB, ALU_result;
	wire [4:0] ALU_op_new, shamt;
	wire take_branch, isNotEqual, isLessThan, exception;
	assign shamt = insn[11:7];
		
	alu my_alu(ALU_operandA, ALU_operandB, ALU_op_new, shamt, ALU_result, isNotEqual, isLessThan, exception);

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
	wire [31:0] immediate_extended;
	wire [4:0] ALU_op_new_alt;
	
	signextender_16to32 my_se(immediate, immediate_extended);
	
	assign ALU_add 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] & ~ALU_op[0];	//00000
	assign ALU_sub 	= ~ALU_op[4] & ~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1] &  ALU_op[0];	//00001
	assign ALU_mul 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] & ~ALU_op[0];	//00110
	assign ALU_div 	= ~ALU_op[4] & ~ALU_op[3] &  ALU_op[2] &  ALU_op[1] &  ALU_op[0];	//00111
	assign r_insn 		= ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
	assign addi 		= ~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]; // addi needs ALU_op = 00000
	assign add 			= r_insn && ALU_add;
	assign sub 			= r_insn && ALU_sub;
	assign mul 			= r_insn && ALU_mul;
	assign div 			= r_insn && ALU_div;
	
	assign immed_insn =  (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || // addi
								(~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0]) || // sw
								(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);   // lw
	
	/* ALU Inputs */
	wire [31:0] ALU_operandA_alt, ALU_operandB_alt1, ALU_operandB_alt2, ALU_operandB_alt3;
	
	assign ALU_operandA 			= mx_bypass_A 	? o_xm_out 			: ALU_operandA_alt;
	assign ALU_operandA_alt 	= wx_bypass_A 	? data_writeReg 	: regfile_operandA;
	
	assign ALU_operandB 			= immed_insn  	? immediate_extended	: ALU_operandB_alt1;
	assign ALU_operandB_alt1	= bex				? 32'd0				: ALU_operandB_alt2;
	assign ALU_operandB_alt2 	= mx_bypass_B  ? o_xm_out			: ALU_operandB_alt3;
	assign ALU_operandB_alt3 	= wx_bypass_B	? data_writeReg	: regfile_operandB;
	
	assign ALU_op_new 			= addi 			? 5'd0 				: ALU_op_new_alt;
	assign ALU_op_new_alt 		= (blt | bne | bex)  ? 5'd1 : ALU_op;
	
	
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
	
	
	/* PC Controls */ 
	wire [31:0] pc_plus_1_plus_immediate, pc_in_alt1, pc_in_alt2;
	wire dovf1, dne1, dlt1; // dummy vars
	
	adder32 my_adder32(pc_out, immediate_extended, 1'b0, pc_plus_1_plus_immediate, dovf1, dne1, dlt1); // don't need a carry-in for some reason...
	
	assign pc_in			= (j | jal | take_bex) 	? {pc_upper_5, target} 		:  pc_in_alt1; 		// PC = T, 				j/jal/take_bex
	assign pc_in_alt1 	= (take_bne | take_blt) ? pc_plus_1_plus_immediate :	pc_in_alt2; 		// PC = PC + 1 + N, 	take_bne/take_blt
	assign pc_in_alt2		= jr 							? regfile_operandB			: 	32'd0;				// PC = $rd				jr, else PC = (PC + 1) or (0)
	
	assign branched_jumped = j | jal | take_bex | take_blt | take_bne | jr;
	
	
	/* LATCH Controls */ 
	wire [31:0] o_out_alt1, o_out_alt2, o_out_alt3, o_out_alt4, o_out_alt5, o_out_alt6, b_out_alt;
	
	assign o_out 		= jal	? pc_out : o_out_alt1;
	assign o_out_alt1 = (add  && exception) ? 32'd1 : o_out_alt2;
	assign o_out_alt2 = (addi && exception) ? 32'd2 : o_out_alt3;
	assign o_out_alt3 = (sub  && exception) ? 32'd3 : o_out_alt4;
	assign o_out_alt4 = (mul  && exception) ? 32'd4 : o_out_alt5;
	assign o_out_alt5 = (div  && exception) ? 32'd5 : o_out_alt6;
	assign o_out_alt6 = setx ? {pc_upper_5, target} : ALU_result;

	assign b_out 		= mx_bypass_B ? o_xm_out 		: b_out_alt;
	assign b_out_alt	= wx_bypass_B ? data_writeReg : regfile_operandB;
	
	assign write_exception = exception && (add | addi | sub | mul | div);
	
endmodule
