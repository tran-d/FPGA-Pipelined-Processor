module div32(ctrl_DIV, data_operandA, data_operandB, clock, data_result, data_exception, data_resultRDY);

	input [31:0] data_operandA, data_operandB;
	input ctrl_DIV, clock;

	output [31:0] data_result;
	output data_exception, data_resultRDY;
	
	/* FOR TESTING */
	wire [63:0] RQB;
	wire [31:0] adder_result;
	wire RQB_lt_Divisor;
	wire [31:0] remainder, not_divisor, divisor, reg_in_upper, reg_in_lower, dividend, quotient, 
					tc_dividend, tc_divisor, tc_quotient, dividend_pn, divisor_pn;
	wire [5:0] counter_bits;
	wire enable, counter_ena, reset, shift_ena, reg64_select, dummy_result, dummy_lt, ab_opp;
	
	assign data_result = ab_opp ? tc_quotient : quotient;
	assign data_resultRDY = counter_bits[5] && ~counter_bits[4] && ~counter_bits[3] && ~counter_bits[2] && counter_bits[1] && ~counter_bits[0];
	assign data_exception = (data_result[31] ^ ab_opp) && |data_result[31:0];
	
	wire ovf, ne;

	// SUBTRACT REMAINDER - DIVISOR
	adder32 my_adder32(RQB[63:32], not_divisor, 1'b1, adder_result, ovf, ne, RQB_lt_Divisor);
	
	// choose whether to overwrite RQB_upper with adder_result, dividend, or itself
	mux2to1_32 mymux_upper(RQB[63:32], adder_result, ~RQB_lt_Divisor, reg_in_upper);
	mux2to1_32 mymux_lower(dividend,   RQB[31:0],     reg64_select,   reg_in_lower);
	
	// INSERT DATA INTO REGISTER
	reg64_sl1 my_RQB({reg_in_upper, reg_in_lower}, ~RQB_lt_Divisor, clock, reset, enable, shift_ena, RQB);
	
	
	// SETUP CONTROL BITS
	assign enable 			= !counter_bits[5] || !counter_bits[4] || !counter_bits[3] || !counter_bits[2] || !counter_bits[1] || !counter_bits[0];
	assign reg64_select  =  counter_bits[5] ||  counter_bits[4] ||  counter_bits[3] ||  counter_bits[2] ||  counter_bits[1] ||  counter_bits[0];
	assign reset			=  ctrl_DIV;
	assign counter_ena   = ~data_resultRDY;
	assign shift_ena		=  counter_bits[5] ||  counter_bits[4] ||  counter_bits[3] ||  counter_bits[2] ||  counter_bits[1] ||  counter_bits[0];
	adder_counter32 my_counter(clock, reset, counter_ena, counter_bits);
	
	assign ab_opp = data_operandA[31] ^ data_operandB[31];
	
	
	// NEGATION & TWOS COMPLEMENT
	twos_complement32 dividendTC(data_operandA, tc_dividend);
	twos_complement32 divisorTC (data_operandB, tc_divisor);
	twos_complement32 quotientTC(RQB[31:0],	  tc_quotient);
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loop1
		
			assign dividend[i]	 = data_operandA[31] ?  tc_dividend[i] : data_operandA[i];
			assign divisor[i]		 = data_operandB[i];
			assign not_divisor[i] = data_operandB[31] ? ~tc_divisor[i] : ~divisor[i];
			assign quotient[i]	 = RQB[i];
	
		end
	endgenerate
	
	
	
	

endmodule