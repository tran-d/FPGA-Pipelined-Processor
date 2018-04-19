module bypass(fd_insn, dx_insn, xm_insn, mw_insn, mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B, wm_bypass);

	input [31:0] fd_insn, dx_insn, xm_insn, mw_insn;
	output mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B, wm_bypass;
	
	wire [4:0] dx_opcode, xm_opcode, mw_opcode, dx_ALU_opcode;
	wire [4:0] fd_rs1, fd_rs2, fd_rd, dx_rd, dx_rs1, dx_rs2, xm_rd, xm_rs1, xm_rs2, mw_rd, mw_rs1;
	wire [4:0] r30, r31;
	
	assign dx_opcode 	= dx_insn[31:27];
	assign xm_opcode 	= xm_insn[31:27];
	assign mw_opcode 	= mw_insn[31:27];
	
	assign dx_ALU_opcode = dx_insn[6:2];
	
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
	assign mw_rd 		= mw_insn[26:22];
	
	assign r30 = 5'd30;
	assign r31 = 5'd31;
	
	/* Check Equality */
	wire [4:0] 	fd_rs1_equals_dx_rd, fd_rs2_equals_dx_rd, fd_rd_equals_dx_rd, 
					fd_rs1_equals_xm_rd, fd_rs2_equals_xm_rd, fd_rd_equals_xm_rd,
					fd_rs1_equals_r30, fd_rs2_equals_r30, fd_rd_equals_r30, 
					fd_rs1_equals_r31, fd_rs2_equals_r31, fd_rd_equals_r31,
					
					dx_rs1_equals_xm_rd, dx_rs2_equals_xm_rd, dx_rd_equals_xm_rd,
					dx_rs1_equals_mw_rd, dx_rs2_equals_mw_rd, dx_rd_equals_mw_rd,
					
					xm_rs1_equals_mw_rd, xm_rs2_equals_mw_rd, xm_rd_equals_mw_rd,
					xm_rd_equals_r30,
					xm_rs1_equals_mw_rs1;
					
	genvar i;
	generate
	for(i=0; i<5; i=i+1) begin: loop1
		
		xnor fd1(fd_rs1_equals_dx_rd[i], fd_rs1[i], dx_rd[i]);
		xnor fd2(fd_rs2_equals_dx_rd[i], fd_rs2[i], dx_rd[i]);
		xnor fd5(fd_rd_equals_dx_rd[i],  fd_rd[i],	 dx_rd[i]);
		xnor fd3(fd_rs1_equals_xm_rd[i], fd_rs1[i], xm_rd[i]);
		xnor fd4(fd_rs2_equals_xm_rd[i], fd_rs2[i], xm_rd[i]);
		xnor fd6(fd_rd_equals_xm_rd[i],  fd_rd[i],	 xm_rd[i]);
		
		xnor fd7(fd_rs1_equals_r30[i], fd_rs1[i], r30[i]); 
		xnor fd8(fd_rs2_equals_r30[i], fd_rs2[i], r30[i]);
		xnor fd9(fd_rd_equals_r30[i],  fd_rd[i],  r30[i]);
		
		xnor fd10(fd_rs1_equals_r31[i], fd_rs1[i], r31[i]); 
		xnor fd11(fd_rs2_equals_r31[i], fd_rs2[i], r31[i]);
		xnor fd12(fd_rd_equals_r31[i],  fd_rd[i],  r30[i]);
		
		xnor dx1(dx_rs1_equals_xm_rd[i], dx_rs1[i], xm_rd[i]);
		xnor dx2(dx_rs2_equals_xm_rd[i], dx_rs2[i], xm_rd[i]);
		xnor dx3(dx_rd_equals_xm_rd[i],  dx_rd[i],  xm_rd[i]);
		
		xnor dx4(dx_rs1_equals_mw_rd[i], dx_rs1[i], mw_rd[i]);
		xnor dx5(dx_rs2_equals_mw_rd[i], dx_rs2[i], mw_rd[i]);
		xnor dx6(dx_rd_equals_mw_rd[i],  dx_rd[i],  mw_rd[i]);
		
		xnor xm1(xm_rs1_equals_mw_rd[i], xm_rs1[i], mw_rd[i]);
		xnor xm2(xm_rs2_equals_mw_rd[i], xm_rs2[i], mw_rd[i]);
		xnor xm3(xm_rd_equals_mw_rd[i],  xm_rd[i],  mw_rd[i]);
		xnor xm4(xm_rd_equals_r30[i],    xm_rd[i],  r30[i]);
		
		xnor xm5(xm_rs1_equals_mw_rs1[i], xm_rs1[i], mw_rs1[i]);
		
	end
	endgenerate
	
	wire dx_r_insn, dx_addi_insn, dx_sw_insn, dx_lw_insn, dx_bne_insn, dx_blt_insn, dx_jr_insn, 
			dx_read_rs_insn, dx_read_rt_insn, dx_read_rd_insn, dx_beq_insn, dx_led_insn, dx_cap_insn;
	wire xm_r_insn, xm_addi_insn, xm_lw_insn, xm_cap_insn, xm_write_insn, xm_sw_insn;
	wire mw_r_insn, mw_addi_insn, mw_lw_insn, mw_cap_insn, mw_write_insn;
	
	assign dx_r_insn 			=  (~dx_opcode[4] && ~dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0]); 	// r_insn
	assign dx_addi_insn 		=  (~dx_opcode[4] && ~dx_opcode[3] &&  dx_opcode[2] && ~dx_opcode[1] &&  dx_opcode[0]); 	// addi
	assign dx_sw_insn 		=  (~dx_opcode[4] && ~dx_opcode[3] &&  dx_opcode[2] &&  dx_opcode[1] &&  dx_opcode[0]);	//00111 sw
	assign dx_lw_insn			=	(~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0]);	//01000 lw only check fd_rs1				
	//assign dx_rand_insn		= 	(~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] &&  dx_opcode[1] && ~dx_opcode[0]);	//01010 random32			
	assign dx_bne_insn 		= 	(~dx_opcode[4] && ~dx_opcode[3] && ~dx_opcode[2] &&  dx_opcode[1] && ~dx_opcode[0]);	//00010
	assign dx_beq_insn 		= 	(~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] &&  dx_opcode[0]);	//01001
	assign dx_blt_insn		=  (~dx_opcode[4] && ~dx_opcode[3] &&  dx_opcode[2] &&  dx_opcode[1] && ~dx_opcode[0]);	//00110
	assign dx_jr_insn			=  (~dx_opcode[4] && ~dx_opcode[3] &&  dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0]);	//00100
	assign dx_led_insn		=	(~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] &&  dx_opcode[1] &&  dx_opcode[0]);	//01011
	assign dx_cap_insn		=  (~dx_opcode[4] &&  dx_opcode[3] &&  dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0]);	//01100
	
	//assign dx_write_insn 	=  dx_r_insn || dx_addi_insn || dx_lw_insn || dx_cap_insn;
	assign dx_read_rs_insn  =  dx_r_insn || dx_addi_insn || dx_lw_insn || dx_sw_insn || dx_bne_insn || dx_blt_insn || dx_beq_insn || dx_led_insn || dx_cap_insn;
	assign dx_read_rt_insn  =  (dx_r_insn && !(!dx_ALU_opcode[4] && !dx_ALU_opcode[3] && dx_ALU_opcode[2] && !dx_ALU_opcode[1]));
	assign dx_read_rd_insn  =  dx_bne_insn || dx_blt_insn || dx_jr_insn || dx_sw_insn || dx_beq_insn || dx_led_insn;
	
	assign xm_r_insn 			=  (~xm_opcode[4] && ~xm_opcode[3] && ~xm_opcode[2] && ~xm_opcode[1] && ~xm_opcode[0]); 	// r_insn
	assign xm_addi_insn 		=	(~xm_opcode[4] && ~xm_opcode[3] &&  xm_opcode[2] && ~xm_opcode[1] &&  xm_opcode[0]);	// addit
	assign xm_lw_insn			=	(~xm_opcode[4] &&  xm_opcode[3] && ~xm_opcode[2] && ~xm_opcode[1] && ~xm_opcode[0]);	//01000 lw only check fd_rs1				
	assign xm_cap_insn		=  (~xm_opcode[4] &&  xm_opcode[3] &&  xm_opcode[2] && ~xm_opcode[1] && ~xm_opcode[0]);	//01100
	//assign xm_rand_insn		= 	(~xm_opcode[4] &&  xm_opcode[3] && ~xm_opcode[2] &&  xm_opcode[1] && ~xm_opcode[0]);	//01010 random32			
	assign xm_write_insn 	=  xm_r_insn || xm_addi_insn || xm_lw_insn || xm_cap_insn;	
	
	assign xm_sw_insn 		=  (~xm_opcode[4] && ~xm_opcode[3] &&  xm_opcode[2] &&  xm_opcode[1] &&  xm_opcode[0]);	//00111 sw
	
	assign mw_r_insn 			=  (~mw_opcode[4] && ~mw_opcode[3] && ~mw_opcode[2] && ~mw_opcode[1] && ~mw_opcode[0]); 	// r_insn
	assign mw_addi_insn 		=	(~mw_opcode[4] && ~mw_opcode[3] &&  mw_opcode[2] && ~mw_opcode[1] &&  mw_opcode[0]);	// addit
	assign mw_lw_insn			=	(~mw_opcode[4] &&  mw_opcode[3] && ~mw_opcode[2] && ~mw_opcode[1] && ~mw_opcode[0]);	//01000 lw only check fd_rs1				
	assign mw_cap_insn		=  (~mw_opcode[4] &&  mw_opcode[3] &&  mw_opcode[2] && ~mw_opcode[1] && ~mw_opcode[0]);	//01100
	//assign mw_rand_insn		= 	(~mw_opcode[4] &&  mw_opcode[3] && ~mw_opcode[2] &&  mw_opcode[1] && ~mw_opcode[0]);	//01010 random32			
	assign mw_write_insn 	=  mw_r_insn || mw_addi_insn || mw_lw_insn || mw_cap_insn;	
	
	
	assign mx_bypass_A 		= dx_read_rs_insn && xm_write_insn && &dx_rs1_equals_xm_rd && |dx_rs1; 							// need r30
	assign wx_bypass_A		= dx_read_rs_insn && mw_write_insn && &dx_rs1_equals_mw_rd && |dx_rs1;							// need r30
	// r_insn ? rt[4:0] : rd[4:0]
	assign mx_bypass_B		= (dx_read_rt_insn && &dx_rs2_equals_xm_rd && |dx_rs2) || (dx_read_rd_insn && &dx_rd_equals_xm_rd && |dx_rd);	// need r30
	assign wx_bypass_B		= (dx_read_rt_insn && &dx_rs2_equals_mw_rd && |dx_rs2) || (dx_read_rd_insn && &dx_rd_equals_mw_rd && |dx_rd);	// need r30
	assign wm_bypass 			= mw_write_insn && xm_sw_insn && &xm_rd_equals_mw_rd && |xm_rd;

endmodule