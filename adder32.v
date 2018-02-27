module adder32(x, y, cin, sum, overflow, isNotEqual, isLessThan);

	input [31:0] x, y;
	input cin;
	output [31:0] sum;
	output overflow, isNotEqual, isLessThan;
	
	wire P0, P1, P2, P3;
	wire G0, G1, G2, G3;
	

	// calculate c8
	wire c8, c8_1;
	
	adder8 myadder8_0 (x[7:0], y[7:0], cin, sum[7:0], P0, G0);
	
	and andc8_1(c8_1, P0, cin);
	or  orC8(c8, G0, c8_1);
	
	
	// calculate c16
	wire c16, c16_1, c16_2;
	
	adder8 myadder8_8 (x[15:8],  y[15:8],  c8, sum[15:8], P1, G1);
	
	and andc16_1(c16_1, P1, P0, cin);
	and andc16_2(c16_2, P1, G0);
	or  orC16(c16, G1, c16_1, c16_2);
	
	
	// calculate c24
	wire c24, c24_1, c24_2, c24_3;
	
	adder8 myadder8_16(x[23:16], y[23:16], c16, sum[23:16], P2, G2);
	
	and andc24_1(c24_1, P2, P1, P0, cin);
	and andc24_2(c24_2, P2, P1, G0);
	and andc24_3(c24_3, P2, G1);
	or  orC24(c24, G2, c24_1, c24_2, c24_3);
	
	
	// calculate c32
	wire c32, c32_1, c32_2, c32_3, c32_4;
	
	adder8 myadder8_24(x[31:24], y[31:24], c24, sum[31:24], P3, G3);
	
	and andc32_1(c32_1, P3, P2, P1, P0, cin);
	and andc32_2(c32_2, P3, P2, P1, G0);
	and andc32_3(c32_3, P3, P2, G1);
	and andc32_4(c32_4, P3, G2);
	or  orC32(c32, G3, c32_1, c32_2, c32_3, c32_4);
	
	// calculate overflow
	wire notxx, notyy, notsumsum, ovf1, ovf2;
	
	not notxgate(notxx, x[31]);
	not notygate(notyy, y[31]);
	not notsumgate(notsumsum, sum[31]);
	
	and andovf1(ovf1, notxx, notyy, sum[31]);
	and andovf2(ovf2, x[31], y[31], notsumsum);
	or  orovf(overflow, ovf1, ovf2);
	
	
	// calculate isNotEqual (only subtraction)
//	or   orNE(isNotEqual,   sum[0],  sum[1],  sum[2],  sum[3],  sum[4],  sum[5],  sum[6],  sum[7], 
//								  sum[8],  sum[9],  sum[10], sum[11], sum[12], sum[13], sum[14], sum[15],
//								  sum[16], sum[17], sum[18], sum[19], sum[20], sum[21], sum[22], sum[23],
//								  sum[24], sum[25], sum[26], sum[27], sum[28], sum[29], sum[30], sum[31]);
								  
	assign isNotEqual = |sum[31:0];
	
	
	// calculate isLessThan (only subtraction)
	xor xorLT(isLessThan, sum[31], overflow);

endmodule