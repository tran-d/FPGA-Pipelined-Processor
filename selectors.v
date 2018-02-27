/*********************************************************/

module tristate_buffer(in, ena, out);

	input in, ena;
	output out;
	assign out = ena ? in : 1'bz;
	
endmodule

/*********************************************************/

module tristate_buffer32(in, select, out); 

	input [31:0] in;
	input select;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loop1
		
			tristate_buffer my_tb(in[i], select, out[i]);
		
		end
	endgenerate

endmodule

/*********************************************************/

module mux32_tristate(in, select, out);

	input [31:0] in;
	input [4:0] select;
	output out;
	
	wire [31:0] decoder_bits;
	
	decoder5to32 my_decoder(select, decoder_bits);
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loop
		
			tristate_buffer my_tri(in[i], decoder_bits[i], out);
		
		end
	endgenerate

endmodule


/*********************************************************/

module mux2to1_32(in1, in2, select, out); 

	input [31:0] in1, in2;
	input select;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loop1
	
			assign out[i] = select ? in2[i] : in1[i];
		
		end
	endgenerate

endmodule

/*********************************************************/

module mux2to1_33(in1, in2, select, out); 

	input [32:0] in1, in2;
	input select;
	
	output [32:0] out;
	
	genvar i;
	generate
		for(i=0; i<33; i=i+1) begin: loop1
	
			assign out[i] = select ? in2[i] : in1[i];
		
		end
	endgenerate

endmodule

/*********************************************************/

// Used for ALU opcode
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


/*********************************************************/