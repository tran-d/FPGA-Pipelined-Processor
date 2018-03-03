module stage_memory(opcode, o_in, b_in, o_out, d_out, q_dmem, address_dmem, wren, d_dmem);

	input [4:0] opcode;
	input [31:0] q_dmem;								//	q_mem: output of dmem (lw)
	input [31:0] o_in, b_in;						//	ALU_result is used to address into dmem
	
	output [31:0] d_dmem, o_out, d_out;							//	d_dmem: data to write to dmem ($rd for sw)
	output [11:0] address_dmem;
	output wren;
	
	assign d_out = q_dmem;
	assign o_out = o_in;
	assign address_dmem = o_in[11:0];
	assign d_dmem = b_in;
	
	memory_controls mc(opcode, wren);
	

endmodule


module memory_controls(opcode, wren);

	input [4:0] opcode;
	output wren;
	
	assign wren = (~opcode[4] & ~opcode[3] & opcode[2] &  opcode[1] &  opcode[0]); 		//sw

endmodule