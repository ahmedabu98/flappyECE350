module SRA1(A, result);
    input [31:0] A;
    output [31:0] result;

    assign result[31]=A[31];
    assign result[30] = A[31];
    assign result[29] = A[30];
    assign result[28] = A[29];
    assign result[27] = A[28];
    assign result[26] = A[27];
    assign result[25] = A[26];
    assign result[24] = A[25];
    assign result[23] = A[24];
    assign result[22] = A[23];
    assign result[21] = A[22];
    assign result[20] = A[21];
    assign result[19] = A[20];
    assign result[18] = A[19];
    assign result[17] = A[18];
    assign result[16] = A[17];
    assign result[15] = A[16];
    assign result[14] = A[15];
    assign result[13] = A[14];
    assign result[12] = A[13];
    assign result[11] = A[12];
    assign result[10] = A[11];
    assign result[9] = A[10];
    assign result[8] = A[9];
    assign result[7] = A[8];
    assign result[6] = A[7];
    assign result[5] = A[6];
    assign result[4] = A[5];
    assign result[3] = A[4];
    assign result[2] = A[3];
    assign result[1] = A[2];
    assign result[0] = A[1];
endmodule