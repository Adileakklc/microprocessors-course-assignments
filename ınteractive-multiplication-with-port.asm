ORG 100h
; Giris ve cikis portlari icin sabitleri tanimla
INPUT_PORT   equ 0A0h  ; Sisteminize gore bu adresi ayarlayin
OUTPUT_PORT  equ 0378h  ; Sisteminize gore bu adresi ayarlayin (LPT1 portu)

start:
    MOV WORD PTR [0120h], 0FFFFH  ; carpanin 16-0 bitini bellege yerlestirildi
    MOV WORD PTR [0122h], 00001H  ; carpanin 32-16 bitini bellege yerlestirildi
    MOV WORD PTR [0124h], 0FFFFH  ; carpilanin 16-0 bitini bellege yerlestirildi
    MOV WORD PTR [0126h], 00001H  ; carpilanin 32-16 bitini bellege yerlestirildi

    MOV WORD PTR [0130h], 0000h  ; carpimin 16-0 arasinin bellek adresi
    MOV WORD PTR [0132h], 0000h  ; carpimin 32-16 arasinin bellek adresi
    MOV WORD PTR [0134h], 0000h  ; carpimin 48-32 arasinin bellek adresi
    MOV WORD PTR [0136h], 0000h  ; carpimin 64-48 arasinin bellek adresi

    SUB AX, AX
    SUB BX, BX
    SUB CX, CX
    SUB DX, DX
    SUB SI, SI
    SUB DI, DI

    MOV SI, 32  ; Dongu sayaci, 32'den baslatildi (Dec olarak)

main_loop:
    MOV BX, [0120h]  ; carpanin 16-0 biti DI'ye aktarildi
    AND BX, 01H     ; carpanin LSB'si disindaki bitleri 0'la AND'le (LSB'yi 1'le AND'le, yani LSB onceki degeri korunur)
    XOR BX, 01H     ; carpanin LSB biti 0 mi diye kontrol et, 0 ise ZERO FLAG 0'a esitlenir
    JZ topla_kaydir ; carpanin LSB biti 1 ise ZERO FLAG 1'e esitlenir ve JZ'deki fonksiyona git
    CLC            ; carpanin LSB biti 1 degildir, ZERO FLAG 0'dir, CARRY temizlendi

    ; Simple giris portundan veri okundu
    IN AL, INPUT_PORT

    ; Girisi kontrol et ve karsilik gelen 16 bitlik bolumu goruntule
    CMP AL, '1'
    JE display_lower_bits
    CMP AL, '4'
    JE display_upper_bits
    CMP AL, '2'
    JE display_middle_low_bits
    CMP AL, '3'
    JE display_middle_high_bits
    JMP main_loop  ; Hicbiri saglanmazsa ana donguye geri don

display_lower_bits:  
    ; Debug ciktisi: Cikis degerini ekrana yazdir
    MOV AH, 02h  ; Teletype servisi
    MOV DL, AL   ; Yazdirilacak karakter
    INT 21h      ; Yazdirma cagrisi

    ; Sonucun alt 16 bitini LED_Display'de goruntule
    ; (Alt 16 bitin [0130h] adresinde depolanmis oldugu varsayilmistir)
    MOV AX, [0130h]
    MOV DX, OUTPUT_PORT  ; Port adresini yuklemek icin DX register'ini kullan
    OUT DX, AL 
    ; Girisi kontrol et ve karsilik gelen 16 bitlik bolumu goruntule
    CMP AL, '1'
    JE display_lower_bits
    CMP AL, '4'
    JE display_upper_bits
    CMP AL, '2'
    JE display_middle_low_bits
    CMP AL, '3'
    JE display_middle_high_bits
    JMP main_loop

display_upper_bits:
    ; Sonucun ust 16 bitini LED_Display'de goruntule
    ; (ust 16 bitin [0136h] adresinde depolanmis oldugu varsayilmistir)
    MOV AX, [0136h]
    MOV DX, OUTPUT_PORT  ; Port adresini yuklemek icin DX register'ini kullan
    OUT DX, AL
    JMP main_loop

display_middle_low_bits:
    ; Sonucun orta 16 bitinin (dusuk kismi) LED_Display'de goruntulenmesi
    ; (Orta 16 bitin [0132h] adresinde depolanmis oldugu varsayilmistir)
    MOV AX, [0132h]
    MOV DX, OUTPUT_PORT  ; Port adresini yuklemek icin DX register'ini kullan
    OUT DX, AL
    JMP main_loop

display_middle_high_bits:
    ; Sonucun orta 16 bitinin (yuksek kismi) LED_Display'de goruntulenmesi
    ; (Orta 16 bitin [0134h] adresinde depolanmis oldugu varsayilmistir)
    MOV AX, [0134h]
    MOV DX, OUTPUT_PORT  ; Port adresini yüklemek için DX register'ını kullan
    OUT DX, AL
    JMP main_loop

devam:
    MOV AX, [0136h]
    RCR AX, 1        ; carpim sonucunun 64-48 bitini bir saga kaydir
    MOV [0136h], AL
    MOV BX, [0134h]      
    RCR BX, 1        ; carpim sonucunun 48-32 bitini bir saga kaydir
    MOV [0134h], BL
    MOV CX, [0132h]
    RCR CX, 1        ; carpim sonucunun 32-16 bitini bir saga kaydir
    MOV [0132h], CL  
    MOV DX, [0130h]
    RCR DX, 1        ; carpim sonucunun 16-0  bitini bir saga kaydir
    MOV [0130h], DL    
    MOV AX, [0122h]
    SHR AX, 1        ; carpan'i bir bit sağa kaydir
    MOV [0122h], AL 
    MOV BX, [0120h]
    RCR BX, 1        ; carpan'i bir bit saga kaydir, ancak carry ile birlikte gelirse yani carpanin 32-16 bitinden gelen eldeyi de kullanarak
    MOV [0120h], BL 
          
    DEC SI      ; Dongu degiskenini azalt
    CMP SI, 0   ; Degisken 0 mi diye bak    
    JNZ topla_kaydir ; Sifir değilse kontrolcuye git
    JMP son     ; Uygulamayi bitirmeye git 

topla_kaydir:
    ; topla_kaydir etiketinin icerigi buraya gelecek
    MOV DX, [0124h]  ; DX'e carpilanin 16-0 bitini kopyala
    ADD [0134h], DX   ; carpimin 48-32 bitine burada carry onemli degil
    MOV DX, [0126h]   ; DX'e carpilanin 32-16 bitini kopyala
    ADC [0136h], DX   ; carpimin 64-48 bitine carry'yi goz onune alarak ata
    JMP devam  

son:
    HLT             ; Uygulamayi bitir 
    ret
