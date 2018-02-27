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


