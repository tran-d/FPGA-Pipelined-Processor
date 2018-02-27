module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    
	 input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	 
	  /* FOR TESTING */
	 /*output [64:0] product;
	 output [63:0] RQB;
	 output [31:0] adder_resultD;
	 output RQB_lt_Divisor;
	 output [5:0] counter_bitsD;
	 output [4:0] counter_bits;
	 output [31:0] adder_result, adder_operandB;*/

    // Your code here
	 wire [31:0] alt_data_result[1:0];
	 wire [1:0] alt_data_exception;
	 wire [1:0] alt_data_resultRDY;
	 wire multiply;
	 
	 
	 mult32 mymult32(ctrl_MULT, data_operandA, data_operandB, clock, alt_data_result[0], alt_data_exception[0], alt_data_resultRDY[0]);
	 
	 div32 mydiv32  (ctrl_DIV, data_operandA, data_operandB, clock, alt_data_result[1], alt_data_exception[1], alt_data_resultRDY[1]);
	 
	 
	 sr_latch mylatch(ctrl_MULT, ctrl_DIV, multiply);
	 
		
	 assign data_result    = multiply ? alt_data_result[0]    : alt_data_result[1];
	 assign data_exception = multiply ? alt_data_exception[0] : alt_data_exception[1];
	 assign data_resultRDY = multiply ? alt_data_resultRDY[0] : alt_data_resultRDY[1];
	 
	 
	 

endmodule
