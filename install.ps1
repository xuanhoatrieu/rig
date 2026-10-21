# Rig v5.3.0 Installer — Windows PowerShell
# Usage: iex "& { $(irm https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }"

$ErrorActionPreference = "Stop"
$Version = "5.3.0"
$Repo = "xuanhoatrieu/rig"
$GeminiDir = "$env:USERPROFILE\.gemini"
$GeminiConfigDir = "$GeminiDir\config"
$AgySkillsDir = "$GeminiConfigDir\skills"
$AgyRulesDir = "$GeminiConfigDir\rules"
$AntigravityDir = "$GeminiDir\antigravity"
$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { "$env:USERPROFILE\.codex" }
$CodexSkillsDir = "$env:USERPROFILE\.agents\skills"
$BinDir = "$env:USERPROFILE\.local\bin"

Write-Host "🚀 Installing Rig v$Version..." -ForegroundColor Cyan

# ─── Create directories ───
New-Item -ItemType Directory -Force -Path "$AntigravityDir\core\templates\high-risk-story" | Out-Null
New-Item -ItemType Directory -Force -Path "$AntigravityDir\core\patterns" | Out-Null
New-Item -ItemType Directory -Force -Path "$AntigravityDir\workflows" | Out-Null
New-Item -ItemType Directory -Force -Path "$AntigravityDir\skills" | Out-Null
New-Item -ItemType Directory -Force -Path "$AntigravityDir\plugins" | Out-Null
New-Item -ItemType Directory -Force -Path $AgySkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $AgyRulesDir | Out-Null
New-Item -ItemType Directory -Force -Path $CodexHome | Out-Null
New-Item -ItemType Directory -Force -Path $CodexSkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

function Install-RigFromRoot {
    param([string]$SourceRoot)

    Copy-Item -Recurse -Force "$SourceRoot\core\*" "$AntigravityDir\core\"
    Copy-Item -Recurse -Force "$SourceRoot\workflows\*" "$AntigravityDir\workflows\"
    if (Test-Path "$SourceRoot\skills") {
        Copy-Item -Recurse -Force "$SourceRoot\skills\*" "$AntigravityDir\skills\"
        Get-ChildItem "$SourceRoot\skills" -Directory | ForEach-Object {
            $TargetAgySkill = Join-Path $AgySkillsDir $_.Name
            New-Item -ItemType Directory -Force -Path $TargetAgySkill | Out-Null
            Copy-Item -Recurse -Force "$($_.FullName)\*" "$TargetAgySkill\"
        }
    }
    if (Test-Path "$SourceRoot\workflows") {
        Get-ChildItem "$SourceRoot\workflows\*.md" -File | ForEach-Object {
            $WfName = $_.BaseName
            $TargetWfSkill = Join-Path $AgySkillsDir $WfName
            New-Item -ItemType Directory -Force -Path $TargetWfSkill | Out-Null
            Copy-Item -Force $_.FullName (Join-Path $TargetWfSkill "SKILL.md")
        }
    }
    if (Test-Path "$SourceRoot\.agents\rules") {
        Copy-Item -Recurse -Force "$SourceRoot\.agents\rules\*" "$AgyRulesDir\"
    }
    if (Test-Path "$SourceRoot\plugins") {
        Copy-Item -Recurse -Force "$SourceRoot\plugins\*" "$AntigravityDir\plugins\"
    }
    Copy-Item -Force "$SourceRoot\gemini.md" "$GeminiDir\GEMINI.md"
    Copy-Item -Force "$SourceRoot\gemini.md" "$GeminiConfigDir\GEMINI.md"
    Write-Host "✅ AGY CLI skills & workflow slash commands installed to $AgySkillsDir" -ForegroundColor Green

    # Install Codex skills and merge only the managed Rig guidance block.
    Write-Host "🤖 Installing Codex adapter..." -ForegroundColor Cyan
    Get-ChildItem "$SourceRoot\skills" -Directory | ForEach-Object {
        $TargetSkill = Join-Path $CodexSkillsDir $_.Name
        New-Item -ItemType Directory -Force -Path $TargetSkill | Out-Null
        Copy-Item -Recurse -Force "$($_.FullName)\*" "$TargetSkill\"
    }

    $ManagedBlock = (Get-Content -Raw "$SourceRoot\codex\AGENTS.md").Trim()
    $CodexAgentsPath = Join-Path $CodexHome "AGENTS.md"
    $ManagedPattern = '(?s)<!-- RIG_CODEX:BEGIN -->.*?<!-- RIG_CODEX:END -->'
    if (Test-Path $CodexAgentsPath) {
        $ExistingAgents = Get-Content -Raw $CodexAgentsPath
        if ($ExistingAgents -match $ManagedPattern) {
            $UpdatedAgents = [regex]::Replace($ExistingAgents, $ManagedPattern, $ManagedBlock)
        } else {
            $UpdatedAgents = $ExistingAgents.TrimEnd() + "`r`n`r`n" + $ManagedBlock + "`r`n"
        }
    } else {
        $UpdatedAgents = $ManagedBlock + "`r`n"
    }
    Set-Content -Path $CodexAgentsPath -Value $UpdatedAgents -Encoding utf8
    Set-Content -Path (Join-Path $CodexHome "rig_version") -Value $Version
    Write-Host "✅ Codex skills installed to $CodexSkillsDir" -ForegroundColor Green
}

# ─── Download and extract repo (or use local repo) ───
Write-Host "📄 Installing core docs, workflows, skills, and plugins..."
$TmpDir = $null

try {
    if ($PSScriptRoot -and (Test-Path "$PSScriptRoot\core")) {
        $SourceRoot = $PSScriptRoot
    } else {
        $TmpDir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
        $ZipUrl = "https://github.com/$Repo/archive/refs/heads/main.zip"
        $ZipPath = "$TmpDir\rig.zip"
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
        Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force
        $SourceRoot = "$TmpDir\rig-main"
    }

    Install-RigFromRoot -SourceRoot $SourceRoot

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
        cargo build --release --manifest-path "$SourceRoot\cli\Cargo.toml"
        Copy-Item "$SourceRoot\cli\target\release\rig.exe" "$BinDir\rig.exe"
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

    if ($TmpDir -and (Test-Path $TmpDir)) {
        Remove-Item -Recurse -Force $TmpDir
    }
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
Write-Host "📁 AGY CLI:   $AgySkillsDir\ & $AgyRulesDir\"
Write-Host "   Core:      $AntigravityDir\core\"
Write-Host "   Workflows: $AntigravityDir\workflows\"
Write-Host "   Skills:    $AntigravityDir\skills\"
Write-Host "   Plugins:   $AntigravityDir\plugins\"
Write-Host "   Codex:     $CodexSkillsDir\"
Write-Host "   AGENTS.md: $CodexHome\AGENTS.md"
Write-Host ""
Write-Host "🎮 AGY CLI / Antigravity: type /init or `$rig-harness in AI chat"
Write-Host "   Codex: start a new task and invoke `$rig-harness"
Write-Host "   To update later, run: rig update"
