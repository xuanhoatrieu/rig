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
        # Release binary not yet available on GitHub Releases
    }

    if (-not $Downloaded -and (Get-Command cargo -ErrorAction SilentlyContinue)) {
        Write-Host "🔨 Compiling rig CLI from source with cargo..." -ForegroundColor Cyan
        cargo build --release --manifest-path "$TmpDir\rig-main\cli\Cargo.toml"
        Copy-Item "$TmpDir\rig-main\cli\target\release\rig.exe" "$BinDir\rig.exe"
        $Downloaded = $true
        Write-Host "✅ rig.exe compiled and installed to $BinDir\rig.exe" -ForegroundColor Green
    }

    # Universal script wrapper fallback if neither binary nor cargo is available
    if (-not $Downloaded) {
        Write-Host "📦 Installing universal rig CLI wrapper (cmd & ps1)..." -ForegroundColor Cyan
        $RigCmdContent = @"
@echo off
if "%~1"=="" goto help
if "%~1"=="update" goto update
if "%~1"=="doctor" goto doctor
if "%~1"=="init" goto init
if "%~1"=="--version" goto version
if "%~1"=="version" goto version
if "%~1"=="help" goto help
if "%~1"=="--help" goto help
powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.local\bin\rig.ps1" %*
exit /b %ERRORLEVEL%

:update
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex '& { $(irm https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }'"
exit /b 0

:version
echo rig v$Version
exit /b 0

:init
if not exist docs\product mkdir docs\product
if not exist docs\decisions mkdir docs\decisions
if not exist docs\plans\active mkdir docs\plans\active
if not exist docs\plans\completed mkdir docs\plans\completed
if not exist docs\patterns mkdir docs\patterns
echo [OK] Initialized Rig project structure!
exit /b 0

:doctor
powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.local\bin\rig.ps1" doctor
exit /b 0

:help
echo Rig — Harness-Core Workflow Framework v$Version
echo Commands:
echo   rig update   - Update Rig to the latest version
echo   rig doctor   - Run health and integrity checks
echo   rig init     - Initialize project folders
echo   rig version  - Show version
exit /b 0
"@
        Set-Content -Path "$BinDir\rig.cmd" -Value $RigCmdContent

        $RigPs1Content = @"
param([string]`$cmd = "help", [Parameter(ValueFromRemainingArguments = `$true)]`$rest)
switch (`$cmd) {
    "update" {
        Invoke-Expression "& { `$(Invoke-RestMethod https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }"
    }
    "version" { Write-Host "rig v$Version" -ForegroundColor Green }
    "--version" { Write-Host "rig v$Version" -ForegroundColor Green }
    "init" {
        New-Item -ItemType Directory -Force -Path "docs\product", "docs\decisions", "docs\plans\active", "docs\plans\completed", "docs\patterns" | Out-Null
        Write-Host "✅ Initialized Rig project structure!" -ForegroundColor Green
    }
    "doctor" {
        Write-Host "🩺 Rig Harness Doctor — Integrity Check" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        `$docsOk = (Test-Path "docs\product") -and (Test-Path "docs\decisions") -and (Test-Path "docs\plans")
        if (`$docsOk) { Write-Host "✅ [Docs] Project directories exist" -ForegroundColor Green }
        else { Write-Host "⚠️  [Docs] Some docs folders missing. Run 'rig init' to create." -ForegroundColor Yellow }
        if (Test-Path ".brain\brain.json") { Write-Host "✅ [Brain] .brain/brain.json exists" -ForegroundColor Green }
        if (Test-Path ".gitignore") { Write-Host "✅ [Git] .gitignore exists" -ForegroundColor Green }
        Write-Host "────────────────────────────────────" -ForegroundColor Cyan
        Write-Host "🎉 System check completed!" -ForegroundColor Green
    }
    default {
        Write-Host "Rig v$Version CLI" -ForegroundColor Cyan
        Write-Host "Usage: rig <command>"
        Write-Host "  rig update   - Update Rig"
        Write-Host "  rig doctor   - Health check"
        Write-Host "  rig init     - Init project"
    }
}
"@
        Set-Content -Path "$BinDir\rig.ps1" -Value $RigPs1Content
        Write-Host "✅ rig CLI command wrapper ready in $BinDir" -ForegroundColor Green
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
Write-Host "📁 Core:      $AntigravityDir\core\"
Write-Host "   Workflows: $AntigravityDir\workflows\"
Write-Host "   Skills:    $AntigravityDir\skills\"
Write-Host "   Plugins:   $AntigravityDir\plugins\"
Write-Host ""
Write-Host "🎮 Quick start: type /init in AI chat"
Write-Host "   To update later, run: rig update"
