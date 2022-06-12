%include "common"
start:
    mov r10, 0
    mov r1, 0
    mov r2, 1
    mov r3, 0
    call clearLine
    call resetCursor
    .main:
        call outputR1Int
        mov r3, r2
        mov r2, r1
        mov r7, r2
        add r7, r3
        mov r1, r7
        cmp r1, 1000
        jg .end
        jmp .main
.end:
    mov r1, endmsg
    call clearLine
    call printStr
    hlt
    jmp start
printStr:
.loop:
    mov r2, [r1]
    jz .end
    send r10, r2
    add r1, 1
    jmp .loop
.end:
    ret
outputR1Int:
    push 0
    mov r0, r1
.loop:
    mov r4, r0
    mov r5, 10
    call diR4R5R6
    mov r0, r6
    add r4, 48
    push r4
    cmp r0, 0
    je .bridge
    jmp .loop
.bridge:
    call clearLine
.out:
    pop r4
    jz .end
    send r10, r4
    jmp .out
.end:
    ret
diR4R5R6:
    mov r6, 0
    .loop:
        cmp r4, r5
        jl .end
        sub r4, r5
        add r6, 1
        jmp .loop
    .end:
        ret
resetCursor:
    send r10, 0x1000
    send r10, 0x200F
    ret
clearLine:
    call resetCursor
    send r10, 32
    send r10, 32
    send r10, 32
    call resetCursor
    ret
endmsg:
    dw "End"
    dw 0
