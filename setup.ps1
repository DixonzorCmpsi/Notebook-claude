# setup.ps1 — YouTube Research + NotebookLM workflow for Claude Code
# Run once after cloning: .\setup.ps1
# If blocked by execution policy: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

$ErrorActionPreference = "Stop"

function Ok($msg)   { Write-Host "[OK]   $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Info($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Fail($msg) { Write-Host "[FAIL] $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "YouTube Research + NotebookLM — Setup" -ForegroundColor White
Write-Host "======================================" -ForegroundColor White
Write-Host ""

# ── 1. Prerequisites ──────────────────────────────────────────────────────────
Info "Checking prerequisites..."

# Node.js 18+
try {
  $nodeVersion = (node --version 2>$null).TrimStart('v')
  $nodeMajor = [int]($nodeVersion.Split('.')[0])
  if ($nodeMajor -ge 18) {
    Ok "Node.js v$nodeVersion"
  } else {
    Fail "Node.js 18+ required (found v$nodeVersion). Install at https://nodejs.org"
  }
} catch {
  Fail "Node.js not found. Install at https://nodejs.org"
}

# Python 3.9+
$pythonCmd = $null
foreach ($cmd in @("python", "python3")) {
  try {
    $pyVer = & $cmd -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>$null
    $parts = $pyVer.Split('.')
    if ([int]$parts[0] -ge 3 -and [int]$parts[1] -ge 9) {
      $pythonCmd = $cmd
      Ok "Python $pyVer"
      break
    }
  } catch { continue }
}
if (-not $pythonCmd) {
  Fail "Python 3.9+ required. Install at https://python.org"
}

# Claude Code (warn only)
try {
  $claudeVer = claude --version 2>$null | Select-Object -First 1
  Ok "Claude Code $claudeVer"
} catch {
  Warn "Claude Code not found — install at https://claude.ai/download, then re-run"
}

Write-Host ""

# ── 2. Python packages ────────────────────────────────────────────────────────
Info "Installing Python packages..."

# Find pip
$pipCmd = $null
foreach ($cmd in @("pip", "pip3")) {
  if (Get-Command $cmd -ErrorAction SilentlyContinue) { $pipCmd = $cmd; break }
}
if (-not $pipCmd) { $pipCmd = "$pythonCmd -m pip" }

try {
  & $pipCmd.Split()[0] ($pipCmd.Split()[1..99] + @("install", "notebooklm-py[browser]", "--quiet"))
  Ok "notebooklm-py installed"
} catch {
  # Try python -m pip as fallback
  & $pythonCmd -m pip install "notebooklm-py[browser]" --quiet
  Ok "notebooklm-py installed"
}

try {
  & $pipCmd.Split()[0] ($pipCmd.Split()[1..99] + @("install", "yt-dlp", "--quiet"))
  Ok "yt-dlp installed"
} catch {
  & $pythonCmd -m pip install "yt-dlp" --quiet
  Ok "yt-dlp installed"
}

try {
  playwright install chromium 2>$null
  Ok "Playwright Chromium installed"
} catch {
  Warn "playwright install chromium failed — try running it manually"
}

Write-Host ""

# ── 3. Install yt-search skill ────────────────────────────────────────────────
Info "Installing yt-search skill..."

$ytSkillDir = Join-Path $env:USERPROFILE ".claude\skills\yt-search\scripts"
New-Item -ItemType Directory -Force -Path $ytSkillDir | Out-Null
Copy-Item "skills\yt-search\SKILL.md" (Join-Path $env:USERPROFILE ".claude\skills\yt-search\SKILL.md") -Force
Copy-Item "skills\yt-search\scripts\yt_search.py" (Join-Path $ytSkillDir "yt_search.py") -Force
Copy-Item "skills\yt-search\scripts\tapi-auth.js" (Join-Path $ytSkillDir "tapi-auth.js") -Force
Ok "yt-search skill -> $env:USERPROFILE\.claude\skills\yt-search"

Write-Host ""

# ── 4. Install notebooklm skill ───────────────────────────────────────────────
Info "Installing notebooklm skill..."

# notebooklm may not be on PATH yet after pip install — find it
$notebooklmExe = (Get-Command notebooklm -ErrorAction SilentlyContinue)?.Source
if (-not $notebooklmExe) {
  # Common Windows locations
  foreach ($candidate in @(
    "$env:APPDATA\Python\Scripts\notebooklm.exe",
    "$env:LOCALAPPDATA\Programs\Python\Python311\Scripts\notebooklm.exe",
    "$env:LOCALAPPDATA\Packages\PythonSoftwareFoundation.Python.3.11_qbz5n2kfra8p0\LocalCache\local-packages\Python311\Scripts\notebooklm.exe"
  )) {
    if (Test-Path $candidate) { $notebooklmExe = $candidate; break }
  }
}

$skillInstalled = $false
if ($notebooklmExe) {
  try {
    & $notebooklmExe skill install 2>$null
    Ok "notebooklm skill installed (via notebooklm-py)"
    $skillInstalled = $true
  } catch { }
}

if (-not $skillInstalled) {
  Warn "notebooklm skill install failed — falling back to bundled snapshot"
  $nlmDir = Join-Path $env:USERPROFILE ".claude\skills\notebooklm"
  New-Item -ItemType Directory -Force -Path $nlmDir | Out-Null
  Copy-Item "skills\notebooklm\SKILL.md" (Join-Path $nlmDir "SKILL.md") -Force
  Ok "notebooklm skill -> $nlmDir (snapshot)"
  Warn "Run 'notebooklm skill install' again after restarting your terminal"
}

Write-Host ""

# ── 5. Project config ─────────────────────────────────────────────────────────
Info "Setting up project config..."

$config   = ".claude\settings.local.json"
$template = ".claude\settings.local.json.template"

if (-not (Test-Path $config)) {
  Copy-Item $template $config
  Ok "Created $config from template"
} else {
  Ok "$config already exists — skipping (delete it to reset)"
}

Write-Host ""

# ── 6. Done ───────────────────────────────────────────────────────────────────
Write-Host "Setup complete. Two manual steps remaining:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Authenticate with NotebookLM (opens browser):"
Write-Host "     notebooklm login"
Write-Host ""
Write-Host "  2. Open Claude Code in this folder:"
Write-Host "     claude"
Write-Host ""
Write-Host "  Your TRANSCRIPT_API_KEY for yt-search will be set automatically"
Write-Host "  on first use — the skill will prompt you for your email."
Write-Host ""
Write-Host "  See prompts/ for ready-to-use workflow prompts."
Write-Host ""
