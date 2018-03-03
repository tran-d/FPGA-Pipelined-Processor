`timescale 1 ns / 100 ps
module immediate_ext_tb();

	reg [16:0] in;
	wire [31:0] out;
	
	signextender_16to32 se(in, out);
	
	initial begin
	
		$display("Starting simulation");
		
		in = 32'b0;
		
		
		$monitor("in: %b, out: %b", in, out);
		#40;
		$stop;
	
	end
	
	always 
		#10
		in[1] = ~in[1];
	
	always
		#20
		in[5] = ~in[5];
		

endmodule