// infi loop doubles R[4], this time -2
// 1 cache access, set 0, cold miss
// similar to test_02 but uses branch instead, change the opcode of the intruction before branch to subtraction and see that is prevents the branch from taking place
// keep running to observe overflow exception, transfer to address 27
assign instruction[0] = 32'b000_000_110_0000011__000_001_00001_01101; // R[1] = Mem[1]; COLD MISS, 32 cycle stall || R[6] = R[0] + R[0]
assign instruction[1] = 32'b001_010_110_0000011__000_001_00010_01100; // Mem[2] = R[1];	|| R[6] = R[1] + R[2]
assign instruction[2] = 32'b001_000_110_0000011__000_010_00010_01101; // R[2] = Mem[2];	|| R[6] = R[1] + R[0]
assign instruction[3] = 32'b001_010_110_0000011__000_010_00011_01100; // Mem[3] = R[2];	|| R[6] = R[1] + R[2]
assign instruction[4] = 32'b001_010_110_0000011__000_011_00011_01101; // R[3] = Mem[3];	|| R[6] = R[1] + R[2]
assign instruction[5] = 32'b011_010_100_00_00011__000_110_00001_01101; // R[4] = R[2] + R[3]; || R[6] = Mem[1];
assign instruction[6] = 32'b100_010_100_01_00011__000_110_00010_01101; // R[4] = R[2] - R[4]; || R[6] = Mem[2];
assign instruction[7] = 32'b100_100_100_00_00011__000_110_00011_01101; // R[4] = R[4] + R[4]; || R[6] = Mem[3];
assign instruction[8] = 32'b0000000000000000__11111110_000_11011; // branch back 1 instruction
assign instruction[9] = 32'b0000000000000000__0000000000000000;
assign instruction[10] = 32'b0000000000000000__0000000000000000;
assign instruction[11] = 32'b0000000000000000__0000000000000000;
assign instruction[12] = 32'b0000000000000000__0000000000000000;
assign instruction[13] = 32'b0000000000000000__0000000000000000;
assign instruction[14] = 32'b0000000000000000__0000000000000000;
assign instruction[15] = 32'b0000000000000000__0000000000000000;
assign instruction[16] = 32'b0000000000000000__0000000000000000;
assign instruction[17] = 32'b0000000000000000__0000000000000000;
assign instruction[18] = 32'b0000000000000000__0000000000000000;
assign instruction[19] = 32'b0000000000000000__0000000000000000;
assign instruction[20] = 32'b0000000000000000__0000000000000000;
assign instruction[21] = 32'b0000000000000000__0000000000000000;
assign instruction[22] = 32'b0000000000000000__0000000000000000;
assign instruction[23] = 32'b0000000000000000__0000000000000000;
assign instruction[24] = 32'b0000000000000000__0000000000000000;
assign instruction[25] = 32'b0000000000000000__0000000000000000;
assign instruction[26] = 32'b0000000000000000__0000000000000000;
assign instruction[27] = 32'b0000000000000000__000_111_11011_01101; // R[7] = Mem[27]