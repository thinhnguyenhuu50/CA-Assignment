.include "globle_var.asm"
.data
	init_board: 	.asciiz "init_board.txt"
.text
.macro INIT
	# Open file
    li $v0, 13          # Syscall for open file
    la $a0, init_board    # File name
    li $a1, 0           # Read-only mode
    li $a2, 0           # Mode (ignored)
    syscall
    move $s0, $v0       # Save file descriptor
    
    # Read from file
    li $v0, 14          # Syscall for read file
    move $a0, $s0       # File descriptor
    la $a1, board      # Buffer to store data
    li $a2, 752        # Number of bytes to read
    syscall
    
    # Close file
    li $v0, 16          # Syscall for close file
    move $a0, $s0       # File descriptor
    syscall
    
    put(0,0)  # write at 0,0
    
    # Print file contents
    li $v0, 4           # Syscall for print string
    la $a0, board      # Buffer with file contents
    syscall
.end_macro

.macro PRINT_BOARD
.end_macro

.macro GET_MOVE
.end_macro

.macro UPDATE_BOARD
.end_macro

.macro CHECK_WIN
.end_macro

.macro CHECK_TIE
.end_macro

.macro SWITCH_PLAYER_TURN
.end_macro

.macro PRINT_WIN
.end_macro

.macro PRINT_TIE
.end_macro

.macro HALT
	li $v0 10
	syscall
.end_macro
########################################################################
.macro put (%x, %y)
	add $t0, $zero, %x
	add $t1, $zero, %y
	jal put
.end_macro