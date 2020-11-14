# initialization
addi $9, $0, 9

ONES:
beq $1, $9, TENS
addi $1, $1, 1
j ONES

TENS:
beq $2, $9, HUNDREDS
add $1, $0, $0
addi $2, $2, 1
j ONES

HUNDREDS:
beq $3, $9, THOUSANDS
add $2, $0, $0
add $1, $0, $0
addi $3, $3, 1
j ONES

THOUSANDS:
beq $4, $9, RESET
add $3, $0, $0
add $2, $0, $0
add $1, $0, $0
addi $4, $4, 1
j ONES

RESET:
add $4, $0, $0
add $3, $0, $0
add $2, $0, $0
add $1, $0, $0
j ONES