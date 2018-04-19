/*********************************************************/

/* Used in div32.v */
module reg64_sl1(in, last_bit, clock, reset, ena, shift_ena, out);

	//left logical shift by 1

	input [63:0] in;
	input last_bit;
	input clock, reset, ena, shift_ena;
	output [63:0] out;
	
	wire new_bit0;
	
	genvar i;
	generate
		for (i = 63; i > 0; i = i - 1) begin: loop1
			dflipflop my_dff((shift_ena ? in[i-1] : in[i]), clock, reset, ena, out[i]);
		end
	endgenerate
	
	
	assign new_bit0 = shift_ena ? last_bit : in[0];
	
	dflipflop my_dff(new_bit0, clock, reset, ena, out[0]);
	
endmodule

/*********************************************************/

/* Used in adder_counter6.v for divider */
module reg6(in, clock, reset, ena, out);

		input clock, ena, reset;
		input [5:0] in;
		output [5:0] out;

		genvar i;
		generate
			for (i = 0; i < 6; i = i + 1) begin: loop1
				dflipflop my_dff(in[i], clock, reset, ena, out[i]);
			end
		endgenerate
endmodule

/*********************************************************/

/* Used in mult32.v */
module reg65_sr2(in, clock, reset, ena, shift_ena, out);

	// shift arithmetic right by 2

	input [64:0] in;
	input clock, reset, ena, shift_ena;
	output [64:0] out;
	
	wire new_bit, new_bit63;
	
	
	genvar i;
	generate
		for (i = 0; i < 63; i = i + 1) begin: loop1
			dflipflop my_dff((shift_ena ? in[i+2] : in[i]), clock, reset, ena, out[i]);
		end
	endgenerate
	
	assign new_bit63 = shift_ena ? in[64] : in[63];
	
	dflipflop my_dffMSB1(new_bit63, clock, reset, ena, out[63]);
	dflipflop my_dffMSB2(in[64], clock, reset, ena, out[64]);

endmodule


/* Used in adder_counter5.v for multiplier */
module reg5(in, clock, reset, ena, out);

		input clock, ena, reset;
		input [4:0] in;
		output [4:0] out;

		genvar i;
		generate
			for (i = 0; i < 5; i = i + 1) begin: loop1
				dflipflop my_dff(in[i], clock, reset, ena, out[i]);
			end
		endgenerate
endmodule

/*********************************************************/

/* POSITIVE EDGE */
module reg32(in, clock, reset, writeEnable, out);

		input clock, writeEnable, reset;
		input [31:0] in;
		output [31:0] out;

		genvar i;
		generate
			for (i = 0; i < 32; i = i + 1) begin: loop1
				dflipflop mydffe(in[i], clock, reset, writeEnable, out[i]);
			end
		endgenerate	
endmodule

/*********************************************************/

/* Used in regfile (NEG EDGE) */
module reg32_neg(in, clock, reset, writeEnable, out);

		input clock, writeEnable, reset;
		input [31:0] in;
		output [31:0] out;

		genvar i;
		generate
			for (i = 0; i < 32; i = i + 1) begin: loop1
				dflipflop_neg mydffe(in[i], clock, reset, writeEnable, out[i]);
			end
		endgenerate	
endmodule


module reg64(in, clock, reset, writeEnable, out);

		input clock, writeEnable, reset;
		input [63:0] in;
		output [63:0] out;

		genvar i;
		generate
			for (i = 0; i < 64; i = i + 1) begin: loop1
				dflipflop mydffe(in[i], clock, reset, writeEnable, out[i]);
			end
		endgenerate	
endmodule



