.macro put (%x, %y, $c)
	add $a0, $zero, %x
	add $a1, $zero, %y
	lb $a2, $c
	jal put
.end_macro

.macro strcpy ($des, $src)
	la $a0, $des
	la $a1, $src
	jal strcpy
.end_macro

.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

.macro print_char(%x)
	li $v0, 11
	add $a0, $zero, %x
	syscall
.end_macro

.macro get(%x, %y, %c)
	add $a0, $zero, %x
	add $a1, $zero, %y
	jal get
	move %c, $v0
.end_macro
