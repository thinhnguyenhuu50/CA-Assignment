.include "macro.asm"
.data
	buffer: .space 900
	load_file: .asciiz "save\\board.txt"
	time_file: .asciiz "save\\playertime.txt"
	setting_file: .asciiz "save\\setting.txt"
#Argument
# $a0: timer 
.text
.globl load_game
.globl clear_load
load_game:
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

# write into board
move $s1, $t0
addi $s0, $t0, -4
li $t0, 0
loop1: bgt $t0, $s0, skip1
la $t1, buffer
add $t1, $t0, $t1
lw $t1, 0($t1)
li $t2, 88
sb $t2, board($t1)
addi $t0, $t0, 8
j loop1
skip1:

li $t0, 4
loop2: bgt $t0, $s0, skip2
la $t1, buffer
add $t1, $t0, $t1
lw $t1, 0($t1)
li $t2, 79
sb $t2, board($t1)
addi $t0, $t0, 8
j loop2
skip2:

# Open file input (mode 0 = read)
li $v0, 13
la $a0, setting_file  
li $a1, 0          # mode 0 = read
syscall
move $s0, $v0      
# Read file input
li $v0, 14
move $a0, $s0      # File descriptor
la $a1, buffer    # Buffer input
syscall
move $t0, $v0
# 3. Close file
li $v0, 16
move $a0, $s0
syscall

lw $t0, buffer
beq $t0, 0, return

# Open file input (mode 0 = read)
li $v0, 13
la $a0, time_file  
li $a1, 0          # mode 0 = read
syscall
move $s0, $v0      
# Read file input
li $v0, 14
move $a0, $s0      # File descriptor
lw $a1, 8($sp)    # Buffer input
li $a2, 8
syscall
# 3. Close file
li $v0, 16
move $a0, $s0
syscall

return:
    div $s1, $s1, 4
    andi $t0, $s1, 1
    li $v0, 1
    beq $t0, 0, even    
    li $v0, 2
even:
    move $v1, $s1
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 12($sp)
    addi $sp, $sp, 16
    jr $ra
clear_load:
    li   $v0, 13          # syscall: open file
    la   $a0, load_file    # tên file
    li   $a1, 1           # mode = 1 → write → clear file
    li   $a2, 0
    syscall
    move $s0, $v0         # lưu file descriptor

    move $a0, $s0
    li   $v0, 16          # syscall: close file
    syscall
    jr $ra