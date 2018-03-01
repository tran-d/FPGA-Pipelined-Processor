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
		
		
	execute_controls ec(opcode, ALU_op, immediate, regfile_operandA, regfile_operandB, ALU_operandA, ALU_operandB);
		
	alu my_alu(ALU_operandA, ALU_operandB, ALU_op, shamt, ALU_result, isNotEqual, isLessThan, overflow);
					
	
	assign take_branch = isNotEqual;
	


endmodule

module execute_controls(opcode, ALU_op, immediate, regfile_operandA, regfile_operandB, ALU_operandA, ALU_operandB);

	input [4:0] opcode, ALU_op;
	input [31:0] regfile_operandA, regfile_operandB; 
	input [16:0] immediate;
	output [31:0] ALU_operandA, ALU_operandB;
	
	wire immed_insn;
	wire [31:0] immediate_ext;
	
	signextender_16to32 my_se(immediate, immediate_ext);
	
	assign immed_insn =  (~opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0]) || // addi
								(~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0]) || // sw
								(~opcode[4] &  opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0]);   // lw
	
	
	assign ALU_operandA = regfile_operandA[31:0];
	assign ALU_operandB = immed_insn ? immediate_ext : regfile_operandB;


endmodule


module branch_controls();

	// complete bne, bex, blt
	// compute take_branch 
	// PC+1 or PC = T

endmodule