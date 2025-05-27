.include "macro.asm"
.data
setting_file: .asciiz "save\\setting.txt"
buffer: .word 1, 1800, 1800
enter: .space 4
.text
.globl setting
.globl init_setting
setting:
	# push
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	# body

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
li $a2, 12
syscall
move $t0, $v0
# 3. Close file
li $v0, 16
move $a0, $s0
syscall

loopx:
print_str ("\n+--------------------------------------+\n|              SETTING                 |\n+--------------------------------------+\n| [1] > Set time                       |\n| [2] > Set time player 1              |\n| [3] > Set time player 2              |\n| [4] > Reset                          |\n| [0] > Back                           |\n+--------------------------------------+\nPlease enter your choice: ")
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
	beq $v0, 1, set_time
	beq $v0, 2, set_time_player1
	beq $v0, 3, set_time_player2
	beq $v0, 4, reset_time
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra

set_time:
loopst:
	print_str("Does game have a time limit? (y/n): ")
	la $a0, enter
	li $a1, 4
	li $v0 8
	syscall
	print_str("\n")
	lb $t0, enter
	beq $t0, 121, yes # 'y'
	beq $t0, 110, no # 'n'
	j loopst
yes:
li $t0, 1
sw $t0, buffer
j writefile
no:
li $t0, 0
sw $t0, buffer
j writefile

set_time_player1:
print_str("Set time limit player 1: ")
li $v0, 5
syscall
la $t0, buffer
sw $v0, 4($t0)
print_str("\n")
j writefile

set_time_player2:
print_str("Set time limit player 2: ")
li $v0, 5
syscall
la $t0, buffer
sw $v0, 8($t0)
print_str("\n")
j writefile

reset_time:
li $t1, 1
li $t2, 1800
li $t3, 1800
la $t0, buffer
sw $t1, 0($t0)
sw $t2, 4($t0)
sw $t3, 8($t0)
j writefile

writefile:
  # Write into save_file
# 1. Open file (mode = 1 for write)
    li $v0, 13
    la $a0, setting_file      # file name
    li $a1, 1         # mode = 1 (write)
    syscall
    move $s0, $v0     # file descriptor ? $s0
# 2. Write to file
    li $v0, 15
    move $a0, $s0         # file descriptor
    la $a1, buffer      # buffer address
    li $a2, 12           # number of bytes (manual!)
    syscall
# 3. Close file
    li $v0, 16
    move $a0, $s0
    syscall
j loopx
init_setting:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	move $s1, $a0
	# Open file input (mode 0 = read)
li $v0, 13
la $a0, setting_file  
li $a1, 0          # mode 0 = read
syscall
move $s0, $v0      
# Read file input
li $v0, 14
move $a0, $s0      # File descriptor
move $a1, $s1    # Buffer input
li $a2, 12
syscall
# 3. Close file
li $v0, 16
move $a0, $s0
syscall

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra




