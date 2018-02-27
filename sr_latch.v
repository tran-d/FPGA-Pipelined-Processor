module sr_latch (ctrl_MULT, ctrl_DIV, multiply);

	input ctrl_MULT, ctrl_DIV; 
	output multiply;
	wire not_q;

	nor(not_q, ctrl_MULT, multiply);
	nor(multiply, ctrl_DIV, not_q);

endmodule