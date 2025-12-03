# PowerShell script to update navbar across all HTML pages
# This script will update the navbar structure in all HTML files

$htmlFiles = Get-ChildItem -Path "." -Filter "*.html" | Where-Object { $_.Name -ne "index.html" }

# Define the new navbar structure
$newNavbar = @'
    <nav id="navbar" class="navbar p-4 z-30">
      <div class="max-w-7xl mx-auto flex justify-between items-center">
        <a href="index.html" class="flex items-center">
          <img src="img/anko_logo.png" class="h-12 w-auto" alt="ANKOMAK Logo" />
        </a>
        
        <ul class="hidden md:flex space-x-6 menu1">
          <li class="transition cursor-pointer font-semibold">
            <a href="index.html">Ana Sayfa <span class="left-border"></span><span class="right-border"></span><span class="bottom-border"></span></a>
          </li>
          <li class="transition cursor-pointer font-semibold">
            <a href="kurumsal.html">Hakkımızda <span class="left-border"></span><span class="right-border"></span><span class="bottom-border"></span></a>
          </li>
          <li class="transition cursor-pointer font-semibold">
            <a href="gecmisten-gunumuze-ankomak.html">Geçmişten Günümüze <span class="left-border"></span><span class="right-border"></span><span class="bottom-border"></span></a>
          </li>
          <li class="transition cursor-pointer font-semibold relative group">
            <a href="#" class="flex items-center">Basın Ve Medya <span class="left-border"></span><span class="right-border"></span><span class="bottom-border"></span>
              <svg class="w-4 h-4 ml-1 transition-transform group-hover:rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
              </svg>
            </a>
            <ul class="dropdown-menu">
              <li>
                <a href="BasındaAnkoMak.html">Basında ANKOMAK</a>
              </li>
              <li>
                <a href="Videolarımız.html">Video Galeri</a>
              </li>
            </ul>
          </li>
          <li class="transition cursor-pointer font-semibold">
            <a href="Makinalarımız.html">Makinelerimiz <span class="left-border"></span><span class="right-border"></span><span class="bottom-border"></span></a>
          </li>
          <li class="transition cursor-pointer font-semibold">
            <a href="iletisim.html">İletişim <span class="left-border"></span><span class="right-border"></span><span class="bottom-border"></span></a>
          </li>
        </ul>
        
        <button id="menuButton" class="md:hidden text-2xl focus:outline-none" aria-label="Menüyü Aç">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
        </button>
      </div>
    </nav>
'@

# Define the new mobile menu structure
$newMobileMenu = @'
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

Write-Host "Starting navbar update for $($htmlFiles.Count) HTML files..." -ForegroundColor Green

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Find and replace navbar section
    $navbarPattern = '(?s)<nav id="navbar".*?</nav>'
    if ($content -match $navbarPattern) {
        $content = $content -replace $navbarPattern, $newNavbar
        Write-Host "  ✓ Navbar updated" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Navbar not found in expected format" -ForegroundColor Yellow
    }
    
    # Find and replace mobile menu section
    $mobileMenuPattern = '(?s)<!-- Mobil Menü -->.*?</div>\s*</div>'
    if ($content -match $mobileMenuPattern) {
        $content = $content -replace $mobileMenuPattern, $newMobileMenu
        Write-Host "  ✓ Mobile menu updated" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Mobile menu not found in expected format" -ForegroundColor Yellow
    }
    
    # Add toggleMobileDropdown function if not present
    if ($content -notmatch "function toggleMobileDropdown") {
        $scriptPattern = '(?s)<script>.*?</script>'
        if ($content -match $scriptPattern) {
            $existingScript = $matches[0]
            $newScript = $existingScript -replace '</script>', @'

       function toggleMobileDropdown(id, btn) {
    const submenu = document.getElementById(id);
    const arrow = btn.querySelector(".arrow");
    submenu.classList.toggle('hidden');
    arrow.classList.toggle('rotate-180');
  }
</script>'@
            $content = $content -replace [regex]::Escape($existingScript), $newScript
            Write-Host "  ✓ Mobile dropdown function added" -ForegroundColor Green
        }
    }
    
    # Write the updated content back to the file
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "Navbar update completed!" -ForegroundColor Green
Write-Host "Updated $($htmlFiles.Count) files successfully." -ForegroundColor Green
