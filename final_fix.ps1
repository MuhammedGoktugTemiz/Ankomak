# Son düzeltme için PowerShell script
$htmlFiles = Get-ChildItem -Recurse -Filter "*.html"

foreach ($file in $htmlFiles) {
    Write-Host "Son düzeltme: $($file.Name)"
    
    # Dosya içeriğini oku
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # CSS linkini düzelt
    $content = $content -replace 'css/banner\.css" />`n    <link rel="stylesheet" href="css/mobile\.css" />', 'css/banner.css" />`n    <link rel="stylesheet" href="css/mobile.css" />'
    
    # JavaScript dosyasını düzelt
    $content = $content -replace '`n    <script src="mobile\.js"></script>`n', '`n    <script src="mobile.js"></script>`n'
    
    # Dosyayı kaydet
    Set-Content $file.FullName $content -Encoding UTF8
}

Write-Host "Tüm dosyalar düzeltildi!" 