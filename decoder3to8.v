module decoder3to8(select, out);

	input [2:0] select;
	output [7:0] out;
	
	
	and and0(out[0], ~select[2], ~select[1], ~select[0]);
	and and1(out[1], ~select[2], ~select[1],  select[0]);
	and and2(out[2], ~select[2],  select[1], ~select[0]);
	and and3(out[3], ~select[2],  select[1],  select[0]);
	and and4(out[4],  select[2], ~select[1], ~select[0]);
	and and5(out[5],  select[2], ~select[1],  select[0]);
	and and6(out[6],  select[2],  select[1], ~select[0]);
	and and7(out[7],  select[2],  select[1],  select[0]);

endmodule