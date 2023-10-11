BITS 64
section .text
global strlen

strlen:
    mov rax, 0
strlen_loop:
    cmp byte [rdi + rax], 0
    je strlen_end
    inc rax
    jmp strlen_loop
strlen_end:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global strchr

strchr:
    mov rax, 0
    cmp byte [rdi + rax], 0
    je fals_end
loop_strchr:
    cmp byte [rdi + rax], sil
    je end_strchr
    cmp byte [rdi + rax], 0
    je fals_end
    inc rax
    jmp loop_strchr

fals_end:
    xor eax, eax
    mov rax, 0
    ret

end_strchr:
    add rax, rdi
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global strrchr

strrchr:
    mov rax, 0
    call strlen
    mov r11, rax
    dec rax
    cmp byte [rdi + rax], 0
    je fals_end_chr

loop_strrchr:
    cmp byte [rdi + rax], sil
    je end_strrchr
    cmp byte [rdi + rax], 0
    je fals_end_chr
    dec rax
    jmp loop_strrchr

fals_end_chr:
    xor eax, eax
    mov rax, 0
    ret

end_strrchr:
    add rax, rdi
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global memset

memset:
    mov rax, 0
    cmp rax, rdx
    je my_end_memset

loop_memset:
    cmp RAX, RDX
    je my_end_memset
    mov BYTE [rax + rdi], SIL
    inc RAX
    jmp loop_memset

my_end_memset:
    mov rax, rdi
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global memcpy

memcpy:
	xor r10, r10		; set an index to 0

loop_memcpy:
	cmp r10, rdx		; is index equal to third arg ?
	je end_memcpy			; if yes, goto '.END'
	mov al, byte [rsi+r10]	; set al char to src[rcx]
	mov byte [rdi+r10], al	; set dest[rcx] to al char
    inc r10
    jmp loop_memcpy		; goto '.LOOP' label

end_memcpy:
	mov rax, rdi		; set return value to dest
	ret			; end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global strcmp

strcmp:
    mov rax, 0
    xor cl, cl

my_loop_strcmp:
    cmp byte [rdi + rax], 0
    je if_same

    mov cl, byte [rsi + rax]
    cmp byte [rdi + rax], cl
    jne bad_strcmp

    inc rax
    jmp my_loop_strcmp

if_same:
    cmp byte [rsi + rax], 0
    je if_equal
    jmp bad_strcmp

if_equal:
    mov rax, 0
    ret

if_bigger:
    mov rax, 1
    ret

bad_strcmp:
    cmp byte [rsi + rax], 0
    je if_bigger

    mov rax, -1
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global strncmp

strncmp:
    mov rax, 0
    xor cl, cl

my_loop_strncmp:
    cmp byte [rdi + rax], 0
    je if_equal_ncmp

    mov cl, byte [rsi + rax]
    mov r8b, byte [rdi + rax]
    cmp r8b, cl
    jne bad_strncmp

    inc rax
    jmp my_loop_strncmp

if_equal_ncmp:
    mov rax, 0
    ret

bad_strncmp:
	movsx ebx, cl
	movsx eax, r8b
	sub eax, ebx
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECTION .text
GLOBAL memmove

memmove:
    cmp rdx, 0
    je memmove_equal
    cmp rsi, rdi
    je memmove_equal
    push rbp
    mov rbp, rsp
    xor rcx, rcx
    jmp memmove_loop

increment_loop:
    inc rcx
    inc rsi

memmove_loop:
    cmp rcx, rdx
    je memmove_second_loop
    cmp byte [rsi], 0
    je memmove_second_loop
    mov r8b, [rsi]
    push r8
    jmp increment_loop

decrement_loop:
    dec rcx

memmove_second_loop:
    cmp rcx, 0
    je memmove_end
    pop r8
    mov byte [rdi+rcx-1], r8b
    jmp decrement_loop

memmove_end:
    mov rax, rdi
    pop rbp
    ret

memmove_equal:
    mov rax, rdi
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
    global strcasecmp

strcasecmp:
    mov eax, 0
    xor cl, cl

strcasecmp_loop:
    mov cl, byte [rdi + rax]
    mov r8b, byte [rsi + rax]
    cmp cl, 'A'
    jl strcasecmp_lowercase_str1
    cmp cl, 'Z'
    jg strcasecmp_lowercase_str1
    add cl, 32

strcasecmp_lowercase_str1:
    cmp r8b, 'A'
    jl strcasecmp_lowercase_str2
    cmp r8b, 'Z'
    jg strcasecmp_lowercase_str2
    add r8b, 32

strcasecmp_lowercase_str2:
    cmp cl, r8b
    jne strcasecmp_end
    cmp cl, 0
    je return
    inc rax
    jmp strcasecmp_loop

strcasecmp_end:
    movsx eax, cl
    movsx ebx, r8b
    sub eax, ebx

return:
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data
    text db "here", 10

section .text
    global strstr

strstr:
	xor rbx, rbx

my_strstr_loop:
	mov r9, rbx
	xor rcx, rcx
	jmp my_strstr_second_loop

increment:
	inc r9
	inc rcx

my_strstr_second_loop:
	mov dl, BYTE [rsi+rcx]
	cmp dl, 0
	je ret_non_null
	mov al, BYTE [rdi+r9]
	cmp al, 0
	je ret_null
	cmp al, dl
	je  increment
	inc rbx
    jmp my_strstr_loop

ret_null:
	xor rax, rax
	ret

ret_non_null:
	mov rax, rdi
	add rax, rbx
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global strpbrk

strpbrk:
	xor rbx, rbx
	jmp my_strpbrk_loop

increment_strpbrk:
    inc rbx

my_strpbrk_loop:
	mov al, BYTE [rdi+rbx]
	cmp al, 0
	je my_strpbrk_null
	xor r10, r10

my_strpbrk_sub_loop:
	mov r8b, BYTE [rsi+r10]
   	cmp r8b, 0
   	je increment_strpbrk

my_strpbrk_sub_loop2:
	cmp al, r8b
	je my_strpbrk_return
	inc r10
	jmp my_strpbrk_sub_loop

my_strpbrk_null:
	xor rax, rax
	ret

my_strpbrk_return:
	mov rax, rdi
	add rax, rbx
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global strcspn

strcspn:
	xor rbx, rbx
	jmp strcspn_loop

increment_strcspn:
    inc rbx

strcspn_loop:
	mov al, BYTE [rdi+rbx]
	cmp al, 0
	je end_strcspn
	xor r10, r10
	jmp strcspn_sub_loop

strcspn_sub_loop:
	mov r8b, BYTE [rsi+r10]
	cmp r8b, 0
	je increment_strcspn

strcspn_sub_loop_2:
	cmp al, r8b
	je end_strcspn
	inc r10
	jmp strcspn_sub_loop

end_strcspn:
	mov rax, rbx
	ret