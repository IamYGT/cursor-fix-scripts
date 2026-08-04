# Cursor yerel durum ve workbench betikleri

[English README](README.md) | [Guvenlik politikasi](SECURITY.md) | [MIT Lisansi](LICENSE)

[![Test](https://github.com/IamYGT/cursor-fix-scripts/actions/workflows/test.yml/badge.svg)](https://github.com/IamYGT/cursor-fix-scripts/actions/workflows/test.yml)

> **Durum: deneysel ve desteksiz.** Geçici test verileri Windows CI üzerinde doğrulanır; ancak güncel Cursor sürümleri için doğrulanmış uyumluluk matrisi yoktur. Her betiği inceleyin; yalnızca yedekli ya da kaybetmeyi göze alabildiğiniz yerel Cursor kurulumunda kullanın.

## Bu depo ne yapar, ne yapmaz

Bu Windows PowerShell betikleri yalnızca yerel Cursor dosya ve klasörlerinde işlem yapar. Eski bir yerel durumu veya sürüme bağlı bir `top_k` sorununu araştırmaya yardımcı olabilirler; Gemini, Cursor ya da başka bir sağlayıcıdaki hesap, faturalama planı, kota veya sunucu tarafı hız sınırını değiştirmezler.

Sağlayıcı tarafındaki `429`, kota veya hesap sınırı bu betiklerle aşılamaz. Bunun için sağlayıcının desteklediği kota, faturalama, yeniden deneme veya destek yolunu kullanın. Workbench düzenleme betikleri yalnızca yerel uygulamanın yanıta yaklaşımını değiştirebilir; üst hizmetin sınırlandırdığı isteği kabul ettiremez.

## Dosya envanteri

| Dosya | Gerçek davranış | Başlıca yerel etki |
| --- | --- | --- |
| `fix_cursor_rate_limit.ps1` | `state.vscdb` dosyasını yedekler, siler; Cursor `Cache` ve `Code Cache` klasörlerini özyinelemeli siler. | Yerel workbench durumunu/önbelleği sıfırlar; önbellek içeriği **yedeklenmez**. |
| `fix_cursor_top_k.ps1` | Cursor `workbench.desktop.main.js` dosyasını yedekler, sonra seçili `top_k` özelliklerini regex ile kaldırır. | Kurulu uygulama paketini değiştirir. Yedek adı sabittir; sonraki çalıştırmada üzerine yazılabilir. |
| `bypass_gemini_safe.ps1` | Aynı workbench dosyasında seçili yerel `429` karşılaştırmalarını `999` ile değiştirir ve zaman damgalı yedek oluşturur. | Yalnızca yerel hata işleme davranışını değiştirir; sağlayıcı sınırını aşmaz, hataları gizleyebilir veya değiştirebilir. |
| `install.ps1` | Varsayılan olarak çalışmayı reddeder; `-ApplyAll` üç betiği açıkça sırayla çalıştırır. | İşlem bütünsel değildir; bir alt betik başarısız olursa önceki değişiklikleri geri almaz. |

`remove_gemini_rate_limit.ps1` bu depoda yoktur. Eski belgelerdeki bu başvuru yanlıştı.

## Çalıştırmadan önce

1. Cursor'u kapatın; kaybetmek istemediğiniz çalışmayı senkronlayın veya dışa aktarın.
2. Cursor sürümünü kaydedin; hedef dosyanın veya profil klasörünün ayrıca bağımsız kopyasını alın.
3. Çalıştıracağınız betiği okuyun. Betikler sabit Windows yolları kullanır ve güncel Cursor sürümlerinde doğrulanmış değildir.
4. Cursor güncellemelerinin `workbench.desktop.main.js` dosyasını değiştirebileceğini unutmayın; eski eşleşen desenin hâlâ bulunduğunu varsaymayın.
5. Belirli bir yerel belirti için yalnızca bir betik çalıştırın. `install.ps1` genel onarım komutu değildir.

Cursor çalışıyorsa betikler `Stop-Process -Force` çağırır. Kaydedilmemiş düzenleyici çalışmasını önce kaydedin. Betikler yerel durumu değiştirebilir veya kaldırabilir; kurtarma, güvenlik ya da uyumluluk vaadi vermez.

## Windows kullanımı

Normal bir PowerShell penceresinde depoyu klonlayın/indirin ve önce seçili dosyayı inceleyin:

```powershell
git clone https://github.com/IamYGT/cursor-fix-scripts.git
cd cursor-fix-scripts
Get-Content .\fix_cursor_rate_limit.ps1
```

Çalıştırma ilkesi yerel betiği engelliyorsa değişikliği yalnızca geçerli kabukla sınırlayın:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Yukarıdaki kontrollerden sonra yalnızca **bir** betik çalıştırın:

```powershell
.\fix_cursor_rate_limit.ps1  # yerel durum/önbellek temizliği
.\fix_cursor_top_k.ps1       # yerel workbench top_k yaması
.\bypass_gemini_safe.ps1     # yerel 429 işleme yaması; kota aşma yöntemi değildir
```

`install.ps1`, `-ApplyAll` verilmeden değişiklik yapmaz ve rutin kullanım için önerilmez. Açık seçimle çalıştırıldığında desenin eşleştiğini, Cursor'un sonra açıldığını veya üst hizmet hatasının çözüldüğünü doğrulamaz.

## Testler

Pester paketi `LOCALAPPDATA`, `APPDATA` ve `USERPROFILE` yollarını geçici test verilerine yönlendirir ve Cursor süreç keşfini taklit eder. Sözdizimi, yedek oluşturma, sınırlı dosya değişikliği, önbellek kapsamı, doğru çıktı ve kurucunun varsayılan değişiklik yapmama davranışı doğrulanır. Gerçek Cursor kurulumu hedeflenmez.

```powershell
Install-Module Pester -RequiredVersion 6.0.1 -Scope CurrentUser
Invoke-Pester -Path tests -CI -Output Detailed
```

GitHub Actions aynı komutu `windows-latest` üzerinde çalıştırır. Değişiklik yapmadan önce [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını okuyun.

## Yedekler ve kurtarma

- `fix_cursor_rate_limit.ps1`, `%USERPROFILE%\cursor_rate_limit_backup_<timestamp>` oluşturur ve yalnızca varsa `%APPDATA%\Cursor\User\globalStorage\state.vscdb` dosyasını yedekler.
- `bypass_gemini_safe.ps1`, `workbench.desktop.main.js.backup_safe_<timestamp>` gibi zaman damgalı aynı klasör yedeği oluşturur.
- `fix_cursor_top_k.ps1`, `workbench.desktop.main.js.backup` oluşturur; sonraki çalıştırmada bu yedeğin üzerine yazar.
- Hiçbir betik `Cache` veya `Code Cache` klasörlerini silmeden önce yedeklemez.

Workbench düzenlemesini geri almak için Cursor'u kapatın ve seçtiğiniz yedeği `workbench.desktop.main.js` üzerine kopyalayın. Geçerli yedek yoksa Cursor'u desteklenen yükleyicisiyle onarın veya yeniden kurun. Farklı Cursor sürümünün yedeğini incelemeden kullanmayın.

## Sorun giderme sınırları

- **Workbench dosyası bulunamadı:** betik `%LOCALAPPDATA%\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js` yolunu bekler. Bilinmeyen kurulumu körlemesine değiştirmeyin.
- **Değişiklik bildirilmedi:** güncel Cursor yapısında betiğin birebir desenleri olmayabilir. Bu, betiğin bir şeyi düzelttiğinin kanıtı değildir.
- **Workbench düzenlemesinden sonra Cursor açılmıyor:** Cursor'u kapatın, yedeği geri yükleyin; sonra desteklenen Cursor onarım/yeniden kurulum yolunu kullanın.
- **`429` veya kota sürüyor:** gerekiyorsa yerel yamayı geri alın ve hesap/sağlayıcı sınırını desteklenen kanaldan çözün. Yerel temizlik sunucu zorlamasını değiştiremez.

## Bakım ve destek

Bu tarihsel ve deneysel depo için bakım, uyumluluk, yanıt süresi veya destek kanalı sözü verilmez. Sorun bildirimi ve pull request yararlı olabilir; destek sözleşmesi değildir. Cursor sürümü, Windows sürümü, tam betik adı, gizlenmiş hata ve hedef desenin bulunup bulunmadığını ekleyin. API anahtarı, token, profil veritabanı veya özel workbench dosyası paylaşmayın.

Güvenlik bildirimi için [SECURITY.md](SECURITY.md), katkı için [CONTRIBUTING.md](CONTRIBUTING.md) dosyasına bakın.
