module decoder5to32(ctrl_writeReg, bus);
		input [4:0] ctrl_writeReg;
		output [31:0] bus;
		
		wire not0, not1, not2, not3, not4;
		
		
		not mynot0(not0, ctrl_writeReg[0]);
		not mynot1(not1, ctrl_writeReg[1]);
		not mynot2(not2, ctrl_writeReg[2]);
		not mynot3(not3, ctrl_writeReg[3]);
		not mynot4(not4, ctrl_writeReg[4]);
		
		and and0(bus[0],   not4, 				not3, 				not2, 				not1, 				not0);
		and and1(bus[1],   not4, 				not3,				 	not2, 				not1, 				ctrl_writeReg[0]);
		and and2(bus[2],   not4, 				not3, 				not2, 				ctrl_writeReg[1], not0);
		and and3(bus[3],   not4, 				not3, 				not2, 				ctrl_writeReg[1], ctrl_writeReg[0]);
		and and4(bus[4],   not4, 				not3, 				ctrl_writeReg[2], not1, 				not0);
		and and5(bus[5],   not4, 				not3, 				ctrl_writeReg[2], not1, 				ctrl_writeReg[0]);
		and and6(bus[6],   not4, 				not3, 				ctrl_writeReg[2], ctrl_writeReg[1], not0);
		and and7(bus[7],   not4, 				not3, 				ctrl_writeReg[2], ctrl_writeReg[1], ctrl_writeReg[0]);
		and and8(bus[8],   not4, 				ctrl_writeReg[3], not2, 				not1, 				not0);
		and and9(bus[9],   not4, 				ctrl_writeReg[3], not2, 				not1, 				ctrl_writeReg[0]);
		and and10(bus[10], not4, 				ctrl_writeReg[3], not2, 				ctrl_writeReg[1], not0);
		and and11(bus[11], not4, 				ctrl_writeReg[3], not2, 				ctrl_writeReg[1], ctrl_writeReg[0]);
		and and12(bus[12], not4, 				ctrl_writeReg[3], ctrl_writeReg[2], not1, 				not0);
		and and13(bus[13], not4, 				ctrl_writeReg[3], ctrl_writeReg[2], not1, 				ctrl_writeReg[0]);
		and and14(bus[14], not4, 				ctrl_writeReg[3], ctrl_writeReg[2], ctrl_writeReg[1], not0);
		and and15(bus[15], not4, 				ctrl_writeReg[3], ctrl_writeReg[2], ctrl_writeReg[1], ctrl_writeReg[0]);
		and and16(bus[16], ctrl_writeReg[4], not3, 				not2, 				not1, 				not0);
		and and17(bus[17], ctrl_writeReg[4], not3, 				not2, 				not1, 				ctrl_writeReg[0]);
		and and18(bus[18], ctrl_writeReg[4], not3, 				not2, 				ctrl_writeReg[1], not0);
		and and19(bus[19], ctrl_writeReg[4], not3, 				not2, 				ctrl_writeReg[1], ctrl_writeReg[0]);
		and and20(bus[20], ctrl_writeReg[4], not3,				ctrl_writeReg[2], not1, 				not0);
		and and21(bus[21], ctrl_writeReg[4], not3,				ctrl_writeReg[2], not1, 				ctrl_writeReg[0]);
		and and22(bus[22], ctrl_writeReg[4], not3, 				ctrl_writeReg[2], ctrl_writeReg[1], not0);
		and and23(bus[23], ctrl_writeReg[4], not3, 				ctrl_writeReg[2], ctrl_writeReg[1], ctrl_writeReg[0]);
		and and24(bus[24], ctrl_writeReg[4], ctrl_writeReg[3],not2, 				not1, 				not0);
		and and25(bus[25], ctrl_writeReg[4], ctrl_writeReg[3],not2, 				not1, 				ctrl_writeReg[0]);
		and and26(bus[26], ctrl_writeReg[4], ctrl_writeReg[3],not2, 				ctrl_writeReg[1], not0);
		and and27(bus[27], ctrl_writeReg[4], ctrl_writeReg[3],not2, 				ctrl_writeReg[1], ctrl_writeReg[0]);
		and and28(bus[28], ctrl_writeReg[4], ctrl_writeReg[3],ctrl_writeReg[2], not1, 				not0);
		and and29(bus[29], ctrl_writeReg[4], ctrl_writeReg[3],ctrl_writeReg[2], not1, 				ctrl_writeReg[0]);
		and and30(bus[30], ctrl_writeReg[4], ctrl_writeReg[3],ctrl_writeReg[2], ctrl_writeReg[1], not0);
		and and31(bus[31], ctrl_writeReg[4], ctrl_writeReg[3],ctrl_writeReg[2], ctrl_writeReg[1], ctrl_writeReg[0]);
		
endmodule
