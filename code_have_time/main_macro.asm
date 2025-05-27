.include "macro.asm"
.data
	init_board: 			.asciiz "   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14\n0  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n1  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n2  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n3  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n4  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n5  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n6  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n7  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n8  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n9  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n10 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n11 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n12 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n13 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n14 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n"
	X:					.asciiz "X"
	O: 					.asciiz "O"
	timer:				.word 1, 1800, 1800	# timer[0]: X, timer[1]: O (second)
	cur_time:				.word 0
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
    la $a0, timer
    jal print_time
    li $v0, 4           # Syscall for print string
    la $a0, board      
    syscall
.end_macro

.macro GET_MOVE
	get_time($t0)
	sw $t0, cur_time
	
	move $a0, player
	la $a1, timer
	la $a2, cur_time
	jal get_move
	move x, $v0
	move y, $v1
	
	get_time($t0)
	lw $t1, cur_time
	sub $t0, $t0, $t1
	la $t1, timer
	sll $t2, player, 2
	add $t1, $t2, $t1
	lw $t2, 0($t1)
	sub $t2, $t2, $t0
	sw $t2, 0($t1)
.end_macro

.macro UPDATE_BOARD
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
	move $a0, player
	la $a1, timer
	jal check_time
	beq $v1, 0, surrender
	beq $v0, 1, win
.end_macro

.macro CHECK_TIE
	beq move_count, 225, tie # 15x15
.end_macro

.macro SWITCH_PLAYER_TURN
	xori player, player, 3
.end_macro

.macro PRINT_WIN
	jal win_process
	jal play_again
	beq $v0, 1, new
.end_macro

.macro PRINT_TIE
	jal tie_process
	jal play_again
	beq $v0, 1, new
.end_macro

.macro HALT
	li $v0 10
	syscall
.end_macro

.macro MENU
	jal menu
	beq $v0, 0, exit
	beq $v0, 1, new
	beq $v0, 2, load
.end_macro

.macro LOAD
	la $a0, timer
	jal load_game
	move player, $v0
	move move_count, $v1
.end_macro

.macro SAVE_GAME
	move $a0, x
	move $a1, y
	la $a2, timer
	jal save_game
        j game_loop
.end_macro

.macro SETTING
	jal setting
	j main
.end_macro

.macro CLEAR_FILE_LOAD
	jal clear_load
.end_macro

.macro INIT_SETTING
	la $a0, timer
	jal init_setting
.end_macro
