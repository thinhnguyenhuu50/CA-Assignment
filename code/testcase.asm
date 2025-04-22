.include "macro.asm"
.data
	X: 	.asciiz "X"
.text
##########################################################
.globl test_put
test_put:
    addi $sp, $sp, -12       # Allocate space for $ra, $s0, $s1
    sw $ra, 8($sp)           # Store return address
    sw $s0, 4($sp)           # Store $s0
    sw $s1, 0($sp)           # Store $s1
    li $s0, 0                # $s0 = i
outer_loop:
    # Check if i < 15
    slti $t0, $s0, 15        # $t0 = 1 if i < 15, else 0
    beq $t0, $zero, end_outer # Exit outer loop if i >= 15
    # Initialize inner loop counter j = 0
    li $s1, 0                # $s1 = j
inner_loop:
    # Check if j < 15
    slti $t1, $s1, 15        # $t1 = 1 if j < 15, else 0
    beq $t1, $zero, end_inner # Exit inner loop if j >= 15
    # Add your instructions here, e.g., print i ($s0) and j ($s1) or perform computations
	put($s0, $s1, X)
    # Increment j
    addi $s1, $s1, 1         # j++
    j inner_loop             # Repeat inner loop
end_inner:
    # Increment i
    addi $s0, $s0, 1         # i++
    j outer_loop             # Repeat outer loop

end_outer:
    # Restore saved registers and return address
    lw $s1, 0($sp)           # Restore $s1
    lw $s0, 4($sp)           # Restore $s0
    lw $ra, 8($sp)           # Restore return address
    addi $sp, $sp, 12        # Deallocate stack space
    # Return to caller
    jr $ra
##########################################################