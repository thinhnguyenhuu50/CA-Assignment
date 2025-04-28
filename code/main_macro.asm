.include "macro.asm"
.data
	init_board: 			.asciiz "   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14\n0  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n1  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n2  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n3  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n4  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n5  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n6  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n7  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n8  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n9  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n10 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n11 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n12 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n13 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n14 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n"
	X:						.asciiz "X"
	O: 						.asciiz "O"
.eqv		player		$s7 	# 1: X, 2: O
.eqv		move_count	$s6
# Current (x, y)
.eqv		x			$s5		
.eqv		y			$s4

.macro INIT    
	strcpy(board, init_board)
	li player, 1
	li move_count, 0
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
	move x, $v0
	move y, $v1
	bne player, 1, else
	put(x, y, X)
	j end_if
else:
	put(x, y, O)
end_if:
	addi move_count, move_count, 1 # increase 1 turn
.end_macro
	
.macro CHECK_WIN
	move $a0, x
	move $a1, y
	jal check_win  # check win
	beq $v0, 1, win
.end_macro

.macro CHECK_TIE
	beq move_count, 225, tie # 15x15
.end_macro

.macro SWITCH_PLAYER_TURN
	xori player, player, 3
	j game_loop
.end_macro

.macro PRINT_WIN
	jal win_process
	jal play_again
	beq $v0, 1, main
.end_macro

.macro PRINT_TIE
	jal tie_process
	jal play_again
	beq $v0, 1, main
.end_macro

.macro HALT
	li $v0 10
	syscall
.end_macro
