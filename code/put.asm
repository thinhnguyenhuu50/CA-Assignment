# Arguments:
#   $a0: x
#   $a1: y
#	$a2: X or O
.text
.globl put
put:
	li $t0, 50
	mul $a0, $a0, 47
	mul $a1, $a1, 3
	add $t0, $a0, $t0
	add $t0, $a1, $t0
	sb $a2, board($t0)
	
	jr $ra