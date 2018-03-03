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

	wire [4:0] opcode, rd, rs, rt, shamt, ALU_op;
	wire [16:0] immediate;
	wire [26:0] target;
	
	assign opcode 		= q_imem[31:27];
	assign rd 			= q_imem[26:22];
	assign rs 			= q_imem[21:17];
	assign rt 			= q_imem[16:12];
	assign shamt 		= q_imem[11:7];
	assign ALU_op 		= q_imem[6:2];
	assign immediate 	= q_imem[16:0];
	assign target 		= q_imem[26:0];
	
	/************************   Initialize Control Signals & Wires  ****************************/
	
	/* Control Signals */
	wire br, DMwe, ALUinB, Rwd, j, jr, jal;
	
	/* ALU wires */
	wire [31:0] execute_b_out, execute_o_out, memory_o_out, memory_d_out;
	wire take_branch, overflow;
	
	/* PC wire */
	wire [31:0] pc_in, pc_plus_1;
	wire [4:0] pc_upper_5;
	wire enable_pc, enable_fd, enable_dx, enable_xm, enable_mw;
	wire [31:0] pc_out;
	
	wire [31:0] data_writeStatusReg;
	
	controls my_controls(opcode, ALU_op, ctrl_writeEnable, br, DMwe, ALUinB, Rwd, j, jr, jal);
	
	/******************************* Initialize Pipelines **********************************/
	assign enable_pc = 1'b1;
	assign enable_fd = 1'b1;
	assign enable_dx = 1'b1;
	assign enable_xm = 1'b1;
	assign enable_mw = 1'b1;
	
	latch_PC 		lpc(clock, reset, enable_pc, pc_in, pc_out);
	
	
	stage_fetch    fetch(pc_out, address_imem, pc_plus_1, pc_upper_5);
	

	latch_FD			lfd(clock, reset, enable_fd, pc_plus_1, q_imem, pc_fd_out, insn_fd_out);

	
	stage_decode	decode(opcode, ALU_op, rd, rs, rt, ctrl_readRegA, ctrl_readRegB); 

	
	latch_DX			ldx(clock, reset, enable_dx, pc_fd_out, insn_fd_out, pc_dx_out, insn_dx_out, data_readRegA, data_readRegB, a_dx_out, b_dx_out);

	
	stage_execute	execute(opcode, ALU_op, immediate, shamt, target, data_readRegA, data_readRegB, pc_plus_1, pc_upper_5, 

	
	execute_b_out, execute_o_out, take_branch, overflow, pc_in, pc_out);			
	
	
	latch_XM       lxm(clock, reset, enable_xm, insn_dx_out, insn_xm_out, execute_o_out, execute_b_out, o_xm_out, b_xm_out);
	
	
	stage_memory   memory(opcode, o_xm_out, b_xm_out, memory_o_out, memory_d_out, q_dmem, address_dmem, wren, d_dmem);

	
	latch_MW       lmw(clock, reset, enable_mw, insn_xm_out, insn_mw_out, memory_o_out, memory_d_out, o_mx_out, d_mw_out);

	
	stage_write		writeback(opcode, ALU_op, o_mx_out, rd, pc_plus_1, pc_upper_5, target, d_mw_out, 
								overflow, data_writeReg, data_writeStatusReg, ctrl_writeReg);

	
	
	/*************************** Initialize Register File *******************************/

	//	assign data_writeReg = ???
	
	/*****************************    Initialize ALU    *********************************/
	

					


endmodule
