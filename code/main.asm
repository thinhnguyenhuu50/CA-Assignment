.include "main_macro.asm"
.text
    .globl  main
    .globl 	game_loop
    .globl 	win
    .globl	tie
main:
    INIT
    MENU
    LOAD
game_loop:
    PRINT_BOARD
    GET_MOVE
    UPDATE_BOARD
    CHECK_WIN
    CHECK_TIE
    SWITCH_PLAYER_TURN
    SAVE_GAME
win: 
	PRINT_BOARD
	PRINT_WIN
	HALT # End program
tie:
	PRINT_BOARD
	PRINT_TIE
	HALT # End program
exit:
	HALT
