/*********************************************************/

module adder1(a, b, cin, sum);

	input a, b, cin;
	output sum;
	wire w1, w2;

	xor xor1(w1, 	a, 	b);
	xor xor2(sum, 	cin, 	w1);
	
endmodule

/*********************************************************/

module adder5(x, y, cin, sum);

	input [4:0] x, y;
	input cin;
	output [4:0] sum;
	wire [4:0] p, g;
	wire cout;
	
	wire [4:0] c;
	
	// calculate p, g
	genvar i;
	generate
		for(i=0; i<5; i=i+1) begin: loop1
			
			and and1(g[i], x[i], y[i]);
			or  or1(p[i], x[i], y[i]);
			
		end
	endgenerate
	
	// calculate c1
	wire c1_1;
	
	and andc1_1(c1_1, cin, p[0]);
	or  orc1(c[1], c1_1, g[0]);

	// calculate c2
	wire c2_1, c2_2;
	
	and andc2_1(c2_1,  cin, p[0], p[1]);
	and andc2_2(c2_2, g[0], p[1]);
	or	  orc2(c[2], c2_1, c2_2, g[1]);
	
	// calculate c3
	wire c3_1, c3_2, c3_3;
	
	and andc3_1(c3_1,  cin, p[0], p[1], p[2]);
	and andc3_2(c3_2, g[0], p[1], p[2]);
	and andc3_3(c3_3, g[1], p[2]);
	or   orc3(c[3], c3_1, c3_2, c3_3, g[2]);
	
	// calculate c4
	wire c4_1, c4_2, c4_3, c4_4;
	
	and andc4_1(c4_1,  cin, p[0], p[1], p[2], p[3]);
	and andc4_2(c4_2, g[0], p[1], p[2], p[3]);
	and andc4_3(c4_3, g[1], p[2], p[3]);
	and andc4_4(c4_4, g[2], p[3]);
	or   orc4(c[4], c4_1, c4_2, c4_3, c4_4, g[3]);
	
	// calculate c5
	wire c5_1, c5_2, c5_3, c5_4, c5_5;
	
	and andc5_1(c5_1,  cin, p[0], p[1], p[2], p[3], p[4]);
	and andc5_2(c5_2, g[0], p[1], p[2], p[3], p[4]);
	and andc5_3(c5_3, g[1], p[2], p[3], p[4]);
	and andc5_4(c5_4, g[2], p[3], p[4]);
	and andc5_5(c5_5, g[3], p[4]);
	or   orc5(cout, c5_1, c5_2, c5_3, c5_4, c5_5, g[4]);
	
	
		// set carry input & output
	assign c[0] = cin;
	
	generate
		
		for(i=0; i<5; i=i+1) begin: loop2
		
			adder1 myadder1(x[i], y[i], c[i], sum[i]);
		
		end
	
	endgenerate
	
endmodule

/*********************************************************/

