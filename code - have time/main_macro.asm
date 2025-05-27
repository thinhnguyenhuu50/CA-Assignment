.include "macro.asm"
.data
	init_board: 			.asciiz "   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14\n0  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n1  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n2  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n3  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n4  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n5  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n6  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n7  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n8  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n9  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n10 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n11 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n12 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n13 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n14 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n"
	X:					.asciiz "X"
	O: 					.asciiz "O"
	timer:				.word 1800, 1800	# timer[0]: X, timer[1]: O (second)
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
    print_str("<-------------------------------------------------------------------->\n")
    print_str("Time Player 1: ")
    lw $t0, timer
    print_int($t0)
    print_str("                        Time Player 2: ")
    lw $t0, timer + 4
    print_int($t0)
    print_str("\n")
    li $v0, 4           # Syscall for print string
    la $a0, board      
    syscall
.end_macro

.macro GET_MOVE
	get_time($t0)
	sw $t0, Time
	move $a0, player
	la $a1, timer
	jal get_move
	move x, $v0
	move y, $v1
	get_time($t1)
	lw $t0, Time
	sub $t1, $t1, $t0
	sll $t2, player, 2
	addi $t2, $t2, -4
	la $t3, timer
	add $t3, $t3, $t2
	lw $t4, 0($t3)
	sub $t4, $t4, $t1
	sw $t4, 0($t3)
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
	beq $v0, 1, win
	sll $t2, player, 2
	addi $t2, $t2, -4
	la $t3, timer
	add $t3, $t3, $t2
	lw $t4, 0($t3)
	bgt $0, $t4, surrender
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

.macro MENU
	jal menu
	beq $v0, 0, exit
	beq $v0, 1, new
	beq $v0, 2, load
.end_macro

.macro LOAD
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
