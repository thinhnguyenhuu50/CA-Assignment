.include "macro.asm"
.data
Dx: .word 1, 0, 1, 1
Dy: .word 0, 1, 1, -1

.text
.globl check_win
# Arguments:
#   $a0: x
#   $a1: y
#	$v0: 1 (win)
check_win:
	#$t0 = Player
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	get($a0, $a1, $t0)
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	#$t7 = loop count
	addi $t7, $0, 0
	li $v0, 0
check_win_for:
	#$t6 = 4
	addi $t6, $0, 4
	beq $t6, $t7, check_win_exit
	#$t1 = count
	addi $t1, $0, 1
#Direction (+)
addi $t2, $0, 1
check_win_loop1:
	#$t2 = i: 1 to ...
	#$t3 = Dx[$t7]
	#($t3 = $a0 + Dx*i, $t4 = $a0 + Dy*i)
sll $t5, $t7, 2
la $t3, Dx
add $t3, $t5, $t3 
lw $t3, 0($t3)
mul $t3, $t3, $t2
add $t3, $t3, $a0
	#$t4 = Dy[$t7]
la $t4, Dy
add $t4, $t5, $t4
lw $t4, 0($t4)
mul $t4, $t4, $t2
add $t4, $t4, $a1
	#$t5 = 15
addi $t5, $0, 14
blt $t5, $t3, check_win_exit1
blt $t5, $t4, check_win_exit1
blt $t3, $0, check_win_exit1
blt $t4, $0, check_win_exit1
	#$t5 = ($t3 = $a0 + Dx*i, $t4 = $a1 + Dy*i)
addi $sp, $sp, -44
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $t4, 16($sp)
sw $t6, 20($sp)
sw $t7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $v0, 36($sp)
sw $ra, 40($sp)
get($t3, $t4, $t5)
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $t4, 16($sp)
lw $t6, 20($sp)
lw $t7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $v0, 36($sp)
lw $ra, 40($sp)
addi $sp, $sp, 44
bne $t0, $t5, check_win_exit1
#if($t0 != $t5) check_win_exit1
addi $t1, $t1, 1
addi $t2, $t2, 1
addi $t5, $0, 4
blt $t5, $t1, check_win_true
j check_win_loop1
#Direction (-)
check_win_exit1:

addi $t2, $0, 1
check_win_loop2:
	#$t2 = i: 1 to ...
	#$t3 = Dx[$t7]
	#($t3 = $a0 - Dx*i, $t4 = $a1 - Dy*i)
sll $t5, $t7, 2
la $t3, Dx
add $t3, $t5, $t3 
lw $t3, 0($t3)
mul $t3, $t3, $t2
sub $t3, $a0, $t3
	#$t4 = Dy[$t7]
la $t4, Dy
add $t4, $t5, $t4
lw $t4, 0($t4)
mul $t4, $t4, $t2
sub $t4, $a1, $t4
	#$t5 = 15
addi $t5, $0, 14
blt $t5, $t3, check_win_exit2
blt $t5, $t4, check_win_exit2
blt $t3, $0, check_win_exit2
blt $t4, $0, check_win_exit2
	#$t5 = ($t3 = $a0 + Dx*i, $t4 = $a0 + Dy*i)
addi $sp, $sp, -44
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $t4, 16($sp)
sw $t6, 20($sp)
sw $t7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $v0, 36($sp)
sw $ra, 40($sp)
get($t3, $t4, $t5)
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $t4, 16($sp)
lw $t6, 20($sp)
lw $t7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $v0, 36($sp)
lw $ra, 40($sp)
addi $sp, $sp, 44
bne $t0, $t5, check_win_exit2
#if($t0 != $t5) check_win_exit1
addi $t1, $t1, 1
addi $t2, $t2, 1
addi $t5, $0, 4
blt $t5, $t1, check_win_true
j check_win_loop2
check_win_exit2:
addi $t7, $t7, 1
j check_win_for
check_win_exit:
j check_win_return
check_win_true:
li $v0, 1
check_win_return:
jr $ra
