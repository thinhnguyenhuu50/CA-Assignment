.include "macro.asm"
.data
.text
.globl pause_game
pause_game:
	# push
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	move $s0, $a0
	move $s1, $a1
	# body
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
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
undo_game:
jal undo
j load
