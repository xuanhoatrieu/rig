# Rig v5.1.0 Installer — Windows PowerShell
# Usage: iex "& { $(irm https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }"

$ErrorActionPreference = "Stop"
$Version = "5.1.0"
$Repo = "xuanhoatrieu/rig"
$GeminiDir = "$env:USERPROFILE\.gemini"
$AntigravityDir = "$GeminiDir\antigravity"
$BinDir = "$env:USERPROFILE\.local\bin"

Write-Host "🚀 Installing Rig v$Version..." -ForegroundColor Cyan

# ─── Create directories ───
New-Item -ItemType Directory -Force -Path "$AntigravityDir\core\templates\high-risk-story" | Out-Null
New-Item -ItemType Directory -Force -Path "$AntigravityDir\core\patterns" | Out-Null
New-Item -ItemType Directory -Force -Path "$AntigravityDir\workflows" | Out-Null
New-Item -ItemType Directory -Force -Path "$AntigravityDir\skills" | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

# ─── Download rig binary ───
$BinaryName = "rig-windows-x86_64.exe"
$DownloadUrl = "https://github.com/$Repo/releases/download/v$Version/$BinaryName"

Write-Host "📦 Downloading rig binary..."
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile "$BinDir\rig.exe" -UseBasicParsing
    Write-Host "✅ rig.exe installed to $BinDir\rig.exe" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Binary download failed. Build from source:" -ForegroundColor Yellow
    Write-Host "   cd cli; cargo build --release" -ForegroundColor Yellow
}

# ─── Download and extract repo ───
Write-Host "📄 Downloading core docs, workflows, and skills..."
$TmpDir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
$ZipUrl = "https://github.com/$Repo/archive/refs/heads/main.zip"

try {
    $ZipPath = "$TmpDir\rig.zip"
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
    Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force

    Copy-Item -Recurse -Force "$TmpDir\rig-main\core\*" "$AntigravityDir\core\"
    Copy-Item -Recurse -Force "$TmpDir\rig-main\workflows\*" "$AntigravityDir\workflows\"
    if (Test-Path "$TmpDir\rig-main\skills") {
        Copy-Item -Recurse -Force "$TmpDir\rig-main\skills\*" "$AntigravityDir\skills\"
    }
    Copy-Item -Force "$TmpDir\rig-main\gemini.md" "$GeminiDir\GEMINI.md"

    Remove-Item -Recurse -Force $TmpDir
    Write-Host "✅ Core docs, workflows, and skills installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Download failed: $_" -ForegroundColor Red
    exit 1
}

# ─── Save version ───
Set-Content -Path "$GeminiDir\rig_version" -Value $Version

# ─── Add to PATH ───
$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($CurrentPath -notlike "*$BinDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$BinDir;$CurrentPath", "User")
    Write-Host "📌 Added $BinDir to PATH" -ForegroundColor Green
}

# ─── Summary ───
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ Rig v$Version installed!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📁 Binary:    $BinDir\rig.exe"
Write-Host "   Core:      $AntigravityDir\core\"
Write-Host "   Workflows: $AntigravityDir\workflows\"
Write-Host "   Skills:    $AntigravityDir\skills\"
Write-Host ""
Write-Host "🎮 Quick start: type /init in AI chat"
