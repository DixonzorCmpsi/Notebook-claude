#!/usr/bin/env bash
# setup.sh — YouTube Research + NotebookLM workflow for Claude Code
# Run once after cloning: bash setup.sh

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

ok()   { echo -e "${GREEN}[OK]${RESET}   $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
info() { echo -e "${BOLD}==> $1${RESET}"; }
fail() { echo -e "${RED}[FAIL]${RESET} $1"; exit 1; }

echo ""
echo -e "${BOLD}YouTube Research + NotebookLM — Setup${RESET}"
echo "======================================"
echo ""

# ── 1. Prerequisites ──────────────────────────────────────────────────────────
info "Checking prerequisites..."

# Node.js 18+
if command -v node &>/dev/null; then
  NODE_MAJOR=$(node --version | sed 's/v//' | cut -d. -f1)
  if [ "$NODE_MAJOR" -ge 18 ]; then
    ok "Node.js $(node --version)"
  else
    fail "Node.js 18+ required (found $(node --version)). Install at https://nodejs.org"
  fi
else
  fail "Node.js not found. Install at https://nodejs.org"
fi

# Python 3.9+
PYTHON=""
for cmd in python3 python; do
  if command -v "$cmd" &>/dev/null; then
    PY_MINOR=$("$cmd" -c "import sys; print(sys.version_info.minor)" 2>/dev/null || echo 0)
    PY_MAJOR=$("$cmd" -c "import sys; print(sys.version_info.major)" 2>/dev/null || echo 0)
    if [ "$PY_MAJOR" -ge 3 ] && [ "$PY_MINOR" -ge 9 ]; then
      PYTHON="$cmd"
      ok "Python $($cmd --version)"
      break
    fi
  fi
done
[ -z "$PYTHON" ] && fail "Python 3.9+ required. Install at https://python.org"

# Claude Code (warn only, don't fail)
if command -v claude &>/dev/null; then
  ok "Claude Code $(claude --version 2>/dev/null | head -1)"
else
  warn "Claude Code not found — install at https://claude.ai/download, then re-run this script"
fi

echo ""

# ── 2. Python packages ────────────────────────────────────────────────────────
info "Installing Python packages..."

PIP=""
for cmd in pip3 pip; do
  command -v "$cmd" &>/dev/null && PIP="$cmd" && break
done
[ -z "$PIP" ] && PIP="$PYTHON -m pip"

$PIP install "notebooklm-py[browser]" --quiet && ok "notebooklm-py installed"
$PIP install yt-dlp --quiet && ok "yt-dlp installed"
playwright install chromium --quiet 2>/dev/null && ok "Playwright Chromium installed"

echo ""

# ── 3. Install yt-search skill ────────────────────────────────────────────────
info "Installing yt-search skill..."

YT_SKILL_DIR="$HOME/.claude/skills/yt-search"
mkdir -p "$YT_SKILL_DIR/scripts"
cp skills/yt-search/SKILL.md "$YT_SKILL_DIR/SKILL.md"
cp skills/yt-search/scripts/yt_search.py "$YT_SKILL_DIR/scripts/yt_search.py"
cp skills/yt-search/scripts/tapi-auth.js "$YT_SKILL_DIR/scripts/tapi-auth.js"
ok "yt-search skill → $YT_SKILL_DIR"

echo ""

# ── 4. Install notebooklm skill ───────────────────────────────────────────────
info "Installing notebooklm skill..."

if notebooklm skill install 2>/dev/null; then
  ok "notebooklm skill installed (via notebooklm-py)"
else
  warn "notebooklm skill install failed — falling back to bundled snapshot"
  mkdir -p "$HOME/.claude/skills/notebooklm"
  cp skills/notebooklm/SKILL.md "$HOME/.claude/skills/notebooklm/SKILL.md"
  ok "notebooklm skill → $HOME/.claude/skills/notebooklm (snapshot)"
  warn "Run 'notebooklm skill install' again after restarting your terminal"
fi

echo ""

# ── 5. Project config ─────────────────────────────────────────────────────────
info "Setting up project config..."

CONFIG=".claude/settings.local.json"
TEMPLATE=".claude/settings.local.json.template"

if [ ! -f "$CONFIG" ]; then
  cp "$TEMPLATE" "$CONFIG"
  ok "Created $CONFIG from template"
else
  ok "$CONFIG already exists — skipping (delete it to reset)"
fi

echo ""

# ── 6. Done ───────────────────────────────────────────────────────────────────
echo -e "${BOLD}Setup complete. Two manual steps remaining:${RESET}"
echo ""
echo "  1. Authenticate with NotebookLM (opens browser):"
echo "     notebooklm login"
echo ""
echo "  2. Open Claude Code in this folder:"
echo "     claude"
echo ""
echo "  Your TRANSCRIPT_API_KEY for yt-search will be set automatically"
echo "  on first use — the skill will prompt you for your email."
echo ""
echo "  See prompts/ for ready-to-use workflow prompts."
echo ""
