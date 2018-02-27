module tristate_buffer(in, ena, out);

	input in, ena;
	output out;
	assign out = ena ? in : 1'bz;
	
endmodule
