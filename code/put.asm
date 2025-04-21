.include "globle_var.asm"
.data
	X: 				.asciiz "X"
.text
.globl put
put:
	li $t4, 50
	mul $t0, $t0, 47
	mul $t1, $t1, 3
	add $t4, $t0, $t4
	add $t4, $t1, $t4
	la $t3, X
	lb $t3, 0($t3)
	sb $t3, board($t4)
	
	jr $ra