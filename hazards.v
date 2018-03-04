module data_hazard_control(fd_insn, dx_insn, xm_insn, is_data_hazard); // dont need register, can parse itself

	input [31:0] fd_insn, dx_insn, xm_insn;
	output is_data_hazard;
	
	wire [4:0] fd_opcode, dx_opcode, xm_opcode;
	wire fd_only_rs_insn, dx_only_rs_insn, xm_only_rs_insn;
	wire fd_lw_insn, dx_lw_insn, xm_lw_insn;
	wire fd_addi_insn, dx_addi_insn, xm_addi_insn;
	wire fd_r_insn, dx_r_insn, xm_r_insn;
	wire fd_write_insn, dx_write_insn, xm_write_insn;
	wire fd_read_rs_insn, fd_sw_insn, fd_bne_insn, fd_blt_insn, fd_read_rs_rd_insn;
	wire fd_jr_insn, dx_jal_insn, xm_jal_insn;
	wire fd_bex_insn, dx_setx_insn, xm_setx_insn;
	wire [4:0] fd_rs1, fd_rs2, fd_rd, dx_rd, xm_rd;
	
	assign fd_opcode	= fd_insn[31:27];
	assign dx_opcode 	= dx_insn[31:27];
	assign xm_opcode 	= xm_insn[31:27];
	
	// will need to add special case for lw, sw
	assign fd_r_insn 			=  (~fd_opcode[4] & ~fd_opcode[3] & ~fd_opcode[2] & ~fd_opcode[1] & ~fd_opcode[0]); 	// r_insn
	
	assign fd_addi_insn 		=	(~fd_opcode[4] & ~fd_opcode[3] &  fd_opcode[2] & ~fd_opcode[1] &  fd_opcode[0]); 	//00101 addi
	assign fd_lw_insn			=	(~fd_opcode[4] &  fd_opcode[3] & ~fd_opcode[2] & ~fd_opcode[1] & ~fd_opcode[0]);		//01000 lw only check fd_rs1				
	assign fd_read_rs_insn 	= fd_addi_insn | fd_lw_insn;
	 
	assign fd_sw_insn 		=  (~fd_opcode[4] & ~fd_opcode[3] &  fd_opcode[2] &  fd_opcode[1] &  fd_opcode[0]);	//00111 sw only check (lw followed by lw/sw/etc)
	assign fd_bne_insn 		= 	(~fd_opcode[4] & ~fd_opcode[3] & ~fd_opcode[2] &  fd_opcode[1] & ~fd_opcode[0]);	//00010
	assign fd_blt_insn		=  (~fd_opcode[4] & ~fd_opcode[3] &  fd_opcode[2] &  fd_opcode[1] & ~fd_opcode[0]);	//00110
	assign fd_read_rs_rd_insn = fd_sw_insn | fd_bne_insn | fd_blt_insn;
	
	assign fd_jr_insn			=  (~fd_opcode[4] & ~fd_opcode[3] &  fd_opcode[2] & ~fd_opcode[1] & ~fd_opcode[0]);	//00100
	assign fd_bex_insn		=  ( fd_opcode[4] & ~fd_opcode[3] &  fd_opcode[2] &  fd_opcode[1] & ~fd_opcode[0]);
	
	// specials
	// ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];	//00011 jal only check $rstatus
	// ~opcode[4] & ~opcode[3] &  opcode[2] &  opcode[1] &  opcode[0];	//00111 sw only check (lw followed by lw/sw/etc)
	// (~fd_opcode[4] &  fd_opcode[3] & ~fd_opcode[2] & ~fd_opcode[1] & ~fd_opcode[0]) ||	//01000 lw only check fd_rs1
	// opcode[4] & ~opcode[3] &  opcode[2] & ~opcode[1] &  opcode[0];	//10101 setx check if reading from $rstatus 
	
	assign dx_r_insn 			=  (~dx_opcode[4] & ~dx_opcode[3] & ~dx_opcode[2] & ~dx_opcode[1] & ~dx_opcode[0]); 	// r_insn
	assign dx_addi_insn 		=  (~dx_opcode[4] & ~dx_opcode[3] &  dx_opcode[2] & ~dx_opcode[1] &  dx_opcode[0]); 	// addi
	assign dx_lw_insn			=	(~dx_opcode[4] &  dx_opcode[3] & ~dx_opcode[2] & ~dx_opcode[1] & ~dx_opcode[0]);		//01000 lw only check fd_rs1				
	assign dx_write_insn 	=  dx_r_insn || dx_addi_insn || dx_lw_insn;
	
	assign dx_jal_insn		= 	(~dx_opcode[4] & ~dx_opcode[3] & ~dx_opcode[2] &  dx_opcode[1] &  dx_opcode[0]);	//00011 jal only check $r31
	assign dx_setx_insn		=  ( dx_opcode[4] & ~dx_opcode[3] &  dx_opcode[2] & ~dx_opcode[1] &  dx_opcode[0]);	//10110
						
	assign xm_r_insn 			=  (~xm_opcode[4] & ~xm_opcode[3] & ~xm_opcode[2] & ~xm_opcode[1] & ~xm_opcode[0]); 	// r_insn
	assign xm_addi_insn 		=	(~xm_opcode[4] & ~xm_opcode[3] &  xm_opcode[2] & ~xm_opcode[1] &  xm_opcode[0]);		// addit
	assign xm_lw_insn			=	(~xm_opcode[4] &  xm_opcode[3] & ~xm_opcode[2] & ~xm_opcode[1] & ~xm_opcode[0]);		//01000 lw only check fd_rs1				
	assign xm_write_insn 	=  xm_r_insn || xm_addi_insn || xm_lw_insn;	
		
	assign xm_jal_insn		= 	(~xm_opcode[4] & ~xm_opcode[3] & ~xm_opcode[2] &  xm_opcode[1] &  xm_opcode[0]);	//00011 jal only check $r31
	assign xm_setx_insn		=  ( xm_opcode[4] & ~xm_opcode[3] &  xm_opcode[2] & ~xm_opcode[1] &  xm_opcode[0]);	//10110
	
	
	
	assign fd_rs1 	 	= fd_insn[21:17];
	assign fd_rs2		= fd_insn[16:12];
	assign fd_rd 		= fd_insn[26:22];
	assign dx_rd 		= dx_insn[26:22];
	assign xm_rd 		= xm_insn[26:22];
	
	wire [4:0] r30, r31;
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
		xnor x12(fd_rd_equals_r30[i],  fd_rd[i],  r30[i]);
	
	end
	endgenerate
	
	
	wire fd_dx_dhaz_rs_rt, fd_xm_dhaz_rs_rt, fd_dx_dhaz_rs, fd_xm_dhaz_rs, fd_dx_dhaz_r30, fd_xm_dhaz_r30,
			fd_dx_dhaz_r31, fd_xm_dhaz_r31, fd_dx_dhaz_rd_rs, fd_xm_dhaz_rd_rs, fd_dx_dhaz_rd, fd_xm_dhaz_rd;
	
	// RAW for r_insn ($rs , $rt)
	assign fd_dx_dhaz_rs_rt = fd_r_insn && dx_write_insn && ((&fd_rs1_equals_dx_rd[4:0] && |fd_rs1[4:0]) || (&fd_rs2_equals_dx_rd[4:0] && |fd_rs2[4:0]));
	assign fd_xm_dhaz_rs_rt = fd_r_insn && xm_write_insn && ((&fd_rs1_equals_xm_rd[4:0] && |fd_rs1[4:0]) || (&fd_rs2_equals_xm_rd[4:0] && |fd_rs2[4:0]));
	
	// RAW for insn using only $rs
	assign fd_dx_dhaz_rs = fd_read_rs_insn && dx_write_insn && &fd_rs1_equals_dx_rd[4:0] && |fd_rs1[4:0];
	assign fd_xm_dhaz_rs = fd_read_rs_insn && xm_write_insn && &fd_rs1_equals_xm_rd[4:0] && |fd_rs1[4:0];
	
	// RAW for insn using $rs and $rd
	assign fd_dx_dhaz_rd_rs = fd_read_rs_rd_insn && dx_write_insn && ((&fd_rs1_equals_dx_rd[4:0] && |fd_rs1[4:0]) || (&fd_rd_equals_dx_rd[4:0] && |fd_rd[4:0]));
	assign fd_xm_dhaz_rd_rs = fd_read_rs_rd_insn && xm_write_insn && ((&fd_rs1_equals_xm_rd[4:0] && |fd_rs1[4:0]) || (&fd_rd_equals_xm_rd[4:0] && |fd_rd[4:0]));
	
	// RAW for insn using only $rd (jr)
	assign fd_dx_dhaz_rd 	= fd_jr_insn && dx_write_insn && (&fd_rd_equals_dx_rd[4:0] && |fd_rd[4:0]);
	assign fd_xm_dhaz_rd		= fd_jr_insn && xm_write_insn && (&fd_rd_equals_xm_rd[4:0] && |fd_rd[4:0]);
	
	
	// RAW for insn using only $r30
	assign fd_dx_dhaz_r30 	= fd_bex_insn && dx_setx_insn;
	assign fd_xm_dhaz_r30	= fd_bex_insn && xm_setx_insn;
	
	
	// RAW for insn using $r31
	assign fd_dx_dhaz_r31 	= fd_r_insn && dx_jal_insn && ((&fd_rs1_equals_dx_rd[4:0] && fd_rs1_equals_r31) || (&fd_rs2_equals_dx_rd[4:0] && fd_rs2_equals_r31));
	assign fd_xm_dhaz_r31 	= fd_r_insn && xm_jal_insn && ((&fd_rs1_equals_xm_rd[4:0] && fd_rs1_equals_r31) || (&fd_rs2_equals_xm_rd[4:0] && fd_rs2_equals_r31));
	
	
	
	assign is_data_hazard = fd_dx_dhaz_rs_rt | fd_xm_dhaz_rs_rt | fd_dx_dhaz_rs | fd_xm_dhaz_rs |
									fd_dx_dhaz_rd_rs | fd_xm_dhaz_rd_rs |fd_dx_dhaz_rd | fd_xm_dhaz_rd | fd_dx_dhaz_r30 | fd_xm_dhaz_r30;
	
endmodule