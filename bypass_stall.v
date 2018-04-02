module bypass_stall(fd_insn, dx_insn, is_bypass_hazard); // dont need register, can parse itself

	input [31:0] fd_insn, dx_insn;
	output is_bypass_hazard;
	
	wire [4:0] fd_opcode, dx_opcode;
	wire [4:0] fd_rs1, fd_rs2, dx_rd;
	wire fd_sw_insn, dx_lw_insn;
	
	assign fd_opcode	= fd_insn[31:27];
	assign dx_opcode 	= dx_insn[31:27];
	
	// will need to add special case for lw, sw
	assign fd_sw_insn 		=  (~fd_opcode[4] && ~fd_opcode[3] &&  fd_opcode[2] &&  fd_opcode[1] &&  fd_opcode[0]);	//00111 sw only check (lw followed by lw/sw/etc)
	assign dx_lw_insn			=	(~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0]);		//01000 lw only check fd_rs1				
	
	
	assign fd_rs1 	 	= fd_insn[21:17];
	assign fd_rs2		= fd_insn[16:12];
	assign dx_rd 		= dx_insn[26:22];
	
	
	/* Check Equality */
	wire [4:0] fd_rs1_equals_dx_rd, fd_rs2_equals_dx_rd;

	genvar i;
	generate
	for(i=0; i<5; i=i+1) begin: loop1
		
		xnor x1(fd_rs1_equals_dx_rd[i], fd_rs1[i], dx_rd[i]);
		xnor x2(fd_rs2_equals_dx_rd[i], fd_rs2[i], dx_rd[i]);
	
	end
	endgenerate
	
	assign is_bypass_hazard = dx_lw_insn && (&fd_rs1_equals_dx_rd || &fd_rs2_equals_dx_rd) && fd_sw_insn;
	
			

endmodule