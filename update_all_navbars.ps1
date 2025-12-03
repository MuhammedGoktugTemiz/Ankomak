# PowerShell script to update navbar on all HTML pages
$standardNavbar = Get-Content -Path "standard_navbar.html" -Raw

# Get all HTML files except the standard navbar template
$htmlFiles = Get-ChildItem -Path "." -Filter "*.html" | Where-Object { $_.Name -ne "standard_navbar.html" }

Write-Host "Updating navbar on $($htmlFiles.Count) HTML files..." -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Define the pattern to match the navbar section
    $navbarPattern = '(?s)<nav id="navbar".*?</nav>'
    
    if ($content -match $navbarPattern) {
        # Replace the navbar
        $content = $content -replace $navbarPattern, $standardNavbar.Trim()
        Write-Host "  ✓ Navbar updated" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Navbar not found in expected format" -ForegroundColor Yellow
    }
    
    # Also update mobile menu section
    $mobileMenuPattern = '(?s)<!-- Mobil Menü -->.*?</div>\s*</div>'
    $mobileMenuReplacement = @"
<!-- Mobil Menü -->
<div id="mobileMenu" class="mobile-menu">
  <div class="flex justify-between items-center mb-8">
    <img src="img/anko_logo.png" class="h-10 w-auto" alt="ANKOMAK Logo" />
    <button id="closeMenu" class="text-2xl focus:outline-none" aria-label="Menüyü Kapat">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
      </svg>
    </button>
  </div>
  
  <nav class="flex flex-col space-y-6">
    <a href="index.html" class="text-xl font-semibold py-2">Ana Sayfa</a>
    <a href="kurumsal.html" class="text-xl font-semibold py-2">Hakkımızda</a>
    <a href="gecmisten-gunumuze-ankomak.html" class="text-xl font-semibold py-2">Geçmişten Günümüze</a>
    
    <div class="mobile-submenu">
      <div class="text-xl font-semibold py-2 text-gray-600">Basın Ve Medya</div>
      <a href="BasındaAnkoMak.html" class="block py-1 ml-4">Basında ANKOMAK</a>
      <a href="Videolarımız.html" class="block py-1 ml-4">Video Galeri</a>
    </div>
    
    <a href="Makinalarımız.html" class="text-xl font-semibold py-2">Makinelerimiz</a>
    <a href="iletisim.html" class="text-xl font-semibold py-2">İletişim</a>
  </nav>
</div>
"@
    
    if ($content -match $mobileMenuPattern) {
        $content = $content -replace $mobileMenuPattern, $mobileMenuReplacement
        Write-Host "  ✓ Mobile menu updated" -ForegroundColor Green
    }
    
    # Set active class based on current page
    $currentPage = $file.BaseName
    switch ($currentPage) {
        "index" { 
            $content = $content -replace 'href="index\.html" class="([^"]*)"', 'href="index.html" class="$1 active"'
        }
        "kurumsal" { 
            $content = $content -replace 'href="kurumsal\.html" class="([^"]*)"', 'href="kurumsal.html" class="$1 active"'
        }
        "gecmisten-gunumuze-ankomak" { 
            $content = $content -replace 'href="gecmisten-gunumuze-ankomak\.html" class="([^"]*)"', 'href="gecmisten-gunumuze-ankomak.html" class="$1 active"'
        }
        "BasındaAnkoMak" { 
            $content = $content -replace 'href="BasındaAnkoMak\.html" class="([^"]*)"', 'href="BasındaAnkoMak.html" class="$1 active"'
        }
        "Videolarımız" { 
            $content = $content -replace 'href="Videolarımız\.html" class="([^"]*)"', 'href="Videolarımız.html" class="$1 active"'
        }
        "Makinalarımız" { 
            $content = $content -replace 'href="Makinalarımız\.html" class="([^"]*)"', 'href="Makinalarımız.html" class="$1 active"'
        }
        "iletisim" { 
            $content = $content -replace 'href="iletisim\.html" class="([^"]*)"', 'href="iletisim.html" class="$1 active"'
        }
        default {
            # For machine detail pages, remove active class from all links
            $content = $content -replace ' class="([^"]*)\s+active"', ' class="$1"'
        }
    }
    
    # Save the updated content
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "`nNavbar update completed!" -ForegroundColor Green
Write-Host "All pages now have consistent, modern navbar design." -ForegroundColor Cyan
