begin:
mov ax,0x000D
int 0x10
mov ax,0xa000
mov fs,ax
mov ax,0x7000
mov ss,ax
mov ax,0x5000
mov gs,ax
mov ax,-1
mov [gs:0x3C],ax
mov [gs:0x13C],ax
mov ax,1
mov [gs:0x40],ax
mov [gs:0x140],ax
mov ax,320
mov [gs:0x3E],ax
mov [gs:0x13E],ax
mov ax,-320
mov [gs:0x22],ax
mov [gs:0x122],ax

cli
 mov al,00110100b
 out 0x43, al
 xor al,al
 out 0x40, al
 out 0x40, al
sti

mov ax,0x6000
mov ds,ax
mov es,ax
mov bx,4000
mov ax,-32000
upv:
  bts [fs:bx],ax
  inc ax
  cmp ax,-31680
jl upv
mov ax,31360
downv:
  bts [fs:bx],ax
  inc ax
  cmp ax,32000
jl downv
mov ax,-31673
leftv:
  bts [fs:bx],ax
  add ax,305
  bts [fs:bx],ax
  add ax,15
  cmp ax,31680
jl leftv

mov bp,145
mov cx,147
mov ax,1

xor si,si
xor di,di
initl:
  add bp,ax
  add bp,ax
  stosb
  xor bp,0x07
  call sbp
  xor bp,0x07
  cmp bp,159
jl initl
dec di
mov dl,0x40
push dx
mov dx, bp
add dx, ax
add dx, ax
xor dx, 0x07
xchg dx,bp
call sbp
xchg dx,bp
mov [gs:0],dx
lp:
  add bp,ax
  add bp,ax
  xor bp,0x07
  mov dx,[gs:0]
  cmp bp,dx
  jne .vv
  call sbp
  push ax
  mov ax,dx
.nlp:
  mov bx,137
  mul bx
  mov bx,16000
  div bx
  mov ax,dx
  xor dx,dx
  mov bx,160
  div bx
  imul ax,320
  add dx,ax
  shl dx,1
  sub dx,32001
  xor dx,7
  mov bx,4000
  bt [fs:bx],dx
  jc .nlp
  xchg dx,bp
  call sbp
  xchg dx,bp
  mov [gs:0],dx
  mov al,4
  stosb
  pop ax
.vv:
  call sbp
  jc end
  xor bp,0x07

  cmp ax,0
  jg .v0
  add ax,320
.v0:
  cmp ax,2
  jl .v1
  sub ax,317
.v1:
  stosb
  lodsb
  cmp ax,4
  je .skip
  cmp ax,2
  jl .v2
  add ax,317
.v2:
  test ax,ax
  jz .v3
  cmp ax,319
  jne .v4
.v3:
  sub ax,320
.v4:

  xor cx,0x07
  xchg cx,bp
  call sbp
  xchg cx,bp
  xor cx,0x07
  add cx,ax
  add cx,ax
.skip:


  mov ax,[cs:0x046C]
  add ax,2
.slp:
  mov dx,[cs:0x046C]
  cmp dx,ax
  jl .slp

  pop dx
  in al,0x60
  test al,al
  jz .il
  mov dl,al
.il:
  mov bx,dx
  push dx
  xor bh,bh
  shl bx,1
  mov ax,[gs:bx]
  test ax,ax
  jnz .cccc
  mov ax,1
.cccc:
  mov bx,4000

jmp lp
sbp:
  inc bp
  btc [fs:bx],bp
  add bp,320
  btc [fs:bx],bp
  dec bp
  btc [fs:bx],bp
  sub bp,320
  btc [fs:bx],bp
ret
end:
sub di,si
push di
xor ax,ax
int 0x10
mov ax,0xb800
mov es,ax
pop ax
mov di,38
std
mov bx,10
.plp:
xor dx,dx
div bx
xchg ax,dx
add al,'0'
stosb
dec di
mov ax,dx
test ax,ax
jnz .plp
cld
.vlv:
in al,0x60
mov bl,al
xor bh,bh
shl bx,1
mov ax,[gs:bx]
test ax,ax
jnz .vlv
jmp begin

times 510-($-$$) db 0
dw 0xaa55
