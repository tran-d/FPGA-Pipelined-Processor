 module dflipflop_neg(d, clk, clr, ena, q);
    input d, clk, clr, ena;

    output q;
    reg q;
	 

    initial
    begin
        q = 1'b0;
    end

	 // update values only when clock is high, (synchronous reset)
	 
    always @(negedge clk) begin
        if (q == 1'bx) begin
            q <= 1'b0;
        end else if (clr) begin
            q <= 1'b0;
        end else if (ena) begin
            q <= d;
        end
    end
endmodule
