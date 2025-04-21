.data
	init_board: 			.asciiz "   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14\n0                                             \n1                                             \n3                                             \n2                                             \n4                                             \n5                                             \n6                                             \n7                                             \n8                                             \n9                                             \n10                                            \n11                                            \n12                                            \n13                                            \n14                                            "
.text
.macro INIT    
	strcpy(board, init_board)
	put(14,14)
.end_macro

.macro PRINT_BOARD
    li $v0, 4           # Syscall for print string
    la $a0, board      # Buffer with file contents
    syscall
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

.macro strcpy ($des, $src)
	la $a0, $des
	la $a1, $src
	jal strcpy
.end_macro