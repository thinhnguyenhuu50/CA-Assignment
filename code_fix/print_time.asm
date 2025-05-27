.include "macro.asm"
.data
.text
.globl print_time
print_time:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	move $s0, $a0
	print_str("+---------------------------------------------+\n          [Press P to Pause game]          \nTime P1: ")
	lw $t0, 0($s0)
	beq $t0, $0, print_none1
	lw $t0, 4($s0)
	print_int($t0)
	print_str("s")
	j skip1
print_none1:
	print_str("none")
skip1:
	print_str("             Time P2: ")
	lw $t0, 0($s0)
	beq $t0, $0, print_none2
	lw $t0, 8($s0)
	print_int($t0)
	print_str("s")
	j return
print_none2: 
	print_str("none")
return:
	print_str("\n")
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra