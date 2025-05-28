.include "main_macro.asm"
.text
    .globl	main
    .globl 	game_loop
    .globl 	win
    .globl	tie
    .globl	exit
    .globl	new
    .globl	load
    .globl	surrender
main:
    MENU
    SETTING
new:
    INIT
    INIT_SETTING
    CLEAR_FILE_LOAD
    j game_loop
load:
    INIT
    INIT_SETTING
    LOAD
game_loop:
    PRINT_BOARD
    GET_MOVE
    UPDATE_BOARD
    CHECK_WIN
    CHECK_TIE
    SWITCH_PLAYER_TURN
    SAVE_GAME
surrender:
    SWITCH_PLAYER_TURN
win: 
	PRINT_BOARD
	PRINT_WIN
	CLEAR_FILE_LOAD
	HALT # End program
tie:
	PRINT_BOARD
	PRINT_TIE
	CLEAR_FILE_LOAD
	HALT # End program
exit:
	HALT
