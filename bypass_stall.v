module bypass_stall(clock, fd_insn, dx_insn, writeback_insn, multdiv_RDY, is_bypass_hazard, latch_ena);

	input [31:0] fd_insn, dx_insn, writeback_insn;
	input clock, multdiv_RDY;
	output is_bypass_hazard, latch_ena;
	
	wire [4:0] fd_rs1, fd_rs2, dx_rd, dx_opcode, dx_ALU_op, fd_rs1_equals_dx_rd, fd_rs2_equals_dx_rd;
	wire dx_r_insn, dx_lw_insn, dx_mul_insn, dx_div_insn, lw_hazard, multdiv_hazard;
	
	assign fd_rs1 	 		= fd_insn[21:17];
	assign fd_rs2			= fd_insn[16:12];
	assign dx_rd 			= dx_insn[26:22];
	assign dx_opcode 		= dx_insn[31:27];
	assign dx_ALU_op 		= dx_insn[6:2];
	assign dx_r_insn 		= ~dx_opcode[4] && ~dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0];
	assign dx_lw_insn		= ~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0];					//01000 lw only check fd_rs1					
	assign dx_mul_insn 	= dx_r_insn && (~dx_ALU_op[4] && ~dx_ALU_op[3] &&  dx_ALU_op[2] &&  dx_ALU_op[1] && ~dx_ALU_op[0]);	// 00000 & 00110
	assign dx_div_insn 	= dx_r_insn && (~dx_ALU_op[4] && ~dx_ALU_op[3] &&  dx_ALU_op[2] &&  dx_ALU_op[1] &&  dx_ALU_op[0]);	// 00000 & 00111
					
	assign lw_hazard 			= dx_lw_insn && (&fd_rs1_equals_dx_rd || &fd_rs2_equals_dx_rd);
	assign is_bypass_hazard = lw_hazard || multdiv_hazard ; 							// && !fd_sw_insn;
	
	
	/* MULTIPLIER */
	
	reg wait_multdiv_RDY;
	
	initial begin
		wait_multdiv_RDY <= 1'b0;
	end
	
	always @(negedge clock)
	begin
	if (dx_mul_insn || dx_div_insn) 
		wait_multdiv_RDY <= 1'b1;
	else if (wait_multdiv_RDY && multdiv_RDY)
		wait_multdiv_RDY <= 1'b0;
	end
	
	assign multdiv_hazard = wait_multdiv_RDY && ~multdiv_RDY;
	
//	dflipflop my_dff1(~mul);
//	dflipflop my_dff2();
	
	
	genvar i;
	generate
	for(i=0; i<5; i=i+1) begin: loop1
		
		xnor x1(fd_rs1_equals_dx_rd[i], fd_rs1[i], dx_rd[i]);
		xnor x2(fd_rs2_equals_dx_rd[i], fd_rs2[i], dx_rd[i]);
	
	end
	endgenerate
	
	/* Latch Enable bits */
	
    wire [4:0] w_opcode, w_ALU_op;
	wire w_r_insn, w_mul_insn, w_div_insn;
    
	assign w_opcode = writeback_insn[31:27];
    assign w_ALU_op = writeback_insn[6:2];
    assign w_r_insn 	= ~w_opcode[4] && ~w_opcode[3] && ~w_opcode[2] && ~w_opcode[1] && ~w_opcode[0];
    assign w_mul_insn 	=  w_r_insn && (~w_ALU_op[4] && ~w_ALU_op[3] &&  w_ALU_op[2] &&  w_ALU_op[1] && ~w_ALU_op[0]);	// 00000 & 00110
	assign w_div_insn 	=  w_r_insn && (~w_ALU_op[4] && ~w_ALU_op[3] &&  w_ALU_op[2] &&  w_ALU_op[1] &&  w_ALU_op[0]);	// 00000 & 00111
	
    reg latch_ena_reg; 
    always @(negedge clock)
	begin
        latch_ena_reg = ~((w_mul_insn || w_div_insn) && ~multdiv_RDY);
	end 
    
    assign latch_ena = latch_ena_reg;
	
endmodule