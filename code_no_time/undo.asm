.include "macro.asm"
.data
	buffer: .space 900
	load_file: .asciiz "save\\board.txt"
.text
.globl undo
undo:
# Save registers
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)      # for file descriptor
    sw $a0, 8($sp)
    sw $s1, 12($sp)
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
li $a2, 900
syscall
move $t0, $v0
# 3. Close file
li $v0, 16
move $a0, $s0
syscall
beq $t0, 0, new
addi $s1, $t0, -4
# Write into save_file
# 1. Open file (mode = 1 for write)
    li $v0, 13
    la $a0, load_file      # file name
    li $a1, 1         # mode = 1 (write)
    syscall
    move $s0, $v0     # file descriptor ? $s0
# 2. Write to file
    li $v0, 15
    move $a0, $s0         # file descriptor
    la $a1, buffer       # buffer address
    move $a2, $s1          # number of bytes (manual!)
    syscall
# 3. Close file
    li $v0, 16
    move $a0, $s0
    syscall
#return
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 12($sp)
    addi $sp, $sp, 16
    jr $ra