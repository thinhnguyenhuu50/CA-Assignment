.data
result_file: .asciiz "result.txt"
p1_win_msg: .asciiz "Player 1 wins\n"
p2_win_msg: .asciiz "Player 2 wins\n"
tie_msg: .asciiz "Tie\n"

.text
.globl win_process
.globl tie_process

# Print the result and write it into file
# Note: Open file with flag 9 for write-only with create and append.
win_process:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)      # for file descriptor
    sw $t0, 8($sp)      # for msg addr  

    # Determine winner msg
    bne $s7, 1, p2_wins # $s7 = player
    la $a0, p1_win_msg
    la $t0, p1_win_msg  # store msg addr for later
    j write_result
p2_wins:
    la $a0, p2_win_msg
    la $t0, p2_win_msg  # store msg addr for later

write_result:
    # Print winner msg to console
    li $v0, 4
    syscall

    # Open file "result.txt"
    li $v0, 13
    la $a0, result_file
    li $a1, 9           # Write-only, create, append
    li $a2, 438         # File mode
    syscall
    move $s0, $v0       # Save file descriptor      

    # Write winner msg to file
    li $v0, 15
    move $a0, $s0
    move $a1, $t0       # load msg addr from $t0
    li $a2, 14          # Size of "Player X wins\n"
    syscall

    # Write board to file
    li $v0, 15
    move $a0, $s0
    la $a1, board
    li $a2, 752         # Size of the board
    syscall

    # Close file
    li $v0, 16
    move $a0, $s0
    syscall

    # Restore registers
    lw $t0, 8($sp)       
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra


tie_process:
    # Save registers
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    # Print tie msg to console
    la $a0, tie_msg
    li $v0, 4
    syscall

    # Open file "result.txt"
    li $v0, 13
    la $a0, result_file
    li $a1, 9           # Write-only, create, append
    li $a2, 438         # File mode
    syscall
    move $s0, $v0       # Save file descriptor

    # Write tie msg to file
    li $v0, 15
    move $a0, $s0
    la $a1, tie_msg
    li $a2, 4           # Size of "Tie\n"
    syscall

    # Write board to file
    li $v0, 15
    move $a0, $s0
    la $a1, board
    li $a2, 752  
    syscall

    # Close file
    li $v0, 16
    move $a0, $s0
    syscall

    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra