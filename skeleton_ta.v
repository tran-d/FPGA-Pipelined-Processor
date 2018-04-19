/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module skeleton_ta(
    // Inputs
    input  wire         clock,
    input  wire         reset,
    // Instruction Memory
    output wire [11:0]  address_imem,
    output wire [31:0]  q_imem,
    // Data Memory
    output wire [11:0]  address_dmem,
    output wire [31:0]  d_dmem,
    output wire         wren_dmem,
    output wire [31:0]  q_dmem,
    // Regfile
    output wire         ctrl_writeEnable,
    output wire [4:0]   ctrl_writeReg,
    output wire [4:0]   ctrl_readRegA,
    output wire [4:0]   ctrl_readRegB,
    output wire [31:0]  data_writeReg,
    output wire [31:0]  data_readRegA,
    output wire [31:0]  data_readRegB
);

    /** IMEM **/
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data	    (d_dmem),    // data you want to write
        .wren	    (wren_dmem),      // write enable
        .q          (q_dmem)    // data from dmem
    );

    /** REGFILE **/
    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        d_dmem,                         // O: The data to write to dmem
        wren_dmem,                           // O: Write enable for dmem
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
	 
	 wire [31:0] data_result;
	 wire data_exception, data_resultRDY;
	 
	multdiv my_multdiv(32'd0, 32'd0, 1'b0, 1'b0, clock, data_result, data_exception, data_resultRDY);
   

endmodule
