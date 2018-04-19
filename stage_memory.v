module stage_memory(

	// inputs
	clock,
	insn_in, 
	q_dmem, 
	o_in, 
	b_in, 
	wm_bypass,
	data_writeReg,
	
	// outputs
	o_out, 
	d_out, 
	d_dmem, 
	address_dmem, 
	wren
);

	input [31:0] insn_in, q_dmem;					//	q_mem: output of dmem (lw)
	input [31:0] o_in, b_in;						//	ALU_result is used to address into dmem
	input clock, wm_bypass;									// WM BYPASSING
	input [31:0] data_writeReg;
	
	output [31:0] o_out, d_out, d_dmem;			//	d_dmem: data to write to dmem ($rd for sw)
	output [11:0] address_dmem;
	output wren;

	wire [4:0] opcode;
	
	assign opcode 			= insn_in[31:27];
	assign wren 			= ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0]; 		//sw
	assign o_out 			= o_in;
	assign d_out 			= q_dmem;
	assign address_dmem 	= o_in[11:0];
	
	/* WM BYPASSING */
	assign d_dmem 			= wm_bypass ? data_writeReg : b_in;
	
endmodule
