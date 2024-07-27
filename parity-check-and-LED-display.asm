ORG 100h          ; Program baslangic adresi

DWORDS DD 0x12345678, 0x9ABCDEF0, 0x11223344, 0x55667788, 0x9900AACC, 0x13579BDF, 0xABCDEF00, 0x98765432, 0x11223311, 0x33445566 ; 10 adet 32-bit sayi

MOV SI, 0700h    ; DWORDS dizisinin ofset degeri
MOV DI, 0300h    ; Bellek bolgesinin ofset adresi
MOV CX, 10        ; Islenecek 10 sayi

; Cikis portlari
PORT_SIMPLE EQU 0300h  ; Sanal giris portu
PORT_LED EQU 0301h     ; LED cikis portu

READ_INPUT:
    ; Kullanicidan giris almak icin sanal port kullaniliyor (Simple port)
    MOV AH, 1
    INT 21h
    SUB AL, '0' ; ASCII'den tamsayiya cevirme

    ; Giris degeri kontrolu
    CMP AL, 1
    JB INVALID_INPUT  ;carry flag 1 ise komut calisir
    CMP AL, 10
    JA INVALID_INPUT  ;eðer carry ve zeroflag 0 ise komut calisir

    ; Giris degerine gore ilgili sayinin parite durumunu kontrol et
    MOV BX, WORD PTR [DWORDS + SI + 2 * AL - 2]
    CALL PARITY_CHECK

    ; Parite durumuna gore LED cikis portuna yaz
    TEST AL, 1
    JZ EVEN_PARITY  ;zero flag degeri 1 ise gosterilen yere atla
    MOV DL, 0x01 ; Tek parite durumu
    JMP UPDATE_LED

EVEN_PARITY:
    MOV DL, 0x00 ; Cift parite durumu

UPDATE_LED:
    ; LED cikis portuna yaz
    MOV AH, 0x09 ; Yazdirma fonksiyonu
    MOV DX, PORT_LED
    INT 21h
    JMP END_PROGRAM

INVALID_INPUT:
    ; Gecersiz giris durumunda kullaniciyi uyar
    MOV AH, 9 ; Yazdirma fonksiyonu
    MOV DX, OFFSET ERROR_MESSAGE
    INT 21h
    JMP READ_INPUT ; Tekrar giris iste

END_PROGRAM:
    ;cikis syscall (Emu8086 bunu direkt olarak desteklemeyebilir)
    MOV AH, 4Ch
    INT 21h

PARITY_CHECK:
    ; Parite kontrolu alt programi
    MOV AX, BX
    XOR AL, AL
    MOV CX, 32 ; DWORD'un tamami icin 32 bit duzeltildi

    PARITY_LOOP:
        SHR AX, 1
        JC PARITY_ODD
        LOOP PARITY_LOOP
        JMP PARITY_DONE

PARITY_ODD:
    MOV AL, 1 ; AL'yi 1 yap (tek sayi durumu)
    JMP PARITY_DONE

PARITY_DONE:
    RET ; Parite kontrolu tamamlandi

ERROR_MESSAGE DB "Gecersiz giris. Lutfen 1-10 arasinda bir sayi girin.", 0
