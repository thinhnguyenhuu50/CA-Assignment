.text
    .globl  main
main:
    jal     print
    jal     clear
    # Exit program
    li      $v0,    10  # Syscall code for exit
    syscall
