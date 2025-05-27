.include "macro.asm"
# Arguments
# $v0: 1 (yes), 0 (no)
.data
	buffer: 	.space  4
.text
.globl play_again
play_again:
	# push
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# body
loop:
	print_str("Do you want to play again?(y/n): ")
	la $a0, buffer
	li $a1, 4
	li $v0 8
	syscall
	print_str("\n")
	lb $t0, buffer
	beq $t0, 121, yes # 'y'
	beq $t0, 110, no # 'n'
	j loop

yes:
	li $v0, 1
	j return
no:
	li $v0, 0
return:
	# pop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
