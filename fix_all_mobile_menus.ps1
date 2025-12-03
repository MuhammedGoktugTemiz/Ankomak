# ANKOMAK - Fix All Mobile Menus Script
# Bu script tüm HTML sayfalarındaki mobil menüyü standartlaştırır

Write-Host "ANKOMAK Mobil Menü Düzeltme Scripti Başlatılıyor..." -ForegroundColor Green

# Tüm HTML dosyalarını bul
$htmlFiles = Get-ChildItem -Path "." -Filter "*.html" -Recurse:$false

# Eski mobil menü yapısı (farklı varyasyonlar)
$oldPatterns = @(
    @{
        Pattern = '<div id="mobileMenu" class="mobile-menu p-6 flex flex-col space-y-4 md:hidden z-40 bg-white">'
        Replacement = '<div id="mobileMenu" class="mobile-menu hidden md:hidden z-40">'
    },
    @{
        Pattern = '<button id="closeMenu" class="self-end text-black text-2xl font-bold focus:outline-none" aria-label="Menüyü Kapat">'
        Replacement = '<button id="closeMenu" class="mobile-menu-close" aria-label="Menüyü Kapat">'
    },
    @{
        Pattern = '<button id="closeMenu" class="self-end text-black text-2xl font-bold">X</button>'
        Replacement = '<button id="closeMenu" class="mobile-menu-close" aria-label="Menüyü Kapat"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>'
    },
    @{
        Pattern = '<div class="flex items-center mb-4">\s*<img src="img/anko_logo.png" class="h-8 w-auto mr-3" alt="ANKOMAK Logo" />\s*<span class="font-bold text-lg text-gray-800">ANKOMAK</span>\s*</div>'
        Replacement = '<div class="mobile-menu-header"><div class="flex items-center"><img src="img/anko_logo.png" class="h-8 w-auto mr-3" alt="ANKOMAK Logo" /><span class="font-bold text-lg">ANKOMAK</span></div><button id="closeMenu" class="mobile-menu-close" aria-label="Menüyü Kapat"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button></div><nav class="mobile-menu-nav">'
    },
    @{
        Pattern = '<a class="font-bold text-lg py-2 border-b border-gray-200" href="index.html">Ana Sayfa</a>'
        Replacement = '<a class="mobile-menu-link" href="index.html">Ana Sayfa</a>'
    },
    @{
        Pattern = '<a class="font-bold text-lg py-2 border-b border-gray-200" href="kurumsal.html">Hakkımızda</a>'
        Replacement = '<a class="mobile-menu-link" href="kurumsal.html">Hakkımızda</a>'
    },
    @{
        Pattern = '<a class="font-bold text-lg py-2 border-b border-gray-200" href="gecmisten-gunumuze-ankomak.html">Geçmişten Günümüze</a>'
        Replacement = '<a class="mobile-menu-link" href="gecmisten-gunumuze-ankomak.html">Geçmişten Günümüze</a>'
    },
    @{
        Pattern = '<a class="font-bold text-lg py-2 border-b border-gray-200" href="Makinalarımız.html">Makinelerimiz</a>'
        Replacement = '<a class="mobile-menu-link" href="Makinalarımız.html">Makinelerimiz</a>'
    },
    @{
        Pattern = '<a class="font-bold text-lg py-2 border-b border-gray-200" href="iletisim.html">İletişim</a>'
        Replacement = '<a class="mobile-menu-link" href="iletisim.html">İletişim</a>'
    },
    @{
        Pattern = '<button\s+class="font-bold text-lg w-full text-left py-2 focus:outline-none flex items-center justify-between border-b border-gray-200"\s+onclick="toggleMobileDropdown\(''mediaSubmenu'', this\)">\s*<span>Basın ve Medya</span>\s*<span class="arrow text-xl transform transition-transform duration-200">▼</span>\s*</button>'
        Replacement = '<button class="mobile-submenu-title" onclick="toggleMobileDropdown(''mediaSubmenu'', this)"><span>Basın ve Medya</span><span class="arrow">▼</span></button>'
    },
    @{
        Pattern = '<div id="mediaSubmenu" class="mt-2 hidden space-y-2 mobile-submenu">'
        Replacement = '<div id="mediaSubmenu" class="hidden">'
    },
    @{
        Pattern = '<a class="text-base text-gray-700 hover:text-\[#a68e3f\]" href="BasındaAnkoMak.html">Basında ANKOMAK</a>'
        Replacement = '<a class="mobile-submenu-link" href="BasındaAnkoMak.html">Basında ANKOMAK</a>'
    },
    @{
        Pattern = '<a class="text-base text-gray-700 hover:text-\[#a68e3f\]" href="Videolarımız.html">Video Galeri</a>'
        Replacement = '<a class="mobile-submenu-link" href="Videolarımız.html">Video Galeri</a>'
    },
    @{
        Pattern = '</div>\s*</div>\s*</div>'
        Replacement = '</div></div></nav></div>'
    }
)

