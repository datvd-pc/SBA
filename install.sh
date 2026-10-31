#!/bin/sh
set -eu
REPO_RAW='https://raw.githubusercontent.com/datvd-pc/SBA/main'

if [ "${OPENCLAW_PROFILE:-default}" = default ]; then
  WORKSPACE="$HOME/.openclaw/workspace"
else
  WORKSPACE="$HOME/.openclaw-${OPENCLAW_PROFILE}/workspace"
fi

if ! command -v openclaw >/dev/null 2>&1; then
  printf '%s\n' 'Installing OpenClaw from the official installer...'
  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' EXIT HUP INT TERM
  curl -fsSL 'https://openclaw.ai/install.sh' -o "$tmp"
  bash "$tmp" --no-onboard
fi

command -v openclaw >/dev/null 2>&1 || {
  printf '%s\n' 'OpenClaw is not on PATH. Open a new terminal and run this installer again.' >&2
  exit 1
}

if [ "${SKIP_ONBOARDING:-0}" != 1 ]; then
  printf '%s\n' 'Choose the AI provider and chat channel in the setup wizard.'
  openclaw onboard --install-daemon
fi

mkdir -p "$WORKSPACE"
if [ ! -f "$WORKSPACE/COMPANY_PROFILE.md" ]; then
  curl -fsSL "$REPO_RAW/COMPANY_PROFILE.example.md" -o "$WORKSPACE/COMPANY_PROFILE.md"
  printf 'Created %s\n' "$WORKSPACE/COMPANY_PROFILE.md"
else
  printf 'Kept existing %s\n' "$WORKSPACE/COMPANY_PROFILE.md"
fi

if [ ! -f "$WORKSPACE/AGENTS.md" ]; then
  printf '# Business assistant workspace\n' > "$WORKSPACE/AGENTS.md"
fi
if ! grep -q 'solo-business-assistant:start' "$WORKSPACE/AGENTS.md"; then
  cat >> "$WORKSPACE/AGENTS.md" <<'EOF'

<!-- solo-business-assistant:start -->
## Business assistant rules
- Before business planning, sales, customer-care, marketing, supplier, or scheduling work, read `COMPANY_PROFILE.md` when it exists.
- Treat the profile as context, not as permission to contact customers or publish anything.
- Ask for missing facts instead of inventing prices, promises, stock, balances, dates, or customer history.
- Draft messages and public posts for review. Do not send, publish, confirm a meeting, or make financial/legal commitments without explicit approval.
- For reminders, state task, due time, contact, and next step. Confirm ambiguous dates and time zones before creating calendar events.
<!-- solo-business-assistant:end -->
EOF
fi

printf '\n%s\n' 'Setup complete. Fill in COMPANY_PROFILE.md, then message your assistant.'

