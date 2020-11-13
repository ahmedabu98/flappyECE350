module SRA16(A, result);
    input [31:0] A;
    output [31:0] result;

    assign result[31] = A[31];
    assign result[30] = A[31];
    assign result[29] = A[31];
    assign result[28] = A[31];
    assign result[27] = A[31];
    assign result[26] = A[31];
    assign result[25] = A[31];
    assign result[24] = A[31];
    assign result[23] = A[31];
    assign result[22] = A[31];
    assign result[21] = A[31];
    assign result[20] = A[31];
    assign result[19] = A[31];
    assign result[18] = A[31];
    assign result[17] = A[31];
    assign result[16] = A[31];
    
    assign result[15] = A[31];
    assign result[14] = A[30];
    assign result[13] = A[29];
    assign result[12] = A[28];
    assign result[11] = A[27];
    assign result[10] = A[26];
    assign result[9] = A[25];
    assign result[8] = A[24];
    assign result[7] = A[23];
    assign result[6] = A[22];
    assign result[5] = A[21];
    assign result[4] = A[20];
    assign result[3] = A[19];
    assign result[2] = A[18];
    assign result[1] = A[17];
    assign result[0] = A[16];
endmodule
