# ANKOMAK - Mobile Menu Update Script
# This script updates all HTML pages with the new mobile menu structure

Write-Host "ANKOMAK Mobile Menu Update Script Starting..." -ForegroundColor Green

# Get all HTML files in the current directory
$htmlFiles = Get-ChildItem -Path "." -Filter "*.html" | Where-Object { $_.Name -ne "index.html" -and $_.Name -ne "Makinalarımız.html" }

# Define the old mobile menu pattern
$oldMobileMenu = @'
    <!-- Mobil Menü -->
    <div id="mobileMenu" class="mobile-menu p-6 flex flex-col space-y-4 md:hidden z-40 bg-white">
      <button id="closeMenu" class="self-end text-black text-2xl font-bold focus:outline-none" aria-label="Menüyü Kapat">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>

      <div class="flex items-center mb-4">
        <img src="img/anko_logo.png" class="h-8 w-auto mr-3" alt="ANKOMAK Logo" />
        <span class="font-bold text-lg text-gray-800">ANKOMAK</span>
      </div>

      <a class="font-bold text-lg py-2 border-b border-gray-200" href="index.html">Ana Sayfa</a>
      <a class="font-bold text-lg py-2 border-b border-gray-200" href="kurumsal.html">Hakkımızda</a>
      <a class="font-bold text-lg py-2 border-b border-gray-200" href="gecmisten-gunumuze-ankomak.html">Geçmişten Günümüze</a>

      <!-- Basın ve Medya açılır menü -->
      <div class="mobile-submenu">
        <button 
          class="font-bold text-lg w-full text-left py-2 focus:outline-none flex items-center justify-between border-b border-gray-200"
          onclick="toggleMobileDropdown('mediaSubmenu', this)"
        >
          <span>Basın ve Medya</span>
          <span class="arrow text-xl transform transition-transform duration-200">▼</span>
        </button>

        <div id="mediaSubmenu" class="mt-2 hidden space-y-2 mobile-submenu">
          <a class="text-base text-gray-700 hover:text-[#a68e3f]" href="BasındaAnkoMak.html">Basında ANKOMAK</a>
          <a class="text-base text-gray-700 hover:text-[#a68e3f]" href="Videolarımız.html">Video Galeri</a>
        </div>
      </div>

      <a class="font-bold text-lg py-2 border-b border-gray-200" href="Makinalarımız.html">Makinelerimiz</a>
      <a class="font-bold text-lg py-2 border-b border-gray-200" href="iletisim.html">İletişim</a>
    </div>
'@

# Define the new mobile menu structure
$newMobileMenu = @'
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

# Counter for processed files
$processedCount = 0
$errorCount = 0

# Process each HTML file
foreach ($file in $htmlFiles) {
    try {
        Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
        
        # Read the file content
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Check if the old mobile menu exists in the file
        if ($content -match [regex]::Escape($oldMobileMenu)) {
            # Replace the old mobile menu with the new one
            $newContent = $content -replace [regex]::Escape($oldMobileMenu), $newMobileMenu
            
            # Write the updated content back to the file
            Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
            
            Write-Host "✓ Updated: $($file.Name)" -ForegroundColor Green
            $processedCount++
        } else {
            Write-Host "⚠ No mobile menu found in: $($file.Name)" -ForegroundColor Cyan
        }
    }
    catch {
        Write-Host "✗ Error processing $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

# Summary
Write-Host "`n=== UPDATE SUMMARY ===" -ForegroundColor Green
Write-Host "Files processed: $processedCount" -ForegroundColor White
Write-Host "Errors encountered: $errorCount" -ForegroundColor White
Write-Host "Total files checked: $($htmlFiles.Count)" -ForegroundColor White

if ($errorCount -eq 0) {
    Write-Host "`n✓ All mobile menus updated successfully!" -ForegroundColor Green
} else {
    Write-Host "`n⚠ Some files had errors. Please check the output above." -ForegroundColor Yellow
}

Write-Host "`nMobile menu update completed!" -ForegroundColor Green