module adder6(x, y, cin, sum);

	input [5:0] x, y;
	input cin;
	output [5:0] sum;
	wire [5:0] p, g;
	wire cout;
	
	wire [5:0] c;
	
	// calculate p, g
	genvar i;
	generate
		for(i=0; i<6; i=i+1) begin: loop1
			
			and and1(g[i], x[i], y[i]);
			or  or1(p[i], x[i], y[i]);
			
		end
	endgenerate
	
	// calculate c1
	wire c1_1;
	
	and andc1_1(c1_1, cin, p[0]);
	or  orc1(c[1], c1_1, g[0]);

	// calculate c2
	wire c2_1, c2_2;
	
	and andc2_1(c2_1,  cin, p[0], p[1]);
	and andc2_2(c2_2, g[0], p[1]);
	or	  orc2(c[2], c2_1, c2_2, g[1]);
	
	// calculate c3
	wire c3_1, c3_2, c3_3;
	
	and andc3_1(c3_1,  cin, p[0], p[1], p[2]);
	and andc3_2(c3_2, g[0], p[1], p[2]);
	and andc3_3(c3_3, g[1], p[2]);
	or   orc3(c[3], c3_1, c3_2, c3_3, g[2]);
	
	// calculate c4
	wire c4_1, c4_2, c4_3, c4_4;
	
	and andc4_1(c4_1,  cin, p[0], p[1], p[2], p[3]);
	and andc4_2(c4_2, g[0], p[1], p[2], p[3]);
	and andc4_3(c4_3, g[1], p[2], p[3]);
	and andc4_4(c4_4, g[2], p[3]);
	or   orc4(c[4], c4_1, c4_2, c4_3, c4_4, g[3]);
	
	// calculate c5
	wire c5_1, c5_2, c5_3, c5_4, c5_5;
	
	and andc5_1(c5_1,  cin, p[0], p[1], p[2], p[3], p[4]);
	and andc5_2(c5_2, g[0], p[1], p[2], p[3], p[4]);
	and andc5_3(c5_3, g[1], p[2], p[3], p[4]);
	and andc5_4(c5_4, g[2], p[3], p[4]);
	and andc5_5(c5_5, g[3], p[4]);
	or   orc5(c[5], c5_1, c5_2, c5_3, c5_4, c5_5, g[4]);
	
	// calculate c6
	wire c6_1, c6_2, c6_3, c6_4, c6_5, c6_6;
	
	and andc6_1(c6_1,  cin, p[0], p[1], p[2], p[3], p[4], p[5]);
	and andc6_2(c6_2, g[0], p[1], p[2], p[3], p[4], p[5]);
	and andc6_3(c6_3, g[1], p[2], p[3], p[4], p[5]);
	and andc6_4(c6_4, g[2], p[3], p[4], p[5]);
	and andc6_5(c6_5, g[3], p[4], p[5]);
	and andc6_6(c6_6, g[4], p[5]);
	or   orc6(cout, c6_1, c6_2, c6_3, c6_4, c6_5, c6_6, g[5]);
	
	
	// set carry input & output
	assign c[0] = cin;
	
	generate
		
		for(i=0; i<6; i=i+1) begin: loop2
		
			adder1 myadder1(x[i], y[i], c[i], sum[i]);
		
		end
	
	endgenerate

endmodule

/*********************************************************/

