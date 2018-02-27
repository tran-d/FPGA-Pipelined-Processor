module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	
	wire [31:0] operation_bits[5:0];
	wire [7:0] decoder_bits;
	wire [31:0] not_data_operandB, alt_data_operandB, alt_operation_bits;
	wire [5:0] sorted_bits[31:0];
	wire cin;
	
	wire d_overflow[1:0];
	
	wire dovf, dne, dlt;
	
	
	/* add */
	adder32 myadder32(data_operandA, data_operandB, 1'b0, operation_bits[0], d_overflow[0], dne, dlt);
	
	/* substract */
	adder32 mysubber32(data_operandA, not_data_operandB, 1'b1, operation_bits[1], d_overflow[1], isNotEqual, isLessThan);
	
	/* AND */
	and32 myand32(data_operandA, data_operandB, operation_bits[2]);
	
	/* OR */
	or32 myor32(data_operandA, data_operandB, operation_bits[3]);
	
	/* SLL */
	sll mysll(data_operandA, ctrl_shiftamt, operation_bits[4]);
	
	/* SRA */
	sra mysra(data_operandA, ctrl_shiftamt, operation_bits[5]);
	
	
	
	
	assign overflow = ctrl_ALUopcode[0] ? d_overflow[1] : d_overflow[0];
	genvar i, j;
	
	/* subtract */
//	assign cin = ctrl_ALUopcode[0] ? 1'b1 : 1'b0;
//	not not1(not_data_operandB, data_operandB);
//	assign alt_data_operandB = ctrl_ALUopcode[0] ? not_data_operandB : data_operandB;
//	assign operation_bits[0] = alt_operation_bits;
//	assign operation_bits[1] = alt_operation_bits;
//	
	generate
		for(i=0; i<32; i=i+1) begin: loopSubtract
		
			not notgate(not_data_operandB[i], data_operandB[i]);
//			assign alt_data_operandB[i] = ctrl_ALUopcode[0] ? not_data_operandB[i] : data_operandB[i];
//			assign operation_bits[0][i] = alt_operation_bits[i];
//			assign operation_bits[1][i] = alt_operation_bits[i];
		
		end
	endgenerate
	
	
	generate
		for(i=0; i<32; i=i+1) begin: loop1
			for(j=0; j<6; j=j+1) begin: loop2
			
				assign sorted_bits[i][j] = operation_bits[j][i];
			
			end
		
			mux8_tristate mymux(sorted_bits[i], ctrl_ALUopcode, data_result[i]);
		
		end
	endgenerate
	
	

endmodule
