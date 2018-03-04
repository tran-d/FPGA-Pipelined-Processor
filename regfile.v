module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	
	
	
   /* YOUR CODE HERE */
	
	wire [31:0] selectedRegisterBits;
	wire [31:0] register_output[31:0];
	wire [31:0] sortedBits[31:0];
	wire [31:0] reg_writeEnable;
	
	
	genvar i;
	genvar j; 
	
	
	/***** create decoder for write_reg *****/						
	decoder5to32 my_decoder(ctrl_writeReg, selectedRegisterBits);
	
	

	generate
	
		for(i=0; i<32; i=i+1) begin: loop1
			
			
		
			/***** create writeEnable for selected write_reg *****/
			and my_and(reg_writeEnable[i], selectedRegisterBits[i], ctrl_writeEnable);
			
			/***** create 32-bit register *****/
			if(i==0)
				reg32_neg myregisterZero(32'b0, clock, ctrl_reset, 1'b0, register_output[i]);
			else
				reg32_neg     myregister(data_writeReg, clock, ctrl_reset, reg_writeEnable[i], register_output[i]);
			
			for(j=0; j<32; j=j+1) begin: transpose
			
				assign sortedBits[i][j] = register_output[j][i];
				
			end
			
			/***** generate 32 muxes (ith mux selects ith bit from all registers) *****/
			mux32_tristate displayRegA(sortedBits[i], ctrl_readRegA, data_readRegA[i]);
			mux32_tristate displayRegB(sortedBits[i], ctrl_readRegB, data_readRegB[i]);
			
		end
		
	endgenerate
	
endmodule

		
