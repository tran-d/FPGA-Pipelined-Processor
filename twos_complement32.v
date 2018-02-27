module twos_complement32(in, out);

	input [31:0] in;
	output [31:0] out;
	
	wire [31:0] neg_in;
	wire ovf, ne, lt;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loop1
		
			assign neg_in[i] = ~in[i];
	
		end
	endgenerate
	
	adder32 my_adder32(neg_in, {32{1'b0}}, 1'b1, out, ovf, ne, lt);
	

endmodule