module stage_memory(opcode, ALU_result, ALU_operandB, q_dmem, address_dmem, wren, d_dmem, output1);

	input [4:0] opcode;
	input [31:0] q_dmem;
	output [31:0] ALU_result, ALU_operandB, d_dmem;
	output [11:0] address_dmem;
	output wren;
	
	assign output1 = q_dmem;
	assign address_dmem[11:0] = ALU_result[11:0];
	assign dmem_data[31:0] = ALU_operandB[31:0];
	
	memory_controls mc(opcode, wren);
	

endmodule


module memory_controls(opcode, wren);

	input [4:0] opcode;
	output wren;
	
	assign wren = (~opcode[4] & ~opcode[3] & opcode[2] &  opcode[1] &  opcode[0]); 		//sw

endmodule