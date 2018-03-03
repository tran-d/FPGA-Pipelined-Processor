module signextender_16to32(in, out);

	input [16:0] in;
	output [31:0] out;
	
//	genvar i;
//	generate
//		for(i=0; i<17; i=i+1) begin: loop1
//		
//			assign out[i] = in[i];
//		
//		end
//	endgenerate
//	
//	generate
//		for(i=17; i<32; i=i+1) begin: loop2
//		
//			assign out[i] = in[16];
//		
//		end
//	endgenerate
	
	assign out = { {15{in[16]}} ,  in };
	
endmodule