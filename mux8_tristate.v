module mux8_tristate(in, ALUopcode, out);

	/* [000] add */
	/* [001] subtract */
	/* [010] AND */
	/* [011] OR */
	/* [100] SLL */
	/* [101] SRA */
	
	input [5:0] in;
	input [4:0] ALUopcode;
	output out;
	
	wire [7:0] decoderbits;
	
	decoder3to8 mydecoder(ALUopcode[2:0], decoderbits);
	
	
	// chooses bit from one of 6 different outputs
	genvar i;
	generate
	
		for(i=0; i<6; i=i+1) begin: loop1
		
			tristate_buffer mytb(in[i], decoderbits[i], out);
		
		end
	
	endgenerate

endmodule
