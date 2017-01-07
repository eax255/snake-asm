jmp begin
nop
db "MSDOS5.0"
dw 512
db 1
dw 1
db 2
dw 224
dw 2880
db 240
dw 9
dw 18
dw 2
dd 0
dd 0
db 0
db 0
db 41
dd 1
;db "BOOT FLOPPY"
;db "FAT12   "
begin:
mov ax,0x000D
int 0x10
mov ax,0xa000
mov fs,ax
;mov ax,0x7000
;mov ss,ax
mov ah,0x50
mov gs,ax
mov ah,0x60
mov ds,ax
mov es,ax

mov bx,4000
mov ax,-32000
upv:
  bts [fs:bx],ax
  not ax
  bts [fs:bx],ax
  neg ax
  cmp ax,-30720
jl upv
mov bp,-30720+3
leftv:
  call sbp
  add bp,316
  call sbp
  add bp,4+320*3
  cmp bp,30720
jl leftv

mov bp,143
mov cx,147
mov ax,4

xor si,si
xor di,di
initl:
  add bp,ax
  stosb
  call sbp
  cmp bp,159
jl initl
dec di
push ax
mov dx, bp
add dx, ax
xchg dx,bp
call sbp
xchg dx,bp
mov [gs:0],dx
mov dx,[cs:0x046C]
mov [gs:2],dx
lp:
  add bp,ax
  mov dx,[gs:0]
  cmp bp,dx
  jne .vv
  push ax
.nlp:
  mov ax,[gs:2]
  mov bx,ax
  shr ax,2
  xor bx,ax
  shr ax,1
  xor bx,ax
  shr ax,2
  xor bx,ax
  shl bx,15
  mov ax,[gs:2]
  shr ax,1
  or ax,bx
  mov [gs:2],ax
  mov bx,4000
  xor dx,dx
  div bx
  mov ax,dx
  xor dx,dx
  mov bx,80
  div bx
  imul ax,320
  add dx,ax
  shl dx,2
  sub dx,32001
  mov bx,4000
  xor dx,0x7
  bt [fs:bx],dx
  jc .nlp
  xor dx,0x7
  call sbp
  xchg dx,bp
  call sbp
  xchg dx,bp
  mov [gs:0],dx
  mov al,3
  stosb
  pop ax
  ;jmp .kk
.vv:
  call sbp
  jc end
.kk:

  cmp ax,0
  jg .v0
  add ax,1280
.v0:
  cmp ax,4
  jle .v1
  sub ax,1268
.v1:
  stosb
  lodsb
  xor ah,ah
  cmp ax,3
  je .skip
  cmp ax,4
  jle .v2
  add ax,1268
.v2:
  test ax,ax
  jz .v3
  cmp ax,1276
  jne .v4
.v3:
  sub ax,1280
.v4:

  xchg cx,bp
  call sbp
  xchg cx,bp
  add cx,ax
.skip:


  mov ax,[cs:0x046C]
  inc ax
  inc ax
.slp:
  mov dx,[cs:0x046C]
  cmp dx,ax
  jl .slp

  pop dx
  in al,0x60
  and al,0x7f
  mov bx,-1280
  cmp al,0x11
  je .v
  neg bx
  cmp al,0x1f
  je .v
  mov bx,-4
  cmp al,0x1e
  je .v
  neg bx
  cmp al,0x20
  je .v
  mov bx,dx
.v:neg dx
  cmp dx,bx
  jne .llll
  neg bx
.llll:
  push bx
  mov ax,bx
  mov bx,4000

jmp lp
sbps:
  push bp
  inc bp
  btc [fs:bx],bp
  add bp,320
  btc [fs:bx],bp
  dec bp
  btc [fs:bx],bp
  pop bp
  btc [fs:bx],bp
ret
sbp:
  push bp
  xor bp,0x7
  push bp
  inc bp
  inc bp
  call sbps
  add bp,640
  call sbps
  dec bp
  dec bp
  call sbps
  pop bp
  call sbps
  pop bp
ret
end:
sub di,si
xor ax,ax
int 0x10
mov ax,0xb800
mov es,ax
xchg ax,di
mov di,10
std
mov bx,di
.plp:
xor dx,dx
div bx
xchg ax,dx
add al,'0'
stosb
dec di
xchg ax,dx
test ax,ax
jnz .plp
cld
.vlv:
in al,0x60
cmp al,0x81
jne .vlv
jmp begin

times 510-($-$$) db 0
dw 0xaa55
