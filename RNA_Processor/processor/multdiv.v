module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here
    wire [31:0] regA, regB;
    wire neg_clock;
    not clock_neg(neg_clock, clock);
    register32 registerA(data_operandA, regA, ctrl_MULT, clock, ctrl_MULT);
    register32 registerB(data_operandB, regB, ctrl_MULT, clock, ctrl_MULT);

    wire [31:0] outMult, quotient_Div, remainder_Div;
    wire mult_or_div, start_of_op, readyMult, exceptionMult, readyDiv, exceptionDiv;

    or op_Start(start_of_op, ctrl_MULT, ctrl_DIV);
    dffe_ref check_which_op(mult_or_div, ctrl_MULT, clock, start_of_op, 1'b0);

    multiplication mult(data_operandA, data_operandB, ctrl_MULT, clock, mult_or_div, outMult, exceptionMult, readyMult);
    division div(data_operandA, data_operandB, ctrl_DIV, clock, mult_or_div, quotient_Div, remainder_Div, exceptionDiv, readyDiv);

    // multiplication mult(regA, regB, ctrl_MULT, clock, mult_or_div, outMult, exceptionMult, readyMult);
    // division div(regA, regB, ctrl_DIV, clock, mult_or_div, quotient_Div, remainder_Div, exceptionDiv, readyDiv);

    // assign data_resultRDY = readyMult ? readyMult : readyDiv;
    // assign data_exception = readyMult ? exceptionMult : exceptionDiv;
    // assign data_result = readyMult? outMult: quotient_Div;

    assign data_resultRDY = mult_or_div ? readyMult : readyDiv;
    assign data_exception = mult_or_div ? exceptionMult : exceptionDiv;
    assign data_result = mult_or_div ? outMult : quotient_Div;

    /* assign data_resultRDY = readyMult;
    assign data_exception = exceptionMult;
    assign data_result = outMult; */
endmodule