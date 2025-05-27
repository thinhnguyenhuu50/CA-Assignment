.include "macro.asm"
.data
.text
.globl pause_game
pause_game:
# $a0: currrent player
# $a1: timer
# $a2: cur_time
	# push
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	# body
	#pause time
	get_time($t0)
	lw $t1, 0($s2)
	sub $t0, $t0, $t1
	move $t1, $s1
	sll $t2, $s0, 2
	add $t1, $t2, $t1
	lw $t2, 0($t1)
	sub $t2, $t2, $t0
	sw $t2, 0($t1)
	#print
	print_str ("\n+--------------------------------------+\n|               PAUSE                  |\n+--------------------------------------+\n| [1] > Back to game                   |\n| [2] > Surrender                      |\n| [3] > Undo                           |\n| [4] > Return to menu                 |\n| [0] > Save and exit                  |\n+--------------------------------------+\nPlease enter your choice: ")
	li $v0, 5
	syscall
loop:
	bgt $v0, 4, loop1
	bgt $v0, -1, return
loop1:
	print_str ("Invalid! Please enter again: ")
	li $v0, 5
	syscall
	j loop
return:
	# pop
	beq $v0, 2, surrender
	beq $v0, 3, undo_game
	beq $v0, 4, main
	beq $v0, 0, exit
	#set cur time
	get_time($t0)
	sw $t0, 0($s2)
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
undo_game:
jal undo
j load
