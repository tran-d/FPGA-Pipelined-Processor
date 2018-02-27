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