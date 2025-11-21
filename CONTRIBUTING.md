# Katkıda Bulunma Rehberi

Katkılarınızı bekliyoruz! Bu projeye katkıda bulunmak için aşağıdaki adımları izleyin.

## 🚀 Başlarken

1. **Fork edin** - Bu repo'yu kendi hesabınıza fork edin
2. **Clone edin** - Fork'unuzu local'e klonlayın
3. **Branch oluşturun** - Yeni bir feature branch oluşturun
4. **Değişiklik yapın** - Kodunuzu yazın ve test edin
5. **Commit edin** - Anlamlı commit mesajları kullanın
6. **Push edin** - Branch'inizi GitHub'a push edin
7. **Pull Request** - PR açın ve açıklama ekleyin

## 📝 Commit Mesajları

Commit mesajları için şu formatı kullanın:

```
<tip>: <kısa açıklama>

<detaylı açıklama (opsiyonel)>
```

**Tipler:**
- `feat`: Yeni özellik
- `fix`: Bug düzeltmesi
- `docs`: Dokümantasyon
- `style`: Kod formatı
- `refactor`: Kod iyileştirmesi
- `test`: Test ekleme
- `chore`: Bakım işleri

**Örnekler:**
```
feat: HTTP 429 bypass scripti eklendi

Gemini API için HTTP 429 status kodunu bypass eden güvenli script.
Binary-safe encoding kullanır, dosya boyutu değişmez.

fix: encoding sorunu düzeltildi

UTF-8 BOM sorunu giderildi, artık dosya boyutu değişmiyor.

docs: README'ye bypass scripti eklendi
```

## 🧪 Test

Yeni scriptler eklerken:

1. ✅ Cursor'da test edin
2. ✅ Yedekleme fonksiyonunu test edin
3. ✅ Error handling ekleyin
4. ✅ Dosya boyutunu kontrol edin
5. ✅ README'ye dokümantasyon ekleyin

## 📋 Checklist

Pull request açmadan önce:

- [ ] Kod çalışıyor ve test edildi
- [ ] Yedekleme mekanizması var
- [ ] Error handling eklendi
- [ ] README güncellendi
- [ ] Örnek çıktı eklendi
- [ ] Commit mesajları anlamlı

## 🐛 Bug Raporu

Bug bildirirken şunları ekleyin:

```markdown
**Sorun:**
[Hata mesajını buraya yazın]

**Cursor Versiyonu:**
[Örn: 0.42.3]

**Windows Versiyonu:**
[Örn: Windows 11 23H2]

**Script:**
[Hangi scripti kullandınız]

**Adımlar:**
1. [Sorunu nasıl tekrarladığınızı açıklayın]

**Beklenen:**
[Ne olmasını bekliyordunuz]

**Gerçekleşen:**
[Ne oldu]

**Ekran Görüntüsü:**
[Varsa ekleyin]
```

## 💡 Feature Request

Yeni özellik önerirken:

```markdown
**Özellik:**
[Özelliği açıklayın]

**Neden gerekli:**
[Kullanım senaryosu]

**Örnek kullanım:**
```powershell
# Kod örneği
```

**Alternatifler:**
[Başka çözümler denediniz mi]
```

## 🎯 Kod Standartları

### PowerShell

- Değişken isimleri `$camelCase`
- Fonksiyon isimleri `PascalCase`
- Yorum satırları Türkçe
- Output mesajları Türkçe
- Error handling her zaman kullanın

**Örnek:**
```powershell
# Dosyayı yedekle
function Backup-WorkbenchFile {
    param(
        [string]$FilePath
    )
    
    try {
        $backupPath = "$FilePath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item -Path $FilePath -Destination $backupPath -Force
        Write-Host "✓ Yedek oluşturuldu" -ForegroundColor Green
        return $backupPath
    }
    catch {
        Write-Host "❌ Yedekleme başarısız: $_" -ForegroundColor Red
        exit 1
    }
}
```

### Markdown (README)

- Başlıklar için emoji kullanın
- Kod blokları için syntax highlighting
- Örnekler ekleyin
- Tablo kullanın (uygun yerlerde)

## 🙏 Teşekkürler

Katkıda bulunduğunuz için teşekkürler! Her katkı önemlidir:

- 🐛 Bug raporları
- 💡 Özellik önerileri
- 📝 Dokümantasyon iyileştirmeleri
- 🧪 Test senaryoları
- 🌍 Çeviriler (EN/TR)

## 📞 İletişim

Sorularınız için:
- **Issues**: [GitHub Issues](https://github.com/IamYGT/cursor-fix-scripts/issues)
- **Discussions**: [GitHub Discussions](https://github.com/IamYGT/cursor-fix-scripts/discussions)
- **Email**: iamygt.dev@gmail.com
- **Instagram**: [@ercanygt.dev](https://instagram.com/ercanygt.dev)
