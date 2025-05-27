.include "macro.asm"
.data
save_file: .asciiz "save\\board.txt"
time_file: .asciiz "save\\playertime.txt"
buffer: .word 0
#Argument
# $a0: x
# $a1: y
# $a2: timer
.text
.globl save_game
save_game:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $a2, 8($sp)      # for file descriptor
	# body
	li $t0, 50
	mul $a0, $a0, 47
	mul $a1, $a1, 3
	add $t0, $a0, $t0
	add $t0, $a1, $t0
	la $a1, buffer       # buffer address
 	sw $t0, 0($a1)
 # Write into save_file
# 1. Open file (mode = 1 for write)
    li $v0, 13
    la $a0, save_file      # file name
    li $a1, 9         # mode = 1 (write)
    syscall
    move $s0, $v0     # file descriptor ? $s0
# 2. Write to file
    li $v0, 15
    move $a0, $s0         # file descriptor
    la $a1, buffer       # buffer address
    li $a2, 4           # number of bytes (manual!)
    syscall
# 3. Close file
    li $v0, 16
    move $a0, $s0
    syscall
  # Write into save_file
# 1. Open file (mode = 1 for write)
    li $v0, 13
    la $a0, time_file      # file name
    li $a1, 1         # mode = 1 (write)
    syscall
    move $s0, $v0     # file descriptor ? $s0
# 2. Write to file
    li $v0, 15
    move $a0, $s0         # file descriptor
    lw $a1, 8($sp)       # buffer address
    li $a2, 8           # number of bytes (manual!)
    syscall
# 3. Close file
    li $v0, 16
    move $a0, $s0
    syscall
return:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 12
    jr $ra
