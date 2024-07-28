ORG 100h

MOV AX, 0900H               ;Segment register ES'i 0x0900 olarak ayarla
MOV es, ax
mov si,00h                  ;SI register'ini 0 olarak baslat
mov bx, 0ffffh              ;BX register'ini 0xFFFF olarak baslat

next:
    inc bx
    cmp bx, 65h             ;BX'i 0x65 ile karþýlaþtýr
    jz finish               ;BX 0x65'e esitse finish etiketine atla
    
    mov dl, 0h              ;DL register'ini 0 olarak baslat
    
again:
    inc dl
    mov al, dl

    call calculate

calculate:
    mul dl                  ;AL'i DL ile carp (sonuc AX'te)
    cmp ax,bx               ;AX'i BX ile karsilastir
    jbe again               ;AX <= BX ise again etiketine atla
    ja print                ;AX > BX ise print etiketine atla
    
    ret
    
print:
    dec dl                  ;DL'i bir azalt
    mov es:[200h+si],dl     ;DL degerini [ES:200h + SI] adresine yaz
    inc si                  ; SI'ý bir artýr
    jmp next

finish:
    hlt                     ;CPU'yu durdur 