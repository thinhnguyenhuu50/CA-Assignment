# Arguments:
#   $a0: destination string address
#   $a1: source string address
.text
.globl strcpy
strcpy:
    # Initialize loop
    move $t0, $a0        # $t0 = destination pointer
    move $t1, $a1        # $t1 = source pointer

copy_loop:
    lb $t2, 0($t1)      # Load byte from source
    sb $t2, 0($t0)      # Store byte to destination
    beq $t2, $zero, done # If null terminator, exit loop
    addi $t0, $t0, 1    # Increment destination pointer
    addi $t1, $t1, 1    # Increment source pointer
    j copy_loop         # Repeat loop

done:
    jr $ra              # Return