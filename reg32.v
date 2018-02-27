module reg32(out, in, clock, writeEnable, reset);

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
