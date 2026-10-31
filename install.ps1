param([switch]$SkipOnboarding)
$ErrorActionPreference = 'Stop'
$RepoRaw = 'https://raw.githubusercontent.com/datvd-pc/SBA/main'

try {
    if (-not (Get-Command openclaw -ErrorAction SilentlyContinue)) {
        Write-Host 'Installing OpenClaw from the official installer...'
        $source = Invoke-RestMethod -Uri 'https://openclaw.ai/install.ps1'
        & ([scriptblock]::Create($source)) -NoOnboard
    } else {
        Write-Host 'OpenClaw is already installed; its version will not be changed.'
    }
    if (-not (Get-Command openclaw -ErrorAction SilentlyContinue)) {
        throw 'OpenClaw is not on PATH. Reopen PowerShell and run this installer again.'
    }
    if (-not $SkipOnboarding) {
        Write-Host 'Choose the AI provider and chat channel in the setup wizard.'
        & openclaw onboard --install-daemon
        if ($LASTEXITCODE -ne 0) { throw "Onboarding exited with code $LASTEXITCODE." }
    }
    if ($env:OPENCLAW_PROFILE -and $env:OPENCLAW_PROFILE -ne 'default') {
        $workspace = Join-Path $env:USERPROFILE ".openclaw-$($env:OPENCLAW_PROFILE)\workspace"
    } else {
        $workspace = Join-Path $env:USERPROFILE '.openclaw\workspace'
    }
    New-Item -ItemType Directory -Path $workspace -Force | Out-Null
    $profile = Join-Path $workspace 'COMPANY_PROFILE.md'
    if (-not (Test-Path -LiteralPath $profile)) {
        Invoke-WebRequest -Uri "$RepoRaw/COMPANY_PROFILE.example.md" -OutFile $profile
        Write-Host "Created $profile"
    } else { Write-Host "Kept existing $profile" }
    $agents = Join-Path $workspace 'AGENTS.md'
    if (-not (Test-Path -LiteralPath $agents)) { Set-Content -LiteralPath $agents -Encoding utf8 -Value '# Business assistant workspace' }
    $text = Get-Content -LiteralPath $agents -Raw
    if (-not $text.Contains('solo-business-assistant:start')) {
        Add-Content -LiteralPath $agents -Encoding utf8 -Value @"

<!-- solo-business-assistant:start -->
## Business assistant rules
- Before business planning, sales, customer-care, marketing, supplier, or scheduling work, read `COMPANY_PROFILE.md` when it exists.
- Treat the profile as context, not as permission to contact customers or publish anything.
- Ask for missing facts instead of inventing prices, promises, stock, balances, dates, or customer history.
- Draft messages and public posts for review. Do not send, publish, confirm a meeting, or make financial/legal commitments without explicit approval.
- For reminders, state task, due time, contact, and next step. Confirm ambiguous dates and time zones before creating calendar events.
<!-- solo-business-assistant:end -->
"@
    }
    Write-Host 'Setup complete. Fill in COMPANY_PROFILE.md, then message your assistant.'
} catch {
    Write-Error $_
    exit 1
}

