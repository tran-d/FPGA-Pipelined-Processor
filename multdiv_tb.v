`timescale 1 ns / 100 ps

module multdiv_tb();

    // inputs to the multdiv are reg type
    reg            clock, ctrl_MULT, ctrl_DIV, data_exception_expected;
    reg signed [31:0] data_operandA, data_operandB, data_expected;

    // outputs from the multdiv are wire type
    wire signed [31:0] data_result;
    wire data_resultRDY, data_exception, in_progress;
	 
	 /* FOR TESTING */
	 /*wire [64:0] product;
	 wire [4:0] counter_bits;
	 wire signed [31:0] adder_result, adder_operandB;
	 wire [31:0] adder_resultD;
	 wire [63:0] RQB;
	 wire RQB_lt_Divisor;
	 wire [5:0] counter_bitsD;*/
	 

    // Tracking the number of errors
    integer errors;
    integer index;    // for testing...

    // Instantiate multdiv
    multdiv multdiv_ut(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY, in_progress);
	
	 wire div_RDY = multdiv_ut.div_RDY;
	 wire mult_RDY = multdiv_ut.mult_RDY;
	 wire pseudo_RDY = multdiv_ut.data_resultRDY;
	
    initial

    begin
        $display($time, "<< Starting the Simulation >>");
        clock = 1'b0;    // at time 0
        errors = 0;
        
        //$monitor("clock: %d, pseudo_RDY: %d, ctrl_DIV: %d, div_RDY: %d, data_resultRDY: %d data_result: %d", clock, pseudo_RDY, ctrl_DIV, div_RDY, data_resultRDY, data_result);
		  
		  $monitor("clock: %d, pseudo_RDY: %d, ctrl_MULT: %d, mult_RDY: %d, data_resultRDY: %d data_result: %d", clock, pseudo_RDY, ctrl_MULT, mult_RDY, data_resultRDY, data_result);
		  
		  
//		  $monitor("time $d, clock: %b, ctrl_DIV: %b, A: %h, B: %h, quotient: %b %b, \n\n\t RQB_lt_Divisor: %b, adder_resultD: %b, data_exception: %b, data_resultRDY: %b counterD: %b\n\n", 
//					$time, clock, ctrl_DIV, data_operandA, data_operandB, RQB[63:32], RQB[31:0], RQB_lt_Divisor, adder_resultD, data_exception, data_resultRDY, counter_bitsD);
//		  
//			$monitor("clock: %b, ctrl_DIV: %b, A: %h, B: %h, quotient: %b %b, \n\n\t RQB_lt_Divisor: %b,, data_exception: %b, data_resultRDY: %b counterD: %b\n\n", 
//					clock, ctrl_DIV, data_operandA, data_operandB, RQB[63:32], RQB[31:0], RQB_lt_Divisor, data_exception, data_resultRDY, counter_bitsD);
		  
		  
           $display("initialization");
        @(negedge clock);
        assign data_operandA = 32'd13001;
        assign data_operandB = 32'd18064;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b0;
          
		  // MULTIPLICATION
		  $display($time, "<< MULTIPLICATION >>");

        $display("test 1a: starting (large multiplication)");
        @(negedge clock);
        assign data_operandA = 32'd13001;
        assign data_operandB = 32'd18064;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'd234850064;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 1a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 1a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 1a: PASS");
        end

        $display("test 1b: starting (large multiplication, flipped operands)");
        @(negedge clock);
        assign data_operandA = 32'd18064;
        assign data_operandB = 32'd13001;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'd234850064;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 1b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 1b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 1b: PASS");
        end

        $display("test 2a: starting (large power of 10)");
        @(negedge clock);
        assign data_operandA = 32'd5;
        assign data_operandB = 32'd10000000;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'd50000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 2a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 2a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 2a: PASS");
        end

        $display("test 2b: starting (large power of 10, flipped operands)");
        @(negedge clock);
        assign data_operandA = 32'd10000000;
        assign data_operandB = 32'd5;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'd50000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 2b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 2b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 2b: PASS");
        end

        $display("test 3a: starting (multiplying two negatives)");
        @(negedge clock);
        assign data_operandA = -32'd5;
        assign data_operandB = -32'd10000000;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'd50000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 3a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 3a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 3a: PASS");
        end

        $display("test 3b: starting (multiplying two negatives, flipped operands)");
        @(negedge clock);
        assign data_operandA = -32'd10000000;
        assign data_operandB = -32'd5;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'd50000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 3b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 3b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 3b: PASS");
        end

        $display("test 4: starting (negative 1 squared)");
        @(negedge clock);
        assign data_operandA = -32'd1;
        assign data_operandB = -32'd1;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'd1;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 4: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 4: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 4: PASS");
        end

        $display("test 5a: starting (positive times negative)");
        @(negedge clock);
        assign data_operandA = 32'd1234;
        assign data_operandB = -32'd2579;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = -32'd3182486;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 5a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 5a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 5a: PASS");
        end

        $display("test 5b: starting (positive times negative, flipped magnitudes)");
        @(negedge clock);
        assign data_operandA = 32'd2579;
        assign data_operandB = -32'd1234;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = -32'd3182486;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 5b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 5b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 5b: PASS");
        end

        $display("test 6a: starting (negative times positive)");
        @(negedge clock);
        assign data_operandA = -32'd47901;
        assign data_operandB = 32'd6357;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = -32'd304506657;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 6a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 6a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 6a: PASS");
        end

        $display("test 6b: starting (negative times positive, flipped magnitudes)");
        @(negedge clock);
        assign data_operandA = -32'd6357;
        assign data_operandB = 32'd47901;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = -32'd304506657;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 6b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 6b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 6b: PASS");
        end

        $display("test 7: starting (0111...111 squared, overflow)");
        @(negedge clock);
        assign data_operandA = 32'h7FFFFFFF;
        assign data_operandB = 32'h7FFFFFFF;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'h00000001;
        assign data_exception_expected = 1'b1;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 7: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 7: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 7: PASS");
        end

        $display("test 8a: starting (01..000 times 2, overflow)");
        @(negedge clock);
        assign data_operandA = 32'h40000000;
        assign data_operandB = 32'd2;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'h80000000;
        assign data_exception_expected = 1'b1;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 8a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 8a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 8a: PASS");
        end

        $display("test 8b: starting (01..000 times 2, overflow, flipped operands)");
        @(negedge clock);
        assign data_operandA = 32'd2;
        assign data_operandB = 32'h40000000;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'h80000000;
        assign data_exception_expected = 1'b1;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 8b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 8b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 8b: PASS");
        end

        $display("test 9a: starting (smallest negative number overflow edge case)");
        @(negedge clock);
        assign data_operandA = 32'h80000000;
        assign data_operandB = 32'd1;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'h80000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 9a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 9a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 9a: PASS");
        end
		  
//			$display("test 9a: PASS\t time: %d, product: %b %b %b", $time, product[64:33], product[32:1], product[0]);
			
			
			
        $display("test 9b: starting (smallest negative number overflow edge case, flipped)");
        @(negedge clock);
        assign data_operandA = 32'd1;
        assign data_operandB = 32'h80000000;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'h80000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 9b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 9b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 9b: PASS");
        end

        $display("test 10a: starting (mult by 0)");
        @(negedge clock);
        assign data_operandA = 32'h00000000;
        assign data_operandB = 32'hFF00FF00;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'h00000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 10a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 10a: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 10a: PASS");
        end

        $display("test 10b: starting (mult by 0, flipped operands)");
        @(negedge clock);
        assign data_operandA = 32'hFF00FF00;
        assign data_operandB = 32'h00000000;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = 32'h00000000;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 10b: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 10b: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 10b: PASS");
        end
		  
		  
		  
		  
		  
		  
		  
		  // DIVISION
		  $display($time, "<< DIVISION >>");

        $display("test 11: starting (small division)");
        @(negedge clock);
        assign data_operandA = 32'd10;
        assign data_operandB = 32'd2;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd5;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 11: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 11: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 11: PASS");
        end

        $display("test 12: starting (negative divided by positive)");
        @(negedge clock);
        assign data_operandA = -32'd10;
        assign data_operandB = 32'd2;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = -32'd5;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 12: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 12: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 12: PASS");
        end

        $display("test 13: starting (positive divided by negative)");
        @(negedge clock);
        assign data_operandA = 32'd293435;
        assign data_operandB = -32'd17;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = -32'd17260;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 13: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 13: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 13: PASS");
        end

        $display("test 14: starting (dividing 0 by a negative)");
        @(negedge clock);
        assign data_operandA = 32'd0;
        assign data_operandB = -32'd17;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd0;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 14: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 14: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 14: PASS");
        end

        $display("test 15: starting (division by 0)");
        @(negedge clock);
        assign data_operandA = 32'd0;
        assign data_operandB = 32'd0;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd0;
        assign data_exception_expected = 1'b1;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 15: done");
        if(data_exception !== data_exception_expected) begin
            $display("**test 15: FAIL; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 15: PASS");
        end

        $display("test 16: starting (large division, not exactly divisible)");
        @(negedge clock);
        assign data_operandA = 32'd293435;
        assign data_operandB = 32'd17;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd17260;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 16: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 16: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 16: PASS");
        end

        $display("test 17: starting (dividing 0 by a positive)");
        @(negedge clock);
        assign data_operandA = 32'd0;
        assign data_operandB = 32'd17;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd0;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 17: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 17: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 17: PASS");
        end

        $display("test 18: starting (multiplication interrupting division)");
        @(negedge clock);
        assign data_operandA = 32'd0;
        assign data_operandB = 32'd17;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd0;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge clock);
        @(posedge clock);

        @(negedge clock);
        assign data_operandA = 32'd1234;
        assign data_operandB = -32'd2579;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = -32'd3182486;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 18: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 18: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 18: PASS");
        end

        $display("test 19: starting (division interrupting multiplication)");
        @(negedge clock);
        assign data_operandA = 32'd1234;
        assign data_operandB = -32'd2579;
        assign ctrl_MULT = 1'b1;
        assign ctrl_DIV = 1'b0;
        assign data_expected = -32'd3182486;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_MULT = 1'b0;

        @(posedge clock);
        @(posedge clock);

        @(negedge clock);
        assign data_operandA = 32'd293435;
        assign data_operandB = -32'd17;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = -32'd17260;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);

        $display("test 19: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 19: FAIL; expected: %h, actual: %h; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 19: PASS");
        end
		  
		  
		 //////////////////////////////////////////////////
		  
		  $display("test CUSTOM_1a: 2435 / 5 = 487 ");
        @(negedge clock);
        assign data_operandA = 32'd2435;
        assign data_operandB = 32'd5;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd487;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 1a: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 1a: FAIL; expected: %d, actual: %d; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 1a: PASS");
        end
		  
		  $display("test CUSTOM_1a: 2435 / -5 = -487");
        @(negedge clock);
        assign data_operandA = 32'd2435;
        assign data_operandB = -32'd5;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = -32'd487;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 1ba: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 1b: FAIL; expected: %d, actual: %d; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 1b: PASS");
        end
		  
		  $display("test CUSTOM_1c: 2430 / 5 = 486");
        @(negedge clock);
        assign data_operandA = 32'd2430;
        assign data_operandB = 32'd5;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd486;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 1c: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 1c: FAIL; expected: %d, actual: %d; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 1c: PASS");
        end
		  
		  $display("test CUSTOM_1d: 2430 / -5 = -486");
        @(negedge clock);
        assign data_operandA = 32'd2430;
        assign data_operandB = -32'd5;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = -32'd486;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 1d: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 1d: FAIL; expected: %d, actual: %d; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 1d: PASS");
        end
		  
		  if(errors == 0) begin
            $display("The simulation completed without errors");
        end
        else begin
            $display("The simulation failed with %d errors", errors);
        end
		  
		  $display("test CUSTOM_1e: 0 / 0 = 0");
        @(negedge clock);
        assign data_operandA = 32'd0;
        assign data_operandB = 32'd0;
        assign ctrl_MULT = 1'b0;
        assign ctrl_DIV = 1'b1;
        assign data_expected = 32'd0;
        assign data_exception_expected = 1'b0;

        @(negedge clock);
        assign ctrl_DIV = 1'b0;

        @(posedge data_resultRDY);
        @(posedge clock);
        $display("test 1d: done");
        if(data_result !== data_expected || data_exception !== data_exception_expected) begin
            $display("**test 1e: FAIL; expected: %d, actual: %d; `data_exception` expected: %b, actual: %b", data_expected, data_result, data_exception_expected, data_exception);
            errors = errors + 1;
        end
        else begin
            $display("test 1e: PASS");
        end
		  
		  if(errors == 0) begin
            $display("The simulation completed without errors");
        end
        else begin
            $display("The simulation failed with %d errors", errors);
        end
		  

        $stop;
    end

    // Clock generator
    always
         #10     clock = ~clock;
endmodule


