.data
.text
.globl check_win
# Arguments:
#   $a0: x
#   $a1: y
#	$v0: 1 (win)
check_win:
		
	li $v0, 0
	jr $ra
