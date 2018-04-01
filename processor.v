/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as processor.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    d_dmem,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
	// Control signals
	input clock, reset;

	// Imem
	output [11:0] address_imem;      /*no driver*/
	input [31:0] q_imem;

	// Dmem
	output [11:0] address_dmem;		/*no driver*/
	output [31:0] d_dmem;					/*no driver*/
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;		/*no driver*/
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

	wire [4:0] opcode;
//	wire [4:0] rd, rs, rt, shamt, ALU_op;
//	wire [16:0] immediate;
//	wire [26:0] target;
//	
	assign opcode 		= q_imem[31:27];
//	assign rd 			= q_imem[26:22];
//	assign rs 			= q_imem[21:17];
//	assign rt 			= q_imem[16:12];
//	assign shamt 		= q_imem[11:7];
//	assign ALU_op 		= q_imem[6:2];
//	assign immediate 	= q_imem[16:0];
//	assign target 		= q_imem[26:0];
	
	/************************   Initialize Control Signals & Wires  ****************************/
	
	/* Control Signals */
	wire br, DMwe, ALUinB, Rwd, j, jr, jal;
	
	/* ALU wires */
	wire [31:0] execute_b_out, execute_o_out, memory_o_out, memory_d_out;
	wire take_branch, overflow;
	
	/* PC wire */
	wire [31:0] pc_in, pc_out, exec_pc_out;
	wire [4:0] pc_upper_5;
	wire enable_pc, enable_fd, enable_dx, enable_xm, enable_mw, j_took_branch;
	
	wire [31:0] data_writeStatusReg;
	
	
	/******************************* Initialize Pipelines **********************************/
	// assign enable_pc = 1'b1;
	// assign enable_fd = 1'b1;
	assign enable_dx = 1'b1;
	assign enable_xm = 1'b1;
	assign enable_mw = 1'b1;
	
	wire [31:0] pc_fd_out, pc_dx_out;
	wire [31:0] insn_fd_out, insn_dx_out, insn_mw_out, insn_xm_out;
	wire [31:0] a_dx_out, b_dx_out, o_xm_out, b_xm_out, o_mw_out, d_mw_out;
	wire exec_write_exception, xm_write_exception, mw_write_exception;
	wire data_hazard;
	/* BYPASS */
	wire mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B, wm_bypass;
	
	//assign pc_in = take_branch
	latch_PC 		lpc(clock, reset, ~data_hazard, pc_in, pc_out);
	
	
	stage_fetch    fetch(pc_out, exec_pc_out, j_took_branch, address_imem, pc_upper_5, pc_in);

	wire [31:0] insn_fd_in;
	assign insn_fd_in = j_took_branch ? 32'd0 : q_imem;
	
	latch_FD			lfd(clock, reset, ~data_hazard, pc_out, insn_fd_in, pc_fd_out, insn_fd_out);
	
	stage_decode	decode(insn_fd_out, ctrl_readRegA, ctrl_readRegB); 

	
	wire [31:0] insn_dx_in;
	wire [31:0] pc_dx_out1;
	assign insn_dx_in = (j_took_branch | data_hazard ) ? 32'd0 : insn_fd_out;
	latch_DX			ldx(clock, reset, enable_dx, pc_fd_out, insn_dx_in, pc_dx_out, insn_dx_out, data_readRegA, data_readRegB, a_dx_out, b_dx_out);

	
	stage_execute	execute(insn_dx_out, a_dx_out, b_dx_out, pc_upper_5, pc_dx_out, 		// inputs
								execute_o_out, execute_b_out, take_branch, exec_write_exception, exec_pc_out, j_took_branch);			// outputs
	

	latch_XM       lxm(clock, reset, enable_xm, exec_write_exception, xm_write_exception, insn_dx_out, insn_xm_out, execute_o_out, execute_b_out, o_xm_out, b_xm_out);
	

	stage_memory   memory(insn_xm_out, q_dmem, o_xm_out, b_xm_out, memory_o_out, memory_d_out, d_dmem, address_dmem, wren, wm_bypass, data_writeReg);

	
	latch_MW       lmw(clock, reset, enable_mw, xm_write_exception, mw_write_exception, insn_xm_out, insn_mw_out, memory_o_out, memory_d_out, o_mw_out, d_mw_out);


	stage_write		writeback(insn_mw_out, o_mw_out, d_mw_out, mw_write_exception, 			// inputs
									data_writeReg, ctrl_writeReg, ctrl_writeEnable);		// outputs
	
	
	/* Data Hazards */
	//data_hazard_control dhc(insn_fd_out, insn_dx_out, insn_xm_out, data_hazard);
	bypass_stall 	bs(insn_fd_out, insn_dx_out, data_hazard);
	bypass 			b(insn_fd_out, insn_dx_out, insn_xm_out, insn_mw_out, mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B, wm_bypass);
	

endmodule
