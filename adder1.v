module adder1(a, b, cin, sum);

	input a, b, cin;
	output sum;
	wire w1, w2;

	xor xor1(w1, 	a, 	b);
	xor xor2(sum, 	cin, 	w1);
	
//	and and1(w2, 	cin, 	w1);
//	and and2(w3, 	a, 	b);
//	or   or1(cout, w2, 	w3);
	
//	wire p, g;
//	
//	and andgenerate(g, a, b);
//	or  orpropagate(p, a, b);
//	and and1(w2, cin, p);
//	or  or1(cout, w2, g);
	
	


endmodule