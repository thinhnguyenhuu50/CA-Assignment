.include "main_macro.asm"
.text
    .globl  main
    .globl 	game_loop
    .globl 	win
    .globl	tie
main:
    INIT
game_loop:
    PRINT_BOARD
    GET_MOVE
    UPDATE_BOARD
    CHECK_WIN
    CHECK_TIE
    SWITCH_PLAYER_TURN
win: 
	PRINT_BOARD
	PRINT_WIN
	HALT # End program
tie:
	PRINT_BOARD
	PRINT_TIE
	HALT
