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

	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	#$s0 = Player
	get($a0, $a1, $s0)
	#$s1 = loop count
	li $s1, 4
check_win_for:
	beqz $s1, check_win_exit
	#$s2 = count
	addi $s2, $0, 1
#Direction (+)
	lw $s3, 4($sp)
	lw $s4, 8($sp)
check_win_loop1:
la $t0, Dx
sll $t1, $s1, 2
add $t0, $t0, $t1 
lw $t0, 0($t0)
add $s3, $s3, $t0
la $t0, Dy
sll $t1, $s1, 2
add $t0, $t0, $t1 
lw $t0, 0($t0)
add $s4, $s4, $t0

li $t0, 14
blt $t0, $s3, check_win_exit1
blt $t0, $s4, check_win_exit1
bltz $s3, check_win_exit1
bltz $s4, check_win_exit1
get($s3, $s4, $t0)
bne $t0, $s0, check_win_exit1

addi $s2, $s2, 1
addi $t0, $0, 4
blt $t0, $s2, check_win_true
j check_win_loop1

check_win_exit1:
#Direction (-)
	lw $s3, 4($sp)
	lw $s4, 8($sp)
check_win_loop2:
la $t0, Dx
sll $t1, $s1, 2
add $t0, $t0, $t1 
lw $t0, 0($t0)
sub $s3, $s3, $t0
la $t0, Dy
sll $t1, $s1, 2
add $t0, $t0, $t1 
lw $t0, 0($t0)
sub $s4, $s4, $t0

li $t0, 14
blt $t0, $s3, check_win_exit2
blt $t0, $s4, check_win_exit2
bltz $s3, check_win_exit2
bltz $s4, check_win_exit2
get($s3, $s4, $t0)
bne $t0, $s0, check_win_exit2

addi $s2, $s2, 1
addi $t0, $0, 4
blt $t0, $s2, check_win_true
j check_win_loop2

check_win_exit2:

addi $s1, $s1, -1
j check_win_for

check_win_exit:
li $v0, 0
j check_win_return

check_win_true:
li $v0, 1

check_win_return:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	addi $sp, $sp, 32
jr $ra