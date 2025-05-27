#############################
.eqv 	empty 	46  # character '.'
#############################
# PUT
.macro put (%x, %y, $c)
	add $a0, $zero, %x
	add $a1, $zero, %y
	lb $a2, $c
	jal put
.end_macro
# GET
.macro get(%x, %y, %c)
	add $a0, $zero, %x
	add $a1, $zero, %y
	jal get
	move %c, $v0
.end_macro
#############################
# STRCPY
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

.macro print_str (%str)
	.data
			msg: .asciiz %str
	.text
	li $v0, 4
	la $a0, msg
	syscall
.end_macro

.macro get_time(%x) # x = time
	li $v0, 30
	div %x, $a0, 1000
.end_macro



