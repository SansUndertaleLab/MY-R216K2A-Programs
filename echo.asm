%include "common"
start:
    mov sp, 0
    mov r10, 0
    mov r11, 0
    send r10, 0x1010
    send r10, 0x200F
    mov r1, inputprompt
    call outputR1
main:
    cmp r11, 0
    je .skip
    call clearscreen
    call clearbuffer
    .skip:
    bump r10
    call getinput
    send r10, 0x1020
    send r10, 0x2007
    mov r1, inputbuffer
    call outputR1
    send r10, 0x1030
    send r10, 0x2009
    mov r1, paktcprompt
    call outputR1
    bump r10
    .waitforkey:
        wait r3
        js .waitforkey
    bump r10
    mov r11, 1
    jmp main
clearbuffer:
    mov r1, inputbuffer
    mov r2, 14
    .loop:
        mov [r1], 1
        add r1, 1
        sub r2, 1
        jz .end
        jmp .loop
    .end:
        ret
clearscreen:
    send r10, 0x1011
    send r10, 0x200F
    mov r6, 63
    cmp r11, 1
    je .skip
    mov r6, 31
    .skip:
    .loop:
        send r10, 32
        sub r6, 1
        jnz .loop
    send r10, 0x1010
    send r10, 0x200F
    ret
getinput:
    mov r13, 0x7F
    mov r1, 0
    mov r5, inputbuffer
    mov r12, 2
    jmp .loop
.toggle:
    xor r13, 0x5F
    mov r12, 2
    send r10, 0x200F
    send r10, r13
    jmp .back
.loop:
    mov r4, 0x1011
    add r4, r1
    sub r12, 1
    jz .toggle
    send r10, r4
    send r10, r4
    .back:
    wait r3
    js .loop
    mov r4, 0x1011
    add r4, r1
    send r10, r4
    send r10, 0x200F
    send r10, 32
    send r10, r4
    bump r10
    .recvloop:
        recv r2, r10
    jnc .recvloop
    cmp r2, 8
    je .backspace
    cmp r2, 13
    je .enter
    cmp r1, 14
    je .loop
    mov [r5+r1], r2
    mov r4, 0x1011
    add r4, r1
    send r10, r4
    send r10, 0x200F
    send r10, r2
    add r1, 1
    jmp .loop
    .backspace:
        cmp r1, 0
        je .loop
        sub r1, 1
        mov [r5+r1], 1
        mov r4, 0x1011
        add r4, r1
        send r10, r4
        send r10, 32
        send r10, r4
        jmp .loop
    .enter:
        mov [r5+r1], 0
        ret
inputbuffer:
    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
inputprompt:
    dw ">",0
outputR1:
.loop:
    mov r2, [r1]
    jz .end
    send r10, r2
    add r1, 1
    jmp .loop
.end:
    ret
paktcprompt:
    dw "Press any key tocontinue",0
