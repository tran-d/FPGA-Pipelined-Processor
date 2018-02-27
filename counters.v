/*********************************************************/

module adder_counter16(clock, reset, ena, counter_bits);

	input clock, reset, ena;
	output [4:0] counter_bits;
	wire [4:0] inter;
	
	reg5 my_reg5(inter, clock, reset, ena, counter_bits);
	
	adder5 my_adder5(counter_bits, {5{1'b0}}, 1'b1, inter);

endmodule

/*********************************************************/

module adder_counter32(clock, reset, ena, counter_bits);

	input clock, reset, ena;
	output [5:0] counter_bits;
	wire [5:0] inter;
	
	reg6 my_reg6(inter, clock, reset, ena, counter_bits);
	
	adder6 my_adder6(counter_bits, {6{1'b0}}, 1'b1, inter);

endmodule

/*********************************************************/