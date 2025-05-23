.include "macro.asm"
.data
save_file: .asciiz "save.txt"
buffer: .space 755
.text
.globl save_game
save_game:
    # Save registers
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)      # for file descriptor
	# body
    la $t0, buffer
    sb $a0, 0($t0)
    sb $a1, 1($t0)
    addi $t0, $t0, 2
    move $a0, $t0
    la $a1, board
    jal strcpy
    la $t0, buffer
    li $t1, 10
    sb $t1, 753($t0)
    sb $0, 754($t0)
    
 # Write into save_file
# 1. Open file (mode = 1 for write)
    li $v0, 13
    la $a0, save_file      # file name
    li $a1, 1         # mode = 1 (write)
    syscall
    move $s0, $v0     # file descriptor ? $s0
# 2. Write to file
    li $v0, 15
    move $a0, $s0         # file descriptor
    la $a1 buffer      # buffer address
    li $a2, 755           # number of bytes (manual!)
    syscall
# 3. Close file
    li $v0, 16
    move $a0, $s0
    syscall
return:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
