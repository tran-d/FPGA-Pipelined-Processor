module bypass(fd_insn, dx_insn, xm_insn, mw_insn, mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B, wm_bypass);

	input [31:0] fd_insn, dx_insn, xm_insn, mw_insn;
	output mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B, wm_bypass;
	
	wire [4:0] fd_opcode, dx_opcode, xm_opcode, mw_opcode;
	wire [4:0] fd_rs1, fd_rs2, fd_rd, dx_rd, dx_rs1, dx_rs2, xm_rd, xm_rs1, xm_rs2, mw_rd, mw_rs1, mw_rs2;
	wire [4:0] r30, r31;
	
	assign fd_opcode	= fd_insn[31:27];
	assign dx_opcode 	= dx_insn[31:27];
	assign xm_opcode 	= xm_insn[31:27];
	assign mw_opcode 	= mw_insn[31:27];
	
	assign fd_rs1 	 	= fd_insn[21:17];
	assign fd_rs2		= fd_insn[16:12];
	assign fd_rd 		= fd_insn[26:22];
	
	assign dx_rs1 	 	= dx_insn[21:17];
	assign dx_rs2		= dx_insn[16:12];
	assign dx_rd 		= dx_insn[26:22];
	
	assign xm_rs1 	 	= xm_insn[21:17];
	assign xm_rs2		= xm_insn[16:12];
	assign xm_rd 		= xm_insn[26:22];
	
	assign mw_rs1 	 	= mw_insn[21:17];
	assign mw_rs2		= mw_insn[16:12];
	assign mw_rd 		= mw_insn[26:22];
	
	assign r30 = 5'd30;
	assign r31 = 5'd31;
	
	/* Check Equality */
	wire [4:0] 	fd_rs1_equals_dx_rd, fd_rs2_equals_dx_rd, fd_rd_equals_dx_rd, 
					fd_rs1_equals_xm_rd, fd_rs2_equals_xm_rd, fd_rd_equals_xm_rd,
					fd_rs1_equals_r30, fd_rs2_equals_r30, fd_rd_equals_r30, 
					fd_rs1_equals_r31, fd_rs2_equals_r31, fd_rd_equals_r31,
					
					dx_rs1_equals_xm_rd, dx_rs2_equals_xm_rd,
					dx_rs1_equals_mw_rd, dx_rs2_equals_mw_rd,
					
					xm_rs1_equals_mw_rd, xm_rs2_equals_mw_rd, xm_rd_equals_mw_rd,
					xm_rs1_equals_mw_rs1;
					
	genvar i;
	generate
	for(i=0; i<5; i=i+1) begin: loop1
		
		xnor x1(fd_rs1_equals_dx_rd[i], fd_rs1[i], dx_rd[i]);
		xnor x2(fd_rs2_equals_dx_rd[i], fd_rs2[i], dx_rd[i]);
		xnor x5(fd_rd_equals_dx_rd[i],  fd_rd[i],	 dx_rd[i]);
		xnor x3(fd_rs1_equals_xm_rd[i], fd_rs1[i], xm_rd[i]);
		xnor x4(fd_rs2_equals_xm_rd[i], fd_rs2[i], xm_rd[i]);
		xnor x6(fd_rd_equals_xm_rd[i],  fd_rd[i],	 xm_rd[i]);
		
		xnor x7(fd_rs1_equals_r30[i], fd_rs1[i], r30[i]); 
		xnor x8(fd_rs2_equals_r30[i], fd_rs2[i], r30[i]);
		xnor x9(fd_rd_equals_r30[i],  fd_rd[i],  r30[i]);
		
		xnor x10(fd_rs1_equals_r31[i], fd_rs1[i], r31[i]); 
		xnor x11(fd_rs2_equals_r31[i], fd_rs2[i], r31[i]);
		xnor x12(fd_rd_equals_r31[i],  fd_rd[i],  r30[i]);
		
		xnor x13(dx_rs1_equals_xm_rd[i], dx_rs1[i], xm_rd[i]);
		xnor x14(dx_rs2_equals_xm_rd[i], dx_rs2[i], xm_rd[i]);
		
		xnor x16(dx_rs1_equals_mw_rd[i], dx_rs1[i], mw_rd[i]);
		xnor x17(dx_rs2_equals_mw_rd[i], dx_rs2[i], mw_rd[i]);
		
		xnor x18(xm_rs1_equals_mw_rd[i], xm_rs1[i], mw_rd[i]);
		xnor x19(xm_rs2_equals_mw_rd[i], xm_rs2[i], mw_rd[i]);
		xnor x20(xm_rd_equals_mw_rd[i],  xm_rd[i],  mw_rd[i]);
		
		xnor x21(xm_rs1_equals_mw_rs1[i], xm_rs1[i], mw_rs1[i]);
		
	end
	endgenerate
	
	wire dx_r_insn, dx_addi_insn, dx_lw_insn, dx_write_insn;
	wire xm_r_insn, xm_addi_insn, xm_lw_insn, xm_write_insn, xm_sw_insn;
	wire mw_r_insn, mw_addi_insn, mw_lw_insn, mw_write_insn;
	
	assign dx_r_insn 			=  (~dx_opcode[4] && ~dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0]); 	// r_insn
	assign dx_addi_insn 		=  (~dx_opcode[4] && ~dx_opcode[3] &&  dx_opcode[2] && ~dx_opcode[1] &&  dx_opcode[0]); 	// addi
	assign dx_lw_insn			=	(~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0]);	//01000 lw only check fd_rs1				
	assign dx_write_insn 	=  dx_r_insn || dx_addi_insn || dx_lw_insn;
					
	assign xm_r_insn 			=  (~xm_opcode[4] && ~xm_opcode[3] && ~xm_opcode[2] && ~xm_opcode[1] && ~xm_opcode[0]); 	// r_insn
	assign xm_addi_insn 		=	(~xm_opcode[4] && ~xm_opcode[3] &&  xm_opcode[2] && ~xm_opcode[1] &&  xm_opcode[0]);	// addit
	assign xm_lw_insn			=	(~xm_opcode[4] &&  xm_opcode[3] && ~xm_opcode[2] && ~xm_opcode[1] && ~xm_opcode[0]);	//01000 lw only check fd_rs1				
	assign xm_write_insn 	=  xm_r_insn || xm_addi_insn || xm_lw_insn;	
	
	assign xm_sw_insn 		=  (~xm_opcode[4] && ~xm_opcode[3] &&  xm_opcode[2] &&  xm_opcode[1] &&  xm_opcode[0]);	//00111 sw
	
	assign mw_r_insn 			=  (~mw_opcode[4] && ~mw_opcode[3] && ~mw_opcode[2] && ~mw_opcode[1] && ~mw_opcode[0]); 	// r_insn
	assign mw_addi_insn 		=	(~mw_opcode[4] && ~mw_opcode[3] &&  mw_opcode[2] && ~mw_opcode[1] &&  mw_opcode[0]);	// addit
	assign mw_lw_insn			=	(~mw_opcode[4] &&  mw_opcode[3] && ~mw_opcode[2] && ~mw_opcode[1] && ~mw_opcode[0]);	//01000 lw only check fd_rs1				
	assign mw_write_insn 	=  mw_r_insn || mw_addi_insn || mw_lw_insn;	
	
	//assign mx_bypass_A =  
	assign wm_bypass 		= mw_write_insn && xm_sw_insn && &xm_rd_equals_mw_rd;

endmodule