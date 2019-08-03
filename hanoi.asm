;x86:
; $ nasm -f elf hanoi.asm
; $ ld hanoi.o -o hanoi
; $ ./hanoi

;x64:
; $ nasm -f elf64 hanoi.asm
; $ ld -m elf_i386 hanoi.o -o hanoi
; $ ./hanoi

;x64 para x86:
; $ nasm -f elf hanoi.asm
; $ ld -m elf_i386 hanoi.o -o hanoi
; $ ./hanoi

section .data

             msg:      db     0xa, 'move disk '
             de:       db     ' '
                       db     ' for tower '
             para:     db     ' '
             msg_l:    equ    $-msg
             msg2:     db     0xa, 'Enter number of disks or 0 to exit: '
             msg2_l:   equ    $-msg2
             msg3:     db     0xa, 'Closed...', 0xa, 0xa
             msg3_l:   equ    $-msg3
             msg4:     db     0xa
             msg4_l:   equ    $-msg4

section .bss

response:    resb      4

section .text

global  _start

_start:

             mov       eax, 4
             mov       ebx, 1
             mov       ecx, msg2
             mov       edx, msg2_l
             int       80h
             mov       eax, 3
             mov       ebx, 0
             mov       ecx, response
             int       80h
             mov       edi, eax
             dec       edi
             mov       esi, 0
             mov       ax, 0

convert:
             mov       cx, 0
             mov       cl, [response + esi]
             sub       cl, 48
             mov       bx, 10
             mul       bx
             add       ax, cx
             inc       esi
             cmp       esi, edi
             jl        convert
             cmp       eax, 0
             jle       notice
             push      dword 3
             push      dword 1
             push      eax
             call      fhanoi
             add       esp, 12

space:
             mov       eax, 4
             mov       ebx, 1
             mov       ecx, msg4
             mov       edx, msg4_l
             int       80h
             call      _start

exit:
             mov      ebx, 0
             mov      eax, 1
             int      80h

notice:
             mov      eax, 4
             mov      ebx, 1
             mov      ecx, msg3
             mov      edx, msg3_l
             int      80h
             call     exit

stack:
.source      equ      8
.destiny     equ      12

             push     ebp
             mov      ebp, esp
             mov      eax, [ebp + .source]
             add      al, '0'
             mov      [de], al
             mov      eax, [ebp + .destiny]
             add      al, '0'
             mov      [para], al
             mov      edx, msg_l
             mov      ecx, msg
             mov      ebx, 1
             mov      eax, 4
             int      0x80
             call     right

fhanoi:
.n           equ     8
.source      equ     12
.destiny     equ     16
.aux         equ     -4

             push    ebp
             mov     ebp, esp
             sub     esp, 4
             mov     eax, [ebp + .n]
             cmp     eax, 1
             jle     left
             mov     eax, 6
             sub     eax, [ebp + .source]
             sub     eax, [ebp + .destiny]
             mov     [ebp + .aux], eax
             push    dword [ebp + .aux]
             push    dword [ebp + .source]
             mov     eax, [ebp + .n]
             dec     eax
             push    eax
             call    fhanoi
             add     esp, 12
             push    dword [ebp + .destiny]
             push    dword [ebp + .source]
             push    dword 1
             call    fhanoi
             add     esp, 12
             push    dword [ebp + .destiny]
             push    dword [ebp + .aux]
             mov     eax, [ebp + .n]
             dec     eax
             push    eax
             call    fhanoi
             jmp     right

left:
             push    dword [ebp + fhanoi.destiny]
             push    dword [ebp + fhanoi.source]
             call    stack

right:
             mov     esp, ebp
             pop     ebp
             ret