module adder8(x, y, cin, sum, P0, G0);

	input [7:0] x, y;
	input cin;
	output [7:0] sum;
	wire [7:0] p, g;
	wire cout;
	
	output P0, G0;
	
	wire [7:0] c;
	
	// calculate p, g
	genvar i;
	generate
		for(i=0; i<8; i=i+1) begin: loop1
			
			and and1(g[i], x[i], y[i]);
			or  or1(p[i], x[i], y[i]);
			
		end
	endgenerate
	
	wire G0_0, G0_1, G0_2, G0_3, G0_4, G0_5, G0_6;
	
	and andP0  (P0,   p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
	and andG0_0(G0_0, p[1], p[2], p[3], p[4], p[5], p[6], p[7], g[0]);
	and andG0_1(G0_1, p[2], p[3], p[4], p[5], p[6], p[7], g[1]);
	and andG0_2(G0_2, p[3], p[4], p[5], p[6], p[7], g[2]);
	and andG0_3(G0_3, p[4], p[5], p[6], p[7], g[3]);
	and andG0_4(G0_4, p[5], p[6], p[7], g[4]);
	and andG0_5(G0_5, p[6], p[7], g[5]);
	and andG0_6(G0_6, p[7], g[6]);
	or  orG0(G0, g[7], G0_0, G0_1, G0_2, G0_3, G0_4, G0_5, G0_6);
	
	
	
	// calculate c1
	wire c1_1;
	
	and andc1_1(c1_1, cin, p[0]);
	or  orc1(c[1], c1_1, g[0]);

	// calculate c2
	wire c2_1, c2_2;
	
	and andc2_1(c2_1,  cin, p[0], p[1]);
	and andc2_2(c2_2, g[0], p[1]);
	or	  orc2(c[2], c2_1, c2_2, g[1]);
	
	// calculate c3
	wire c3_1, c3_2, c3_3;
	
	and andc3_1(c3_1,  cin, p[0], p[1], p[2]);
	and andc3_2(c3_2, g[0], p[1], p[2]);
	and andc3_3(c3_3, g[1], p[2]);
	or   orc3(c[3], c3_1, c3_2, c3_3, g[2]);
	
	// calculate c4
	wire c4_1, c4_2, c4_3, c4_4;
	
	and andc4_1(c4_1,  cin, p[0], p[1], p[2], p[3]);
	and andc4_2(c4_2, g[0], p[1], p[2], p[3]);
	and andc4_3(c4_3, g[1], p[2], p[3]);
	and andc4_4(c4_4, g[2], p[3]);
	or   orc4(c[4], c4_1, c4_2, c4_3, c4_4, g[3]);
	
	// calculate c5
	wire c5_1, c5_2, c5_3, c5_4, c5_5;
	
	and andc5_1(c5_1,  cin, p[0], p[1], p[2], p[3], p[4]);
	and andc5_2(c5_2, g[0], p[1], p[2], p[3], p[4]);
	and andc5_3(c5_3, g[1], p[2], p[3], p[4]);
	and andc5_4(c5_4, g[2], p[3], p[4]);
	and andc5_5(c5_5, g[3], p[4]);
	or   orc5(c[5], c5_1, c5_2, c5_3, c5_4, c5_5, g[4]);
	
	// calculate c6
	wire c6_1, c6_2, c6_3, c6_4, c6_5, c6_6;
	
	and andc6_1(c6_1,  cin, p[0], p[1], p[2], p[3], p[4], p[5]);
	and andc6_2(c6_2, g[0], p[1], p[2], p[3], p[4], p[5]);
	and andc6_3(c6_3, g[1], p[2], p[3], p[4], p[5]);
	and andc6_4(c6_4, g[2], p[3], p[4], p[5]);
	and andc6_5(c6_5, g[3], p[4], p[5]);
	and andc6_6(c6_6, g[4], p[5]);
	or   orc6(c[6], c6_1, c6_2, c6_3, c6_4, c6_5, c6_6, g[5]);
	
	// calculate c7
	wire c7_1, c7_2, c7_3, c7_4, c7_5, c7_6, c7_7;
	
	and andc7_1(c7_1,  cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
	and andc7_2(c7_2, g[0], p[1], p[2], p[3], p[4], p[5], p[6]);
	and andc7_3(c7_3, g[1], p[2], p[3], p[4], p[5], p[6]);
	and andc7_4(c7_4, g[2], p[3], p[4], p[5], p[6]);
	and andc7_5(c7_5, g[3], p[4], p[5], p[6]);
	and andc7_6(c7_6, g[4], p[5], p[6]);
	and andc7_7(c7_7, g[5], p[6]);
	or   orc7(c[7], c7_1, c7_2, c7_3, c7_4, c7_5, c7_6, c7_7, g[6]);
	
	// calculate c8
	wire c8_1, c8_2, c8_3, c8_4, c8_5, c8_6, c8_7, c8_8;
	
	and andc8_1(c8_1,  cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
	and andc8_2(c8_2, g[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
	and andc8_3(c8_3, g[1], p[2], p[3], p[4], p[5], p[6], p[7]);
	and andc8_4(c8_4, g[2], p[3], p[4], p[5], p[6], p[7]);
	and andc8_5(c8_5, g[3], p[4], p[5], p[6], p[7]);
	and andc8_6(c8_6, g[4], p[5], p[6], p[7]);
	and andc8_7(c8_7, g[5], p[6], p[7]);
	and andc8_8(c8_8, g[6], p[7]);
	or   orc8(cout, c8_1, c8_2, c8_3, c8_4, c8_5, c8_6, c8_7, c8_8, g[7]);
	
	
	// set carry input & output
	assign c[0] = cin;
	
	generate
		
		for(i=0; i<8; i=i+1) begin: loop2
		
			adder1 myadder1(x[i], y[i], c[i], sum[i]);
		
		end
	
	endgenerate

endmodule

/*********************************************************/