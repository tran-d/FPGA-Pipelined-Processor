module bypass(fd_insn, dx_insn, xm_insn, mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B);

	input [31:0] fd_insn, dx_insn, xm_insn;
	output mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B;
	
	wire [4:0] fd_opcode, dx_opcode, xm_opcode;
	wire [4:0] fd_rs1, fd_rs2, fd_rd, dx_rd, xm_rd;
	wire [4:0] r30, r31;
	
	assign fd_opcode	= fd_insn[31:27];
	assign dx_opcode 	= dx_insn[31:27];
	assign xm_opcode 	= xm_insn[31:27];
	
	assign fd_rs1 	 	= fd_insn[21:17];
	assign fd_rs2		= fd_insn[16:12];
	assign fd_rd 		= fd_insn[26:22];
	assign dx_rd 		= dx_insn[26:22];
	assign xm_rd 		= xm_insn[26:22];
	
	assign r30 = 5'd30;
	assign r31 = 5'd31;
	
	/* Check Equality */
	wire [4:0] fd_rs1_equals_dx_rd, fd_rs2_equals_dx_rd, fd_rs1_equals_xm_rd, fd_rs2_equals_xm_rd, fd_rd_equals_dx_rd, fd_rd_equals_xm_rd,
					fd_rs1_equals_r30, fd_rs2_equals_r30, fd_rd_equals_r30, fd_rs1_equals_r31, fd_rs2_equals_r31, fd_rd_equals_r31;
	genvar i;
	generate
	for(i=0; i<5; i=i+1) begin: loop1
		
		xnor x1(fd_rs1_equals_dx_rd[i], fd_rs1[i], dx_rd[i]);
		xnor x2(fd_rs2_equals_dx_rd[i], fd_rs2[i], dx_rd[i]);
		xnor x3(fd_rs1_equals_xm_rd[i], fd_rs1[i], xm_rd[i]);
		xnor x4(fd_rs2_equals_xm_rd[i], fd_rs2[i], xm_rd[i]);
		xnor x5(fd_rd_equals_dx_rd[i], fd_rd[i], dx_rd[i]);
		xnor x6(fd_rd_equals_xm_rd[i], fd_rd[i], xm_rd[i]);
		
		xnor x7(fd_rs1_equals_r30[i], fd_rs1[i], r30[i]); 
		xnor x8(fd_rs2_equals_r30[i], fd_rs2[i], r30[i]);
		xnor x9(fd_rd_equals_r30[i],  fd_rd[i],  r30[i]);
		
		xnor x10(fd_rs1_equals_r31[i], fd_rs1[i], r31[i]); 
		xnor x11(fd_rs2_equals_r31[i], fd_rs2[i], r31[i]);
		xnor x12(fd_rd_equals_r31[i],  fd_rd[i],  r30[i]);
	
	end
	endgenerate

endmodule