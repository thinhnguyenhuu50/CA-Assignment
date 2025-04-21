.text
.macro INIT
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