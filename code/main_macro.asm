.include "macro.asm"
.data
	init_board: 			.asciiz "   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14\n0                                             \n1                                             \n3                                             \n2                                             \n4                                             \n5                                             \n6                                             \n7                                             \n8                                             \n9                                             \n10                                            \n11                                            \n12                                            \n13                                            \n14                                            \n"
	X:						.asciiz "X"
	O: 						.asciiz "O"
.eqv		player		$s7 	# 1: X, 2: O
.eqv		move_count	$s6

.macro INIT    
	strcpy(board, init_board)
.end_macro

.macro PRINT_BOARD
    li $v0, 4           # Syscall for print string
    la $a0, board      # Buffer with file contents
    syscall
.end_macro

.macro GET_MOVE
	#move $a0, player
	#jal get_move
	#print_int($v0)
	#print_int($v1)
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
