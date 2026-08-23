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
New-Item -ItemType Directory -Force -Path "$AntigravityDir\plugins" | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

# ─── Download and extract repo ───
Write-Host "📄 Downloading core docs, workflows, skills, and plugins..."
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
    if (Test-Path "$TmpDir\rig-main\plugins") {
        Copy-Item -Recurse -Force "$TmpDir\rig-main\plugins\*" "$AntigravityDir\plugins\"
    }
    Copy-Item -Force "$TmpDir\rig-main\gemini.md" "$GeminiDir\GEMINI.md"

    # Download pre-built binary or compile with cargo
    $BinaryName = "rig-windows-x86_64.exe"
    $DownloadUrl = "https://github.com/$Repo/releases/download/v$Version/$BinaryName"

    $Downloaded = $false
    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile "$BinDir\rig.exe" -UseBasicParsing
        $Downloaded = $true
        Write-Host "✅ rig.exe downloaded to $BinDir\rig.exe" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Pre-built binary download failed." -ForegroundColor Yellow
    }

    if (-not $Downloaded -and (Get-Command cargo -ErrorAction SilentlyContinue)) {
        Write-Host "🔨 Compiling rig CLI from source with cargo..." -ForegroundColor Cyan
        cargo build --release --manifest-path "$TmpDir\rig-main\cli\Cargo.toml"
        Copy-Item "$TmpDir\rig-main\cli\target\release\rig.exe" "$BinDir\rig.exe"
        Write-Host "✅ rig.exe compiled and installed to $BinDir\rig.exe" -ForegroundColor Green
    }

    Remove-Item -Recurse -Force $TmpDir
    Write-Host "✅ Core docs, workflows, skills, and plugins installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Installation failed: $_" -ForegroundColor Red
    exit 1
}

# ─── Save version ───
Set-Content -Path "$GeminiDir\rig_version" -Value $Version

# ─── Add to PATH ───
$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($CurrentPath -notlike "*$BinDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$BinDir;$CurrentPath", "User")
    Write-Host "📌 Added $BinDir to permanent User PATH" -ForegroundColor Green
}
$env:PATH = "$BinDir;$env:PATH"

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
Write-Host "   Plugins:   $AntigravityDir\plugins\"
Write-Host ""
Write-Host "🎮 Quick start: type /init in AI chat"
Write-Host "   To update later, run: rig update"