# Standart mobil menü yapısı
$standardMobileMenu = @'
    <!-- Mobil Menü -->
    <div id="mobileMenu" class="mobile-menu hidden md:hidden z-40">
      <div class="mobile-menu-header">
        <div class="flex items-center">
          <img src="img/anko_logo.png" class="h-8 w-auto mr-3" alt="ANKOMAK Logo" />
          <span class="font-bold text-lg">ANKOMAK</span>
        </div>
        <button id="closeMenu" class="mobile-menu-close" aria-label="Menüyü Kapat">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <nav class="mobile-menu-nav">
        <a class="mobile-menu-link" href="index.html">Ana Sayfa</a>
        <a class="mobile-menu-link" href="kurumsal.html">Hakkımızda</a>
        <a class="mobile-menu-link" href="gecmisten-gunumuze-ankomak.html">Geçmişten Günümüze</a>

        <!-- Basın ve Medya açılır menü -->
        <div class="mobile-submenu">
          <button 
            class="mobile-submenu-title"
            onclick="toggleMobileDropdown('mediaSubmenu', this)"
          >
            <span>Basın ve Medya</span>
            <span class="arrow">▼</span>
          </button>

          <div id="mediaSubmenu" class="hidden">
            <a class="mobile-submenu-link" href="BasındaAnkoMak.html">Basında ANKOMAK</a>
            <a class="mobile-submenu-link" href="Videolarımız.html">Video Galeri</a>
          </div>
        </div>

        <a class="mobile-menu-link" href="Makinalarımız.html">Makinelerimiz</a>
        <a class="mobile-menu-link" href="iletisim.html">İletişim</a>
      </nav>
    </div>
'@

$processedCount = 0
$errorCount = 0

foreach ($file in $htmlFiles) {
    try {
        Write-Host "İşleniyor: $($file.Name)" -ForegroundColor Yellow
        
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Eğer eski mobil menü yapısı varsa, standart yapıyla değiştir
        if ($content -match 'id="mobileMenu"') {
            # Eski mobil menüyü bul ve değiştir
            $pattern = '(?s)<!-- Mobil Menü.*?</div>\s*</div>'
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $standardMobileMenu
                
                # Dosyayı kaydet
                Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
                
                Write-Host "✓ Güncellendi: $($file.Name)" -ForegroundColor Green
                $processedCount++
            } else {
                Write-Host "⚠ Mobil menü bulunamadı: $($file.Name)" -ForegroundColor Cyan
            }
        } else {
            Write-Host "⚠ Mobil menü yok: $($file.Name)" -ForegroundColor Cyan
        }
    }
    catch {
        Write-Host "✗ Hata: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n=== ÖZET ===" -ForegroundColor Green
Write-Host "İşlenen dosya: $processedCount" -ForegroundColor White
Write-Host "Hata sayısı: $errorCount" -ForegroundColor White
Write-Host "Toplam kontrol edilen: $($htmlFiles.Count)" -ForegroundColor White

if ($errorCount -eq 0 -and $processedCount -gt 0) {
    Write-Host "`n✓ Tüm mobil menüler başarıyla güncellendi!" -ForegroundColor Green
} elseif ($processedCount -eq 0) {
    Write-Host "`n⚠ Hiçbir dosya güncellenmedi. Dosyalar zaten güncel olabilir." -ForegroundColor Yellow
} else {
    Write-Host "`n⚠ Bazı dosyalarda hata oluştu. Lütfen yukarıdaki çıktıyı kontrol edin." -ForegroundColor Yellow
}

Write-Host "`nMobil menü düzeltme tamamlandı!" -ForegroundColor Green