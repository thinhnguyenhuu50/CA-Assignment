.include "macro.asm"
.data
.text
.globl menu
menu:
	# push
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# body
print_str ("\n+--------------------------------------+\n|             GOMUKO MENU              |\n+--------------------------------------+\n| [1] > New Game                       |\n| [2] > Continue                       |\n| [0] > Exit                           |\n+--------------------------------------+\nPlease enter your choice: ")
li $v0, 5
syscall
loop:
bgt $v0, 2, loop1
bgt $v0, -1, return
loop1:
print_str ("Invalid! Please enter again: ")
li $v0, 5
syscall
j loop
return:
	# pop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
