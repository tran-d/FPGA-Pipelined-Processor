/*********************************************************/

module sll(in, shiftamt, out);

	input [31:0] in;
	input [4:0] shiftamt;
	output [31:0] out;
		
	wire [31:0] sll16, sll8, sll4, sll2, sll1;
	
	
	sll16 mysll16(in,   shiftamt[4], sll16);
	
	sll8  mysll8(sll16, shiftamt[3], sll8);
	
	sll4  mysll4(sll8,  shiftamt[2], sll4);
	
	sll2  mysll2(sll4,  shiftamt[1], sll2);
	
	sll1  mysll1(sll2,  shiftamt[0], out);
	
endmodule

module sll16(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=16; i<32; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i-16] : in[i];
		
		end
	endgenerate
	
	assign out[15:0] = ena ? 16'b0 : in[15:0];
	
endmodule

module sll8(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=8; i<32; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i-8] : in[i];
		
		end
	endgenerate
	
	assign out[7:0] = ena ? 8'b0 : in[7:0];
	
endmodule

module sll4(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=4; i<32; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i-4]: in[i];
		
		end
	endgenerate
	
	assign out[3:0] = ena ? 4'b0 : in[3:0];
	
endmodule

module sll2(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;

	genvar i;
	generate
		for (i=2; i<32; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i-2] : in[i];
		
		end
	endgenerate
	
	assign out[1:0] = ena ? 2'b0 : in[1:0];
	
endmodule

module sll1(in, ena, out);

	input [31:0] in;
	input ena;
	output [31:0] out;
	

	genvar i;
	generate
		for (i=1; i<32; i=i+1) begin: loop1
		
			assign out[i] = ena ? in[i-1] : in[i];
		
		end
	endgenerate
	
	assign out[0] = ena ? 1'b0 : in[0];
	
endmodule 

/*********************************************************/

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

/*********************************************************/

module and32(x, y, out);

	input [31:0] x, y;
	output [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loop1
			
			and myand(out[i], x[i], y[i]);
			
		end
	endgenerate

endmodule

/*********************************************************/

module or32(x, y, out);

	input [31:0] x, y;
	output [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: loop1
			
			or myor(out[i], x[i], y[i]);
			
		end
	endgenerate

endmodule

/*********************************************************/