(define gen12 (_) (append 2 (append 1 null)))

fold_left fun accu ls =
match ls with
    | [] -> accu
    | hd :: tl -> fold_left fun (fun accu hd) tl
    
(* END is a taging to specify the end of the list 0x0000000 *)
end_of_list: // cc in ebp - 4
    push END
    jmp [ebp - 4]

range: // cc in ebp - 8, n in ebp - 4
    mov eax, [ebp - 4]
    cmp eax, 0
    jeq end_range
    
  end_range:
    
    
    
==========================================

(define main (input) (
    let ((h (f input))) (h input)
))

(define f (x) (
    define g (y) (
        x + y
    )
))

func_main:
    sub esp, 8
    push ebp
    push after_call_1
    mov eax, [ebp - 4]
    push eax
    mov ebp, esp
    add ebp, 4
    jmp func_f
  after_call_1:
    pop ebp
    mov [ebp - 8], eax
    mov [ebp - 12], ebx
func_f:
    mov ebx, ebp
    mov eax, func_g
    ret
func_g:
    
