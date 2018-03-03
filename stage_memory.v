module stage_memory(insn, q_dmem, o_in, b_in, o_out, d_out, d_dmem, address_dmem, wren);

	input [31:0] insn, q_dmem;						//	q_mem: output of dmem (lw)
	input [31:0] o_in, b_in;						//	ALU_result is used to address into dmem
	
	output [31:0] o_out, d_out, d_dmem;			//	d_dmem: data to write to dmem ($rd for sw)
	output [11:0] address_dmem;
	output wren;
	
	
	assign o_out = o_in;
	assign d_out = q_dmem;
	
	assign address_dmem = o_in[11:0];
	assign d_dmem = b_in;
	
	wire [4:0] opcode;
	assign opcode 	= insn[31:27];
	assign wren = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0]; 		//sw


endmodule