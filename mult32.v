module mult32(ctrl_MULT, multiplicand, multiplier, clock, data_result, data_exception, data_resultRDY);

	input [31:0] multiplicand, multiplier;
	input ctrl_MULT, clock;

	output [31:0] data_result;
	output data_exception, data_resultRDY;
	
	/* FOR TESTING */
	wire [64:0] product;
	wire [4:0] counter_bits;
	wire [31:0] adder_result, adder_operandB;
	
	genvar i;

	wire [31:0]	not_multiplicand, not_shift_left_multiplicand, shift_left_multiplicand;
	wire [32:0] reg_in;
	
	// SET REGS
//	my_register32 multiplicandReg(data_operandA, clock, !ctrl_MULT, ctrl_MULT, multiplicand);
//	my_register32 multiplierReg  (data_operandB, clock, !ctrl_MULT, ctrl_MULT, multiplier);
	
	// DEFINE BOOTH CASES
	wire bit0, bit1, bit2, notbit0, notbit1, notbit2;
	wire enable, reset, ovf, cin;
	wire do_nothing, subM, addM, subRSM, addRSM;
	
	// DEFINE CONTROL BITS
	assign bit0 = product[0];
	assign bit1 = product[1];
	assign bit2 = product[2];
	assign notbit0 = ~product[0];
	assign notbit1 = ~product[1];
	assign notbit2 = ~product[2];
	
	
	assign do_nothing = (notbit2 && notbit1 && notbit0) || (bit2    && bit1    && bit0);
	assign subM 		= (bit2    && bit1    && notbit0) || (bit2    && notbit1 && bit0);
	assign addM  		= (notbit2 && bit1    && notbit0) || (notbit2 && notbit1 && bit0);
	assign subRSM  	= (bit2    && notbit1 && notbit0);
	assign addRSM		= (notbit2 && bit1    && bit0   );
	
	
	// SET MULT BITS
	generate
		for(i=31; i>0; i=i-1) begin: loop1
			assign shift_left_multiplicand[i] = multiplicand[i-1];
		end
	endgenerate
	assign shift_left_multiplicand[0] = 1'b0;
	generate
		for(i=0; i<32; i=i+1) begin: loop2
			assign not_multiplicand[i] = ~multiplicand[i];
			assign not_shift_left_multiplicand[i] = ~shift_left_multiplicand[i];
		end
	endgenerate
	
	
	// CREATE FOUR ADDERS FOR FOUR CASES
	wire [31:0] adder1, adder2, adder3, adder4;
	wire dovf1, dovf2, dovf3, dovf4, dne1, dne2, dne3, dne4, dlt1, dlt2, dlt3, dlt4;
	
	adder32 my_subRSM   (adder_operandB, not_shift_left_multiplicand, 1'b1, adder1, dovf1, dne1, dlt1);
	adder32 my_subM     (adder_operandB, not_multiplicand, 				1'b1, adder2, dovf2, dne2, dlt2);
	adder32 my_addRSM   (adder_operandB, shift_left_multiplicand, 		1'b0, adder3, dovf3, dne3, dlt3);
	adder32 my_addM     (adder_operandB, multiplicand, 					1'b0, adder4, dovf4, dne4, dlt4);
	
	tristate_buffer32 my_tb1(adder1, 		 			subRSM, 	   adder_result);
	tristate_buffer32 my_tb2(adder2, 		 			subM,        adder_result);
	tristate_buffer32 my_tb3(adder3, 		 			addRSM, 	   adder_result);
	tristate_buffer32 my_tb4(adder4, 		 			addM, 		   adder_result);
	tristate_buffer32 my_tb5(adder_operandB,      do_nothing,  adder_result);
	
	
//	assign adder_operandA = subM ? not_multiplicand : ( subRSM ? not_shift_left_multiplicand : (addM ? multiplicand : (addRSM ? shift_left_multiplicand : {32{1'b0}} )));
	assign adder_operandB = product[64:33];
	
	wire reg64_select, counter_reset, counter_ena, shift_ena;
//	wire [4:0] counter_bits;
	assign reg64_select  =  counter_bits[0] ||  counter_bits[1] ||  counter_bits[2] ||  counter_bits[3] || counter_bits[4];
//	assign counter_reset =  ctrl_MULT;
	assign counter_ena   = ~data_resultRDY;
	assign shift_ena     =  counter_bits[0] ||  counter_bits[1] ||  counter_bits[2] ||  counter_bits[3] || counter_bits[4];
	assign enable 		   = ~data_resultRDY;
	
	adder_counter16 my_counter16(clock, ctrl_MULT, counter_ena, counter_bits);
	
	
	mux2to1_33 mymux({multiplier, 1'b0} , product[32:0], reg64_select, reg_in);
	
	reg65_sr2 my_sr65({adder_result, reg_in}, clock, ctrl_MULT, enable, shift_ena, product);

	// DEFINE RESULT & READY
	assign data_result = product[32:1];
	assign data_resultRDY = counter_bits[4] && ~counter_bits[3] && ~counter_bits[2] && ~counter_bits[1] && counter_bits[0];
	
	
	// DEFINE DATA_EXCEPTION
	assign data_exception = (product[32] ^ &product[64:33]) || (product[32] ^ |product[64:33]);
	
	

endmodule