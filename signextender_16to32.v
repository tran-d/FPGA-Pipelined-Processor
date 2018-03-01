module signextender_16to32(in, out);

	input [15:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<16; i=i+1) begin: loop1
		
			assign out[i] = in[i];
		
		end
	endgenerate
	
	generate
		for(i=16; i<32; i=i+1) begin: loop2
		
			assign out[i] = in[15];
		
		end
	endgenerate
	
endmodule