.include "macro.asm"
.data
buffer: .space 755
load_file: .asciiz "save.txt"
.text
.globl load_game
load_game:
    # Save registers
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)      # for file descriptor
	# body
# Open file input (mode 0 = read)
li $v0, 13
la $a0, load_file  
li $a1, 0          # mode 0 = read
syscall
move $s0, $v0      
# Read file input
li $v0, 14
move $a0, $s0      # File descriptor
la $a1, buffer    # Buffer input
li $a2, 755       
syscall
# 3. Close file
li $v0, 16
move $a0, $s0
syscall

la $a0, board
la $a1, buffer
addi $a1, $a1, 2
jal strcpy
la $t0, buffer
lb $v0, 0($t0)
lbu $v1, 1($t0)
return:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
