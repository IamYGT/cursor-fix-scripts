# 🚀 Cursor IDE Fix Scripts

[![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> **Cursor IDE'deki sinir bozucu sorunları çözen PowerShell scriptleri koleksiyonu**

Bu repo, Cursor IDE kullanırken karşılaşılan yaygın sorunları otomatik olarak çözen, test edilmiş ve güvenli PowerShell scriptleri içerir.

---

## 📑 İçindekiler

- [Özellikler](#-özellikler)
- [Sorunlar ve Çözümler](#-sorunlar-ve-çözümler)
- [Kurulum](#-kurulum)
- [Kullanım](#-kullanım)
- [Script Detayları](#-script-detayları)
- [Güvenlik](#-güvenlik)
- [Sorun Giderme](#-sorun-giderme)
- [Katkıda Bulunma](#-katkıda-bulunma)
- [Lisans](#-lisans)

---

## ✨ Özellikler

- ✅ **Otomatik Yedekleme**: Her script çalıştırılmadan önce otomatik yedek oluşturur
- ✅ **Güvenli İşlem**: Cursor'un kapalı olduğunu kontrol eder
- ✅ **Detaylı Loglama**: Her adımda renkli ve açıklayıcı çıktı
- ✅ **Kolay Kullanım**: Tek satır komutla çalıştırma
- ✅ **Geri Alınabilir**: Yedek dosyalarla kolayca eski haline döndürme

---

## 🐛 Sorunlar ve Çözümler

### 1️⃣ Google Gemini API `top_k` Hatası

**Sorun:**
```
Error: top_k (-1) must not be set or must be a positive integer
```

**Sebep:** Cursor, Google Gemini API'ye geçersiz `top_k` parametresi gönderiyor.

**Çözüm:** [`fix_cursor_top_k.ps1`](#1-fix_cursor_top_kps1)

---

### 2️⃣ User API Key Rate Limit Hatası

**Sorun:**
```
User API Key Rate limit exceeded
```

**Sebep:** Cursor'un state database'inde biriken rate limit bilgileri.

**Çözüm:** [`fix_cursor_rate_limit.ps1`](#2-fix_cursor_rate_limitps1)

---

### 3️⃣ Gemini API Yapay Rate Limiti

**Sorun:** Cursor, Gemini API için kasıtlı olarak rate limit koyuyor, bu da kullanımı kısıtlıyor.

**Sebep:** Cursor'un workbench dosyasındaki rate limit kontrolleri.

**Çözüm:** [`remove_gemini_rate_limit.ps1`](#3-remove_gemini_rate_limitps1)

---

### 4️⃣ Gemini HTTP 429 Rate Limit Hatası

**Sorun:** Gemini API kullanırken sürekli "429 Too Many Requests" hatası alınıyor.

**Sebep:** Cursor, HTTP 429 status kodunu yakalayıp rate limit hatası fırlatıyor.

**Çözüm:** [`bypass_gemini_safe.ps1`](#4-bypass_gemini_safeps1)

---

## 📥 Kurulum

### Yöntem 1: Git ile Clone

```powershell
git clone https://github.com/yourusername/cursor-fix-scripts.git
cd cursor-fix-scripts
```

### Yöntem 2: Manuel İndirme

1. Bu repo'dan scriptleri indirin
2. İstediğiniz bir klasöre kaydedin
3. PowerShell'i **Yönetici olarak** açın
4. Script klasörüne gidin:

```powershell
cd C:\path\to\scripts
```

---

## 🎯 Kullanım

### ⚡ Hızlı Kurulum (ÖNERİLEN)

**Tek komutla tüm sorunları çöz:**

```powershell
# PowerShell'i Yönetici olarak aç
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Tek satırda tüm düzeltmeleri uygula
.\install.ps1
```

Bu script:
- ✅ top_k hatasını düzeltir
- ✅ HTTP 429 bypass eder
- ✅ Cache'i temizler
- ✅ Cursor'u otomatik kapatır
- ✅ Her adımı gösterir

### 📋 Manuel Kurulum

1. **Cursor IDE'yi kapatın** (önemli!)
2. PowerShell'i **Yönetici olarak** açın
3. Script klasörüne gidin
4. İlgili scripti çalıştırın

```powershell
# Execution policy'yi ayarla (güvenlik)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# İstediğiniz scripti çalıştırın
.\fix_cursor_top_k.ps1              # top_k hatası
.\bypass_gemini_safe.ps1            # Rate limit bypass (ÖNERİLEN)
.\fix_cursor_rate_limit.ps1         # Cache temizle
```

5. Cursor'u yeniden başlatın

---

## 📜 Script Detayları

### 1. `fix_cursor_top_k.ps1`

**Ne Yapar:**
- Cursor'un `workbench.desktop.main.js` dosyasını düzenler
- Google Gemini API çağrılarından geçersiz `top_k` parametresini kaldırır
- Otomatik yedek oluşturur

**Düzenlediği Dosya:**
```
%LOCALAPPDATA%\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js
```

**Çalıştırma:**
```powershell
.\fix_cursor_top_k.ps1
```

**Çıktı Örneği:**
```
Creating backup...
Reading file...
Original file size: 27716300 bytes
Modified file size: 27716300 bytes
Writing modified file...
Done! Restart Cursor to apply changes.
Backup saved at: workbench.desktop.main.js.backup
```

**Pattern'ler:**
- `{temperature:x,top_k:y,top_p:z}` → `{temperature:x,top_p:z}`
- `{top_k:x,temperature:y}` → `{temperature:y}`
- `{top_k:x}` → `{}`

---

### 2. `fix_cursor_rate_limit.ps1`

**Ne Yapar:**
- Cursor'un state database'ini temizler
- Cache dosyalarını siler
- Rate limit bilgilerini sıfırlar

**Temizlediği Dosyalar:**
```
%APPDATA%\Cursor\User\globalStorage\state.vscdb
%APPDATA%\Cursor\Cache\
%APPDATA%\Cursor\Code Cache\
```

**Çalıştırma:**
```powershell
.\fix_cursor_rate_limit.ps1
```

**Çıktı Örneği:**
```
Cursor Rate Limit Temizleyici
================================

[1/3] State database yedekleniyor...
State database temizlendi!

[2/3] Cache dosyaları temizleniyor...
Cache temizlendi!

[3/3] Code Cache temizleniyor...
Code Cache temizlendi!

================================
Tamamlandı!

Yedek dosyalar: C:\Users\YourName\cursor_rate_limit_backup_20251121_231325

Cursor'u yeniden başlatabilirsiniz.
Rate limit hatası düzelmiş olmalı.
```

**Özellikler:**
- ✅ Cursor'un çalışıp çalışmadığını kontrol eder
- ✅ Otomatik kapatma önerisi yapar
- ✅ Timestamp'li yedek klasörü oluşturur

---

### 3. `remove_gemini_rate_limit.ps1`

**Ne Yapar:**
- Cursor'un workbench dosyasındaki rate limit kontrollerini devre dışı bırakır
- API throttling mekanizmalarını kaldırır
- Request delay'lerini iptal eder

**Düzenlediği Dosya:**
```
%LOCALAPPDATA%\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js
```

**Çalıştırma:**
```powershell
.\remove_gemini_rate_limit.ps1
```

**Çıktı Örneği:**
```
Cursor Gemini Rate Limit Kaldırıcı
=====================================

[1/3] Yedek oluşturuluyor...
Yedek oluşturuldu: workbench.desktop.main.js.backup_20251121_231510

[2/3] Dosya okunuyor...
Orijinal dosya boyutu: 27716300 bytes

[3/3] Rate limit kontrolleri kaldırılıyor...
Değiştirilmiş dosya boyutu: 27716408 bytes

Dosya yazılıyor...

=====================================
Tamamlandı!

Yapılan değişiklikler:
  • Rate limit kontrolleri devre dışı bırakıldı
  • Rate limit error mesajları engellendi
  • Rate limit değerleri maksimuma çıkarıldı
  • Gemini API throttling kaldırıldı
  • Request delay mekanizmaları kaldırıldı

Cursor'u yeniden başlatın!
Rate limit artık uygulanmayacak.
```

**Pattern'ler:**
```powershell
# Rate limit kontrollerini bypass et
if(rateLimit) { throw error } → if(false) { throw error }

# Error mesajlarını yorum satırına çevir
throw new Error('rate limit') → // throw new Error('rate limit')

# Rate limit değerlerini maksimize et
const rateLimit = 60 → const rateLimit = 999999

# Delay mekanizmalarını kaldır
await delay(1000) → // await delay(1000)

# Request counter'ları devre dışı bırak
requestCount++ → // requestCount++
```

---

### 4. `bypass_gemini_safe.ps1`

**Ne Yapar:**
- Cursor'un workbench dosyasında HTTP 429 kontrollerini bypass eder
- Rate limit status kodunu hiçbir zaman tetiklenmeyecek koda çevirir
- Binary-safe encoding kullanır (dosya bozulmaz)

**Düzenlediği Dosya:**
```
%LOCALAPPDATA%\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js
```

**Çalıştırma:**
```powershell
.\bypass_gemini_safe.ps1
```

**Çıktı Örneği:**
```
═══════════════════════════════════════════════════
  Google Gemini Rate Limit BYPASS (Safe Mode)
═══════════════════════════════════════════════════

Cursor kapatılıyor...
[1/3] Yedek oluşturuluyor...
  ✓ Yedek oluşturuldu

[2/3] Dosya düzenleniyor...
  Orijinal: 26.43 MB
  ✓ statusCode===429 bypass edildi
  ✓ case 429 bypass edildi

[3/3] Dosya yazılıyor...
  ✓ Yazıldı: 26.43 MB

═══════════════════════════════════════════════════
              ✓ BYPASS TAMAMLANDI!          
═══════════════════════════════════════════════════

📊 ÖZET:
  • Orijinal: 26.43 MB
  • Yeni: 26.43 MB
  • Değişiklik: 2

🔧 HTTP 429 (Rate Limit) -> 999 (bypass)

🚀 Cursor'u başlatın!
✨ Gemini rate limit artık tetiklenmeyecek!
```

**Pattern'ler:**
```powershell
# HTTP 429 status kodunu bypass et
.statusCode===429 → .statusCode===999
.status===429 → .status===999

# Switch case'leri bypass et
case 429: → case 999:
```

**Özellikler:**
- ✅ Binary-safe okuma/yazma (encoding sorunu yok)
- ✅ Minimal değişiklik (sadece 2-3 yer)
- ✅ Dosya boyutu değişmez
- ✅ En güvenli yöntem

---

## 🔒 Güvenlik

### Script Güvenliği

✅ **Kaynak Kodu Açık**: Tüm scriptleri inceleyebilirsiniz  
✅ **Otomatik Yedekleme**: Her zaman geri dönebilirsiniz  
✅ **Zararsız İşlemler**: Sadece Cursor dosyalarını düzenler  
✅ **Bilinen Pattern'ler**: Sadoc güvenli regex kullanır

### Execution Policy

Script çalıştırmadan önce:

```powershell
# Sadece bu session için izin ver (önerilen)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# veya tüm kullanıcı için
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

### Yedekleri Geri Yükleme

**Yöntem 1: Manuel Geri Yükleme**

```powershell
# workbench.desktop.main.js için
Copy-Item -Path "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js.backup" `
          -Destination "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js" `
          -Force

# State database için
Copy-Item -Path "C:\Users\YourName\cursor_rate_limit_backup_YYYYMMDD_HHMMSS\state.vscdb.backup" `
          -Destination "$env:APPDATA\Cursor\User\globalStorage\state.vscdb" `
          -Force
```

**Yöntem 2: Cursor'u Yeniden Yükle**

En son çare olarak Cursor'u tamamen kaldırıp yeniden yükleyin.

---

## 🔧 Sorun Giderme

### "Script çalışmıyor"

**Çözüm:**
```powershell
# Execution policy'yi kontrol et
Get-ExecutionPolicy

# Bypass yap
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
```

---

### "Workbench dosyası bulunamadı"

**Çözüm:**
1. Cursor'un kurulu olduğundan emin olun
2. Standart dışı konuma kurduysanız script'i düzenleyin:

```powershell
# Script içindeki path'i değiştirin
$workbenchPath = "C:\CustomPath\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js"
```

---

### "Cursor güncellemesinden sonra sorunlar tekrar geldi"

**Sebep:** Cursor güncellemesi workbench dosyasını değiştiriyor.

**Çözüm:** İlgili scripti tekrar çalıştırın.

---

### "Değişiklikler uygulanmadı"

**Kontrol Listesi:**
1. ✅ Cursor tamamen kapalı mı?
2. ✅ PowerShell yönetici olarak mı açıldı?
3. ✅ Script başarıyla tamamlandı mı?
4. ✅ Cursor yeniden başlatıldı mı?

---

### "Dosya boyutu çok büyüdü"

**Sebep:** Encoding sorunu - UTF-8 BOM eklenmiş olabilir.

**Çözüm:** 
1. Yedeği geri yükleyin
2. `bypass_gemini_safe.ps1` kullanın (binary-safe)

```powershell
# Yedekten geri yükle
$workbenchPath = "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js"
$backupPath = "$workbenchPath.backup"  # En son yedek
Copy-Item -Path $backupPath -Destination $workbenchPath -Force
```

---

### "Rate limit hala devam ediyor"

**Çözüm Sırası:**
1. **State database temizleyin**: `fix_cursor_rate_limit.ps1`
2. **HTTP 429 bypass**: `bypass_gemini_safe.ps1`
3. **Cursor'u tamamen kapatıp açın**
4. **Gemini API key'inizi yeniden girin**

**Kombo Çözüm:**
```powershell
# 1. Cache ve state temizle
.\fix_cursor_rate_limit.ps1

# 2. HTTP 429 bypass
.\bypass_gemini_safe.ps1

# 3. top_k hatası düzelt
.\fix_cursor_top_k.ps1

# 4. Cursor'u aç
```

---

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! İşte nasıl katkıda bulunabilirsiniz:

### 1. Yeni Sorun Bildir

[Issues](https://github.com/yourusername/cursor-fix-scripts/issues) bölümünden yeni sorun bildirin.

**Şablon:**
```markdown
**Sorun:**
[Hata mesajını buraya yazın]

**Cursor Versiyonu:**
[Örn: 0.42.3]

**Windows Versiyonu:**
[Örn: Windows 11 23H2]

**Adımlar:**
1. [Sorunu nasıl tekrarladığınızı açıklayın]
```

### 2. Pull Request Gönderin

```bash
# Fork edin
git fork https://github.com/yourusername/cursor-fix-scripts

# Branch oluşturun
git checkout -b feature/yeni-cozum

# Değişiklikleri commit edin
git commit -m "feat: yeni sorun için çözüm eklendi"

# Push edin
git push origin feature/yeni-cozum

# Pull request açın
```

### 3. Script İyileştirmeleri

Mevcut scriptleri iyileştirmek için:
- Daha iyi pattern'ler önerin
- Performans optimizasyonları yapın
- Hata yönetimini geliştirin

---

## 📊 İstatistikler

| Script | Dosya Boyutu | Satır Sayısı | Etkilenen Dosya |
|--------|-------------|-------------|----------------|
| `install.ps1` | ~2.5 KB | 50 satır | Tüm scriptleri çalıştırır |
| `fix_cursor_top_k.ps1` | ~1.5 KB | 33 satır | workbench.desktop.main.js (~27 MB) |
| `fix_cursor_rate_limit.ps1` | ~2.4 KB | 54 satır | state.vscdb + Cache |
| `bypass_gemini_safe.ps1` | ~3.8 KB | 87 satır | workbench.desktop.main.js (~27 MB) |

---

## 🎓 Teknik Detaylar

### Regex Pattern Açıklamaları

#### Pattern 1: `top_k` Kaldırma
```powershell
',\s*top_k\s*:\s*[^,}]+'
```
- `,` : Virgül ile başlayan
- `\s*` : 0 veya daha fazla boşluk
- `top_k` : "top_k" metni
- `\s*:\s*` : Boşluklu veya boşluksuz iki nokta
- `[^,}]+` : Virgül veya } karakteri olmayan herhangi bir karakter

#### Pattern 2: Rate Limit Kontrolü Devre Dışı
```powershell
'(if\s*\([^)]*rate.?limit[^)]*\))\s*{([^}]*throw[^}]*)}' → 'if(false){$2}'
```
- `if\s*\(` : "if" ile açılan parantez
- `[^)]*rate.?limit[^)]*` : "rate limit" içeren koşul
- `{([^}]*throw[^}]*)}` : "throw" içeren blok
- `if(false)` : Koşulu her zaman false yap

---

## 🌟 Popüler Kullanım Senaryoları

### Senaryo 1: İlk Kurulum (Önerilen)
```powershell
# Tam koruma paketi
.\fix_cursor_top_k.ps1              # top_k hatası düzelt
.\bypass_gemini_safe.ps1            # HTTP 429 bypass
.\fix_cursor_rate_limit.ps1         # Cache temizle
```

### Senaryo 2: Güncellemeden Sonra
```powershell
# Sadece workbench scriptlerini tekrar çalıştır
.\fix_cursor_top_k.ps1
.\bypass_gemini_safe.ps1
```

### Senaryo 3: Sadece Rate Limit Sorunu
```powershell
# İki aşamalı çözüm
.\fix_cursor_rate_limit.ps1         # State database temizle
.\bypass_gemini_safe.ps1            # HTTP 429 bypass
```

### Senaryo 4: Gemini Kullanmıyorum
```powershell
# Sadece temel düzeltmeler
.\fix_cursor_top_k.ps1
.\fix_cursor_rate_limit.ps1
```

---

## 📚 Referanslar

- [Cursor IDE Resmi Dokümantasyon](https://cursor.sh/docs)
- [Google Gemini API Dokümantasyon](https://ai.google.dev/docs)
- [PowerShell Dokümantasyon](https://docs.microsoft.com/powershell)

---

## 🛠️ Gereksinimler

- **Windows 10/11**: (Windows 8.1+ da çalışabilir)
- **PowerShell 5.1+**: (Varsayılan olarak yüklü)
- **Cursor IDE**: Herhangi bir versiyon
- **Yönetici Yetkisi**: Script çalıştırmak için

---

## 🔄 Güncelleme Geçmişi

### v1.1.0 (2025-11-21)
- 🎯 **YENİ**: `bypass_gemini_safe.ps1` eklendi (ÖNERİLEN)
- ✅ HTTP 429 rate limit bypass - binary-safe
- ✅ Encoding sorunu çözüldü
- 📝 README güncellendi (bypass script dahil)
- 🔧 Tüm senaryolar için kullanım örnekleri

### v1.0.0 (2025-11-21)
- ✨ İlk sürüm yayınlandı
- ✅ `fix_cursor_top_k.ps1` eklendi
- ✅ `fix_cursor_rate_limit.ps1` eklendi
- ✅ `remove_gemini_rate_limit.ps1` eklendi
- 📝 Detaylı README hazırlandı

---

## ❓ SSS (Sık Sorulan Sorular)

### Scriptler zararlı mı?

**Hayır.** Tüm scriptler açık kaynak ve incelenebilir. Sadece Cursor'un konfigürasyon dosyalarını düzenler ve otomatik yedek alır.

### Cursor güncellemesi scriptleri bozar mı?

**Evet, bazı güncellemelerde.** Cursor güncellendiğinde `workbench.desktop.main.js` dosyası değişir. Bu durumda scriptleri tekrar çalıştırmanız yeterli.

### Scriptler diğer IDE'lerde çalışır mı?

**Hayır.** Bu scriptler özellikle Cursor IDE için tasarlanmıştır. VS Code, VS Code forkları veya diğer IDE'lerde çalışmaz.

### Linux/macOS desteği var mı?

**Şu anda hayır.** Bu scriptler Windows PowerShell için yazılmıştır. Ancak bash versiyonları kolayca uyarlanabilir. Katkıda bulunmak isterseniz pull request gönderin!

### Scriptler lisanslı mı?

**MIT Lisansı.** Özgürce kullanabilir, değiştirebilir ve dağıtabilirsiniz.

### Hangi scripti kullanmalıyım?

**Gemini kullanıyorsanız (ÖNERİLEN):**
1. `bypass_gemini_safe.ps1` - HTTP 429 bypass (en güvenli)
2. `fix_cursor_top_k.ps1` - top_k hatası düzelt
3. `fix_cursor_rate_limit.ps1` - Cache temizle

**Sadece top_k sorunu varsa:**
- `fix_cursor_top_k.ps1`

**Rate limit ama Gemini kullanmıyorsanız:**
- `fix_cursor_rate_limit.ps1` (state database temizler)

### Dosya boyutu büyüdü, ne yapmalıyım?

**Sorun:** Encoding hatası - UTF-8 BOM eklendi.

**Çözüm:**
1. Yedeği geri yükleyin
2. `bypass_gemini_safe.ps1` kullanın (binary-safe, dosya boyutu değişmez)
3. Diğer scriptleri **KULLANMAYIN**

---

## 💬 Destek

Sorun mu yaşıyorsunuz? Yardıma ihtiyacınız mı var?

- 🐛 **Bug Report**: [Issues](https://github.com/IamYGT/cursor-fix-scripts/issues)
- 💡 **Feature Request**: [Discussions](https://github.com/IamYGT/cursor-fix-scripts/discussions)
- 📧 **Email**: iamygt.dev@gmail.com
- 📸 **Instagram**: [@ercanygt.dev](https://instagram.com/ercanygt.dev)

---

## 🙏 Teşekkürler

Bu scriptleri kullandığınız için teşekkürler! Eğer işinize yaradıysa:

- ⭐ Repo'ya star verin
- 🔄 Arkadaşlarınızla paylaşın
- 🐛 Sorunları bildirin
- 🤝 Katkıda bulunun

---

## 📄 Lisans

MIT License - detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

<div align="center">

**Made with ❤️ by [@IamYGT](https://github.com/IamYGT)**

📧 iamygt.dev@gmail.com | 📸 [@ercanygt.dev](https://instagram.com/ercanygt.dev)

[⬆ Başa Dön](#-cursor-ide-fix-scripts)

</div>
