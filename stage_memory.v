module stage_memory(opcode, ALU_result, ALU_operandB, q_dmem, address_dmem, wren, d_dmem);

	input [4:0] opcode;
	input [31:0] q_dmem;								//	q_mem: output of dmem (lw)
	input [31:0] ALU_result, ALU_operandB;		//	ALU_result is used to address into dmem
	output [31:0] d_dmem;							//	d_dmem: data to write to dmem ($rd for sw)
	output [11:0] address_dmem;
	output wren;
	
	
	assign address_dmem[11:0] = ALU_result[11:0];
	assign d_dmem[31:0] = ALU_operandB[31:0];
	
	memory_controls mc(opcode, wren);
	

endmodule


module memory_controls(opcode, wren);

	input [4:0] opcode;
	output wren;
	
	assign wren = (~opcode[4] & ~opcode[3] & opcode[2] &  opcode[1] &  opcode[0]); 		//sw

endmodule