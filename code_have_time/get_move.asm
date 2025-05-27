.include "macro.asm"
# Arguments:
#   $a0: current player
#    $a1: timer
#    $a2: cur_time
#	$v0: x
#	$v1: y
.data
	prompt1:        .asciiz "Player 1, please input your coordinates: "
	prompt2:        .asciiz "Player 2, please input your coordinates: "
	error_msg:      .asciiz "Invalid input, try again\n"
	input_buffer:   .space 5   # Buffer for input string
	null: .space 1
.text
.globl get_move
get_move:
	# Save registers
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)    # Save $s0 (current player)
    sw $s1, 8($sp)    # Save $s1 (for temp use if needed)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    move $s0, $a0     # Store current player
    move $s3, $a1
    move $s4, $a2
input_loop:
    # Display prompt based on current player
    li $v0, 4         # Syscall to print string
    beq $s0, 1, print_prompt1
    la $a0, prompt2   # "Player 2, please input your coordinates: "
    j print_prompt
print_prompt1:
    la $a0, prompt1   # "Player 1, please input your coordinates: "
print_prompt:
    syscall

    # Read input string
    li $v0, 8         # Syscall to read string
    la $a0, input_buffer
    li $a1, 10        # Max length of input
    syscall
    # Check input string is pause
    lb $t0, 0($a0)
    bne $t0, 80, skip_pause
    move $a0, $s0
    move $a1, $s3
    move $a2, $s4
    jal pause_game
skip_pause:
    # Call parse_input to validate and extract x,y
    la $a0, input_buffer
    jal parse_input   # Returns $v0 = x or -1, $v1 = y

    # Check if input is invalid
    li $t0, -1
    beq $v0, $t0, invalid_input

    # Input is valid, return x,y
	# x already in $v0
	# y in $v1
    j get_move_exit

invalid_input:
    # Print error message
    li $v0, 4
    la $a0, error_msg # "Invalid input, try again"
    syscall
    j input_loop      # Re-prompt

get_move_exit:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra
    
# Input: $a0 = address of input string
# Output: 
#   - If valid: $v0 = x coordinate (0-14), $v1 = y coordinate (0-14)
#   - If invalid: $v0 = -1
parse_input:
    # Save registers
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)    # Save input string address
    sw $s1, 8($sp)    # Save x value
    sw $s2, 12($sp)   # Save y value
    sw $s3, 16($sp)   # Save temp register
    move $s0, $a0     # Store input string address

    # Initialize x and y
    li $s1, 0         # x = 0
    li $s2, 0         # y = 0

    # Step 1: Parse x (digits before comma)
parse_x:
    lb $t0, 0($s0)    # Load current character
    beq $t0, 44, end_parse_x  # If comma (ASCII 44), end x parsing
    beq $t0, 0, invalid  # If null, invalid
    beq $t0, 10, invalid # If newline, invalid

    # Check if character is a digit (0-9)
    blt $t0, 48, invalid  # < '0'
    bgt $t0, 57, invalid  # > '9'

    # Update x = x * 10 + (char - '0')
    mul $s1, $s1, 10  # x *= 10
    sub $t0, $t0, 48  # Convert char to integer
    add $s1, $s1, $t0 # x += digit

    addi $s0, $s0, 1  # Move to next character
    j parse_x

end_parse_x:
    addi $s0, $s0, 1  # Skip comma
    # Step 2: Parse y (digits after comma)
parse_y:
    lb $t0, 0($s0)    # Load current character
    beq $t0, 10, end_parse_y  # If newline, end y parsing
    beq $t0, 0, end_parse_y   # If null, end y parsing

    # Check if character is a digit
    blt $t0, 48, invalid  # < '0'
    bgt $t0, 57, invalid  # > '9'

    # Update y = y * 10 + (char - '0')
    mul $s2, $s2, 10  # y *= 10
    sub $t0, $t0, 48  # Convert char to integer
    add $s2, $s2, $t0 # y += digit

    addi $s0, $s0, 1  # Move to next character
    j parse_y

end_parse_y:
    # Step 3: Validate x and y range (0-14)
    blt $s1, 0, invalid   # x < 0
    bgt $s1, 14, invalid  # x > 14
    blt $s2, 0, invalid   # y < 0
    bgt $s2, 14, invalid  # y > 14

    # Step 4: Check if board position is empty
    get($s1, $s2, $v0)
    bne $v0, empty, invalid  # If not empty, position is occupied

    # Step 5: Valid input, return x, y
    move $v0, $s1         # Return x
    move $v1, $s2         # Return y
    j parse_input_exit

invalid:
    li $v0, -1            # Return -1 for invalid input

parse_input_exit:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra
