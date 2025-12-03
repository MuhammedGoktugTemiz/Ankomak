# PowerShell script to update all machine detail pages with standardized navbar and footer
# This script updates navbar structure, mobile menu, JavaScript, and adds footer to all machine detail pages

$machinePages = @(
    "acibadem-makinasi.html",
    "antep-yuvalama-makinasi.html", 
    "baklava-makinasi.html",
    "cop-sis-makinasi.html",
    "dolgu-kurabiye-makinasi.html",
    "donut-makinasi.html",
    "durum-makinasi.html",
    "fistik-ogutme-makinasi.html",
    "hamur-dolum-makinasi.html",
    "hamur-acma-makinasi.html",
    "ici-dolgulu-kurabiye-makinasi.html",
    "ici-dolgusuz-kurabiye-makinasi.html",
    "iki-renkli-kurabiye-makinasi.html",
    "icli-kofte-makinasi.html",
    "kaplama-makinasi.html",
    "kizartma-makinasi.html",
    "kizartma-unitesi-makinasi.html",
    "krep-makinasi.html",
    "kruvasan-makinasi.html",
    "kuru-pasta-makinasi.html",
    "manti-makinasi.html",
    "pankek-makinasi.html",
    "pasta-kesme-makinasi.html",
    "peynir-makinasi.html",
    "pizza-tost-makinasi.html",
    "pandispanya-dilimleme-makinasi.html",
    "renkli-kurabiye-makinasi.html",
    "rulo-gofret-hatti.html",
    "sigara-boregi-makinasi.html",
    "simit-makinasi.html",
    "yas-pasta-dilimleme-makinasi.html",
    "yumurta-kirma-makinasi.html"
)

# Standard navbar replacement
$standardNavbar = @'
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
            <a href="Makinalarımız.html" class="active">Makinelerimiz <span class="left-border"></span><span class="right-border"></span><span class="bottom-border"></span></a>
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

# Standard mobile menu replacement
$standardMobileMenu = @'
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

# Standard JavaScript replacement
$standardJavaScript = @'
        // Navbar scroll effect
        const navbar = document.getElementById("navbar");
        const menuButton = document.getElementById("menuButton");
        const mobileMenu = document.getElementById("mobileMenu");
        const closeMenu = document.getElementById("closeMenu");

        window.addEventListener("scroll", () => {
          if (window.scrollY > 50) {
            navbar.classList.add("scrolled");
          } else {
            navbar.classList.remove("scrolled");
          }
        });

        // Mobile menu toggle
        menuButton.addEventListener("click", () => {
          mobileMenu.classList.add("open");
        });

        closeMenu.addEventListener("click", () => {
          mobileMenu.classList.remove("open");
        });

        // Close mobile menu when clicking outside
        document.addEventListener('click', (event) => {
          if (!mobileMenu.contains(event.target) && event.target !== menuButton) {
            mobileMenu.classList.remove("open");
          }
        });

        // Mobil dropdown fonksiyonu
        function toggleMobileDropdown(id, btn) {
          const submenu = document.getElementById(id);
          const arrow = btn.querySelector(".arrow");
          submenu.classList.toggle('hidden');
          arrow.classList.toggle('rotate-180');
        }
'@

# Standard footer
$standardFooter = @'

    <!-- Footer -->
    <footer class="footer bg-gradient-to-r from-[#a08017] via-[#b08f23] to-[#867439] py-6 w-full">
      <div class="max-w-7xl mx-auto px-4 flex flex-col md:flex-row md:justify-between md:items-start space-y-6 md:space-y-0">
        
        <!-- Logo -->
        <a href="index.html">
          <img src="img/anko_logo.png" alt="ANKOMAK" class="h-12 w-auto" />
        </a>

        <!-- Linkler -->
        <nav class="footer-links flex flex-col md:flex-row md:space-x-8 text-white text-sm font-medium items-center md:items-start">

          <a href="index.html" class="mb-1 hover:text-gray-200 transition">Ana Sayfa</a>
          <a href="kurumsal.html" class="mb-1 hover:text-gray-200 transition">Hakkımızda</a>
          <a href="gecmisten-gunumuze-ankomak.html" class="mb-1 hover:text-gray-200 transition">Geçmişten Günümüze ANKOMAK</a>

          <!-- Basın ve Medya hover menü -->
          <div class="relative group mb-1">
            <span class="font-bold cursor-pointer text-center block hover:text-gray-200 transition">
              Basın ve Medya
            </span>
            <div class="absolute left-0 top-full hidden group-hover:block bg-[#b08f23] text-white text-sm py-2 px-4 rounded-b shadow-lg space-y-2 z-10 min-w-[180px]">
              <a href="BasındaAnkoMak.html" class="block hover:underline hover:bg-[#a08017] px-2 py-1 rounded transition">
                Basında ANKOMAK
              </a>
              <a href="Videolarımız.html" class="block hover:underline hover:bg-[#a08017] px-2 py-1 rounded transition">
                Video Galeri
              </a>
            </div>
          </div>

          <a href="Makinalarımız.html" class="mb-1 hover:text-gray-200 transition">Makinelerimiz</a>
          <a href="iletisim.html" class="hover:text-gray-200 transition">İletişim</a>
        </nav>
      </div>

      <!-- Alt Kısım -->
      <div class="footer-bottom text-center mt-6 text-white text-xs">
        <p>Telif Hakkı © 2025 ANKO GIDA MAKİNELERİ PAZ. SAN. TİC. LTD. ŞTİ. Tüm Hakları Saklıdır.</p>
        <p class="mt-1">
          <a href="#" class="hover:underline">Gizlilik Politikası</a> | <a href="#" class="hover:underline">Yasal Uyarı</a>
        </p>
      </div>
    </footer>
'@

foreach ($page in $machinePages) {
    if (Test-Path $page) {
        Write-Host "Updating $page..."
        
        # Read the file content
        $content = Get-Content $page -Raw -Encoding UTF8
        
        # Replace navbar (multiple patterns to catch variations)
        $content = $content -replace '<nav id="navbar" class="navbar p-4 z-30">[\s\S]*?</nav>', $standardNavbar
        
        # Replace mobile menu (multiple patterns)
        $content = $content -replace '<!-- Mobil Menü[\s\S]*?</div>\s*</div>', $standardMobileMenu
        
        # Replace JavaScript (multiple patterns)
        $content = $content -replace '// Mobil menü fonksiyonları[\s\S]*?mobileMenu\.classList\.add\(''hidden''\);', $standardJavaScript
        
        # Add footer before closing body tag if it doesn't exist
        if ($content -notmatch '<!-- Footer -->') {
            $content = $content -replace '</body>', ($standardFooter + "`n</body>")
        }
        
        # Write back to file
        Set-Content $page -Value $content -Encoding UTF8
        
        Write-Host "Updated $page successfully"
    } else {
        Write-Host "File $page not found, skipping..."
    }
}

Write-Host "All machine detail pages have been updated!"
