.include "macro.asm"
.data
	init_board: 			.asciiz "   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14\n0                                             \n1                                             \n2                                             \n3                                             \n4                                             \n5                                             \n6                                             \n7                                             \n8                                             \n9                                             \n10                                            \n11                                            \n12                                            \n13                                            \n14                                            \n"
	X:						.asciiz "X"
	O: 						.asciiz "O"
.eqv		player		$s7 	# 1: X, 2: O
.eqv		move_count	$s6

.macro INIT    
	strcpy(board, init_board)
	li player, 1
.end_macro

.macro PRINT_BOARD
    li $v0, 4           # Syscall for print string
    la $a0, board      
    syscall
.end_macro

.macro GET_MOVE
	move $a0, player
	jal get_move
.end_macro

.macro UPDATE_BOARD
	move $t0, $v0
	move $t1, $v1
	bne player, 1, else
	put($t0,$t1,X)
	j end_if
else:
	put($t0,$t1,O)
end_if:
.end_macro

.macro CHECK_WIN
.end_macro

.macro CHECK_TIE
.end_macro

.macro SWITCH_PLAYER_TURN
	xori player, player, 3
	j game_loop
.end_macro

.macro PRINT_WIN
.end_macro

.macro PRINT_TIE
.end_macro

.macro HALT
	li $v0 10
	syscall
.end_macro
