ORG 100h ; baslangic adresini belirle

data segment
    arr db 10, 5, 8, 3, 1, 7, 2, 9, 4, 6 ; 10 elemanli dizi
    n equ 10 ; Dizi boyutu
    newline db 0Ah, 0Dh, '$' ; Yeni satir karakterleri
data ends

code segment
assume cs:code, ds:data
start:

    mov cx, n         ; CX register'ina dizi boyutunu yukle
    lea si, arr       ; SI register'ina dizi baslangic adresini yukle
    call SelectionSort ; SelectionSort fonksiyonunu cagir

    ; Ekrana yazdirma islemi
    mov cx, n
    lea si, arr        ; bir degiskenin offset (bagil konum) adresini elde etmek icin
    call PrintArray

    ; Programi sonlandir
    mov ah, 4Ch
    int 21h

SelectionSort:
    mov di, si     ; DI register'ini SI ile esitle; Dizi baslangicini gosteren adres
    mov cx, n      ; CX register'ina dongu sayacini yukle

OuterLoop:
    mov si, di     ; SI register'ini DI ile esitle; ic ice dongu icin SI'i DI'ya esitle

InnerLoop:
    inc si         ; SI register'ini bir sonraki elemana gecir

    mov al, [di]   ; AL register'ina su anki elemani yukle
    mov bl, [si]   ; BL register'ina bir sonraki elemani yukle

    cmp al, bl     ; Elemanlari karsilastir
    jbe NoSwap     ; Eger kucukse NoSwap etiketine git

    ; Swap islemi
    mov dl, [di]   ; DL register'ina su anki elemani yukle
    mov dh, [si]   ; DH register'ina bir sonraki elemani yukle
    mov [di], dh   ; su anki elemani bir sonraki elemanla degistir
    mov [si], dl   ; Bir sonraki elemani su anki elemanla degistir

NoSwap:
    loop InnerLoop ; ic ice dongu devam eder

    inc di         ; DI register'ini bir sonraki elemana gecir
    loop OuterLoop ; Dis dongu devam eder

    ret

PrintArray:
    mov ah, 2 ; DOS print karakter servisi
PrintLoop:
    mov dl, [si] ; [si] adresindeki karakteri dl'ye yukle
    int 21h ; karakteri yazdýir
    inc si ; bir sonraki karaktere gec
    loop PrintLoop ; cx register'indaki degeri azalt ve donguyu tekrarla

    ; Yeni satir karakterlerini ekle
    lea dx, newline
    mov ah, 9 ; DOS print string servisi
    int 21h

    ret

code ends
end start
