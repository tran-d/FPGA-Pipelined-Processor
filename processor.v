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
	output [11:0] address_imem;      
	input [31:0] q_imem;

	// Dmem
	output [11:0] address_dmem;		
	output [31:0] d_dmem;				
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	
	/************************   Initialize Control Signals & Wires  ****************************/
	
	wire [4:0]  pc_upper_5;
	wire [31:0] pc_in, pc_out, execute_pc_out, pc_fd_out, pc_dx_out;
	wire [31:0] nop;
	wire [31:0] insn_fd_out, insn_dx_out, insn_mw_out, insn_xm_out;
	wire [31:0] a_dx_out, b_dx_out, o_xm_out, b_xm_out, o_mw_out, d_mw_out;
	wire [31:0] execute_b_out, execute_o_out, memory_o_out, memory_d_out;
	wire [31:0] insn_fd_in, insn_dx_in;
	
	wire exec_write_exception, xm_write_exception, mw_write_exception;
	wire is_bypass_hazard, branched_jumped;
	wire mx_bypass_A, mx_bypass_B, wx_bypass_A, wx_bypass_B, wm_bypass;

	assign nop = 32'd0;
	
	/* flushing */
	assign insn_fd_in = branched_jumped 								? nop : q_imem;
	assign insn_dx_in = (branched_jumped | is_bypass_hazard ) 	? nop	: insn_fd_out;
	
	
	/******************************* Initialize Pipelines **********************************/
	
	latch_PC lpc(
			// inputs
			.clock 						(clock), 
			.reset 						(reset), 
			.enable 						(~is_bypass_hazard), 
			.pc_in						(pc_in), 
			
			// outputs
			.pc_out						(pc_out)
	);
	
	stage_fetch		fetch(
			// inputs
			.pc_in						(pc_out), 
			.execute_pc_out			(execute_pc_out), 
			.branched_jumped			(branched_jumped), 
			
			// outputs
			.pc_out						(pc_in),
			.pc_upper_5					(pc_upper_5),
			.address_imem				(address_imem)
	);
	
	latch_FD		lfd(
			// inputs
			.clock						(clock),
			.reset						(reset), 
			.enable						(~is_bypass_hazard), 
			.pc_in						(pc_out),
			.insn_in						(insn_fd_in),
			
			// outputs
			.pc_out						(pc_fd_out), 
			.insn_out					(insn_fd_out)
	);
	
	stage_decode	decode(
			// inputs
			.insn_in						(insn_fd_out), 
			.ctrl_readRegA				(ctrl_readRegA), 
			.ctrl_readRegB 			(ctrl_readRegB)
			
			// outputs already in top-level
	);
	
	latch_DX ldx(
			// inputs
			.clock						(clock), 
			.reset 						(reset), 
			.enable						(1'b1), 
			.pc_in 						(pc_fd_out), 
			.insn_in						(insn_dx_in),	
			.a_in							(data_readRegA), 
			.b_in							(data_readRegB), 
			
			// outputs
			.pc_out						(pc_dx_out),
			.insn_out					(insn_dx_out), 
			.a_out						(a_dx_out), 
			.b_out						(b_dx_out)
	);
	
	stage_execute execute(
			// inputs
			.insn_in						(insn_dx_out), 
			.regfile_operandA			(a_dx_out), 
			.regfile_operandB			(b_dx_out), 
			.pc_upper_5					(pc_upper_5), 
			.pc_out						(pc_dx_out), 
			.mx_bypass_A				(mx_bypass_A), 
			.wx_bypass_A				(wx_bypass_A),  
			.mx_bypass_B				(mx_bypass_B), 
			.wx_bypass_B				(wx_bypass_B),	
			.o_xm_out					(o_xm_out),			// O value from XM latch output
			.data_writeReg				(data_writeReg),	
			
			// outputs
			.o_out						(execute_o_out), 
			.b_out						(execute_b_out), 
			.write_exception			(exec_write_exception), 
			.pc_in						(execute_pc_out), 
			.branched_jumped			(branched_jumped)
	);			
	
	
	latch_XM lxm(
			// inputs
			.clock						(clock), 
			.reset						(reset), 
			.enable						(1'b1), 
			.insn_in						(insn_dx_out),
			.o_in							(execute_o_out), 
			.b_in							(execute_b_out), 	
			.write_exception_in		(exec_write_exception), 
			
			// outputs
			.insn_out					(insn_xm_out), 
			.o_out						(o_xm_out), 
			.b_out						(b_xm_out),
			.write_exception_out		(xm_write_exception)
			
	);
	
	stage_memory memory(
			// inputs
			.insn_in						(insn_xm_out), 
			.q_dmem						(q_dmem), 
			.o_in							(o_xm_out), 
			.b_in							(b_xm_out), 
			.wm_bypass					(wm_bypass), 
			.data_writeReg				(data_writeReg),
			
			// outputs
			.d_dmem						(d_dmem), 
			.o_out						(memory_o_out), 
			.d_out						(memory_d_out), 
			.address_dmem				(address_dmem), 
			.wren							(wren)
	);

	latch_MW lmw(
			// inputs
			.clock						(clock), 
			.reset						(reset), 
			.enable						(1'b1), 
			.insn_in						(insn_xm_out), 
			.o_in							(memory_o_out), 
			.d_in							(memory_d_out), 
			.write_exception_in		(xm_write_exception), 
			 
			// outputs
			.insn_out					(insn_mw_out), 
			.o_out						(o_mw_out), 
			.d_out						(d_mw_out),
			.write_exception_out		(mw_write_exception)
	);

	stage_write writeback(
			// inputs
			.insn_in						(insn_mw_out), 
			.o_in							(o_mw_out), 
			.d_in							(d_mw_out), 
			.write_exception			(mw_write_exception), 			
			
			// outputs			
			.data_writeReg				(data_writeReg), 
			.ctrl_writeReg				(ctrl_writeReg), 
			.ctrl_writeEnable			(ctrl_writeEnable)
	);
	
	bypass 	my_bypass(
			// inputs 
			.fd_insn						(insn_fd_out), 
			.dx_insn						(insn_dx_out), 
			.xm_insn						(insn_xm_out), 
			.mw_insn						(insn_mw_out),
		
			// outputs
			.mx_bypass_A				(mx_bypass_A), 
			.mx_bypass_B				(mx_bypass_B), 
			.wx_bypass_A				(wx_bypass_A), 
			.wx_bypass_B				(wx_bypass_B), 
			.wm_bypass					(wm_bypass)
	);
	
	//data_hazard_control dhc(insn_fd_out, insn_dx_out, insn_xm_out, data_hazard);
	bypass_stall 	my_bypass_stall(
			// inputs
			.fd_insn						(insn_fd_out), 
			.dx_insn						(insn_dx_out), 
			
			// outputs
			.is_bypass_hazard			(is_bypass_hazard)
	);
	

endmodule
