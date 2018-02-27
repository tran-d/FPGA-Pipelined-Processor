module sra(in, shiftamt, out);

	input [31:0] in;
	input [4:0] shiftamt;
	output [31:0] out;
		
	wire [31:0] sra16, sra8, sra4, sra2, sra1;
	
	
	sra16 mysra16(in,   shiftamt[4], sra16);
	
	sra8  mysra8(sra16, shiftamt[3], sra8);
	
	sra4  mysra4(sra8,  shiftamt[2], sra4);
	
	sra2  mysra2(sra4,  shiftamt[1], sra2);
	
	sra1  mysra1(sra2,  shiftamt[0], out);
	

endmodule


module sra16(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=0; i<16; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i+16] : in[i];
		
		end
	endgenerate
	
	generate
		for (i=16; i<32; i=i+1) begin: loop2
		
			assign out[i] = ena ? in[31] : in[i];
		
		end
	endgenerate

endmodule


module sra8(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=0; i<24; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i+8] : in[i];
		
		end
	endgenerate
	
	generate
		for (i=24; i<32; i=i+1) begin: loop2
		
			assign out[i] = ena ? in[31] : in[i];
		
		end
	endgenerate
	

endmodule


module sra4(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=0; i<28; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i+4] : in[i];
		
		end
	endgenerate
	
	generate
		for (i=28; i<32; i=i+1) begin: loop2
		
			assign out[i] = ena ? in[31] : in[i];
		
		end
	endgenerate


endmodule


module sra2(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=0; i<30; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i+2] : in[i];
		
		end
	endgenerate
	
	generate
		for (i=30; i<32; i=i+1) begin: loop2
		
			assign out[i] = ena ? in[31] : in[i];
		
		end
	endgenerate
	

endmodule


module sra1(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=0; i<31; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i+1] : in[i];
		
		end
	endgenerate

	assign out[31] = ena ? in[31] : in[31];

endmodule