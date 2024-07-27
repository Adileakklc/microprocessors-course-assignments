# Assembly Projeleri

Bu depo, çeşitli işlevleri gösteren ve assembly programlamada farklı teknikleri uygulayan bazı assembly dilinde yazılmış programları içermektedir. Aşağıda her programın açıklaması bulunmaktadır:

## 1. Selection Sort Programı
**Açıklama:**
Bu program, 10 tamsayıdan oluşan bir diziyi Selection Sort algoritması kullanarak sıralar.

**Kod Açıklaması:**
- Program, 10 tamsayı içeren bir veri segmenti tanımlar.
- Başlangıç koşullarını ayarlar, veri segmentini yükler ve diziyi sıralamak için `SelectionSort` alt programını çağırır.
- Sıralama tamamlandıktan sonra, sıralanmış diziyi ekrana yazdırır.

**Ana Talimatlar:**
- `ORG 100h`: Programın başlangıç adresini belirler.
- `MOV AX, data`, `MOV DS, AX`: Veri segmentini yükler.
- `MOV CX, n`: Dizinin boyutunu CX register'ına yükler.
- `LEA SI, arr`: Dizinin başlangıç adresini SI register'ına yükler.
- `CALL SelectionSort`: SelectionSort alt programını çağırır.

## 2. Parite Kontrolü ve LED Görüntüleme Programı
**Açıklama:**
Bu program, bellekten 10 adet 32-bit tamsayıyı okur, bunların paritesini kontrol eder ve sonucu LED çıkış portunda görüntüler.

**Kod Açıklaması:**
- Program, 10 adet 32-bit tamsayı içeren bir veri segmenti başlatır.
- Kullanıcının bir giriş değeri okumasını sağlar, ilgili sayının paritesini kontrol eder ve sonucu LED göstergesine yansıtır.
- Geçersiz girişler işlenir ve kullanıcıdan tekrar giriş yapması istenir.

**Ana Talimatlar:**
- `ORG 100h`: Programın başlangıç adresini belirler.
- `MOV SI, 0700h`: DWORDS dizisinin ofset değeri.
- `MOV DI, 0300h`: Bellek bölgesinin ofset adresi.
- `IN AL, INPUT_PORT`: Porttan veri okur.
- `OUT DX, AL`: Port'a veri yazar.

## 3. Çarpma ve Depolama Programı
**Açıklama:**
Bu program, bir dizi sayının çarpmasını yapar ve sonuçları belirli bir bellek konumunda saklar.

**Kod Açıklaması:**
- Program, ES segmentini başlatır, SI ve BX register'larını ayarlar ve çarpma işlemlerini gerçekleştirir.
- Sonuçlar belleğe kaydedilir ve belirtilen koşul sağlanana kadar işlem devam eder.

**Ana Talimatlar:**
- `ORG 100h`: Programın başlangıç adresini belirler.
- `MOV AX, 0900h`: ES segmentini başlatır.
- `MOV ES:[200h+SI],DL`: Sonucu belleğe kaydeder.

## 4. Port ile Etkileşimli Çarpma Programı
**Açıklama:**
Bu program, bellekte saklanan iki sayıyı çarpar ve sonuçları bir çıkış portunda gösterir, kullanıcı giriş portu aracılığıyla etkileşime izin verir.

**Kod Açıklaması:**
- Program, çarpan ve çarpılanın bellek konumlarını ayarlar, register'ları başlatır ve çarpma işlemini gerçekleştirir.
- Kullanıcı, bir giriş portu aracılığıyla sonucu görüntüleyebilir, farklı bölümleri gösterir (alt, üst ve orta bitler).

**Ana Talimatlar:**
- `ORG 100h`: Programın başlangıç adresini belirler.
- `IN AL, INPUT_PORT`: Porttan veri okur.
- `OUT DX, AL`: Port'a veri yazar.
- `MOV AX, [memory_address]`: Bellekten değerleri alır.
- `RCR AX, 1`: Bitleri sağa kaydırır.

## Genel Talimatlar
**Assembly Dilinde Temel Talimatlar:**
- `MOV`: Register'lar veya bellek arasında veri transferi yapar.
- `ADD`, `SUB`: Toplama ve çıkarma işlemleri yapar.
- `CALL`, `RET`: Alt programları çağırır ve döner.
- `JMP`, `JE`, `JNZ`, `JZ`: Dallanma talimatları.
- `INT 21h`: Çeşitli sistem servisleri için DOS kesmesi.
- `ORG`: Programın başlangıç adresini ayarlar.
- `DB`, `DW`, `DD`: Bayt, kelime ve çift kelime verilerini tanımlar.

**Segmentler:**
- `data segment`: Veri segmentini tanımlar.
- `code segment`: Kod segmentini tanımlar.
- `assume`: Segment register'larını ayarlar.

## Programları Çalıştırma
Bu programları çalıştırmak için Emu8086 gibi bir emulator gereklidir. 

## İletişim
Herhangi bir soru veya daha fazla bilgi için Adile Akkılıç ile iletişime geçebilirsiniz.
