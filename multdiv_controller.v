module multdiv_controller(
	data_operandA, 
	data_operandB, 
	mul, 
	div, 
	nop,
	clock, 
	multdiv_result, 
	multdiv_exception, 
	multdiv_actually_RDY
);
   input [31:0] data_operandA, data_operandB; 
	input mul, div, nop, clock;
	
	output [31:0] multdiv_result;
	output multdiv_exception, multdiv_actually_RDY;
	
	wire [31:0] latch_data_operandA, latch_data_operandB, latch_multdiv2_out, latch_multdiv1_out, latch_multdiv3_out;
	wire multdiv_RDY, latch_ctrl_MULT, latch_ctrl_DIV;
	reg ctrl_MULT, ctrl_DIV; 
	
	initial begin
		ctrl_MULT <= 1'b0;
		ctrl_DIV <= 1'b0;
	end
	
	always @(negedge clock)
	begin
	if(mul) begin
		ctrl_MULT <= 1'b1;
		end
	else if(div) begin
		ctrl_DIV <= 1'b1;
		end	
	else if(latch_ctrl_MULT)
		ctrl_MULT <= 1'b0;
	else if(latch_ctrl_DIV)
		ctrl_DIV <= 1'b0;
	end
    
   wire in_progress;
	 
	latch_ctrl ctrl_mult(ctrl_MULT, clock, 1'b0, 1'b1, latch_ctrl_MULT);
	latch_ctrl ctrl_div(ctrl_DIV, clock, 1'b0, 1'b1, latch_ctrl_DIV);
	
	multdiv my_multdiv(latch_data_operandA, latch_data_operandB, ctrl_MULT, ctrl_DIV, clock, multdiv_result, multdiv_exception, multdiv_actually_RDY, in_progress);
	
	latch_multdiv latch_operandA(data_operandA, clock, 1'b0, ~in_progress, latch_data_operandA);
	latch_multdiv latch_operandB(data_operandB, clock, 1'b0, ~in_progress, latch_data_operandB);
    
    
//	latch_multdiv latch_multdiv1(multdiv_result, clock, 1'b0, multdiv_RDY, latch_multdiv1_out);
//	latch_multdiv latch_multdiv2(latch_multdiv1_out, clock, 1'b0, 1'b1, latch_multdiv2_out);
//	latch_multdiv latch_multdiv3(latch_multdiv2_out, clock, 1'b0, 1'b1, latch_multdiv3_out);
	
endmodule


module latch_multdiv(in, clock, reset, enable, out);
	
	input [31:0] in;
	input clock, reset, enable;
	output [31:0] out;
	
	reg32 my_reg32(in, clock, reset, enable, out);

endmodule

module latch_ctrl(in, clock, reset, enable, out);
	
	input in;
	input clock, reset, enable;
	output out;
	
	dflipflop_neg my_dff(in, clock, reset, enable, out);

endmodule

