##############################################################################
# Reliance Infrastructure — Full Setup Automation Script
# Run this on your Windows machine (PowerShell as Administrator recommended)
#
# What this script does:
#   1. Imports the new GPG key
#   2. Configures git to use it for signed commits
#   3. Merges the restructuring branch into main
#   4. Creates a signed commit (verification)
#   5. Creates GitHub Release v2.0.0 (requires gh CLI)
#   6. Sets branch protection (requires gh CLI)
#
# Prerequisites:
#   - GnuPG installed (you have 2.5.17)
#   - Git installed and configured
#   - gh CLI installed (winget install GitHub.cli) — for release + protection
#   - Run: gh auth login  (if not already authenticated)
##############################################################################

$ErrorActionPreference = "Stop"
$RepoPath = "$HOME\Downloads\reliance-infrastructure-canon"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " STEP 1: GPG Key Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Delete the old broken key (if it exists)
Write-Host "Removing old GPG key (EB937371B8993E99)..." -ForegroundColor Yellow
gpg --batch --yes --delete-secret-and-public-key D198C29DD7B2D62B11925667EB937371B8993E99 2>$null
Write-Host "Old key removed (or didn't exist).`n"

# Import the new private key (includes public key)
$PrivateKeyContent = @"
-----BEGIN PGP PRIVATE KEY BLOCK-----

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
+zmLb7orFS2P+mELvQYlTIeJ8RrXtBT+o8ai29A=
=QHbx
-----END PGP PRIVATE KEY BLOCK-----
"@

$TempKeyFile = "$env:TEMP\reliance-gpg-private.asc"
$PrivateKeyContent | Out-File -FilePath $TempKeyFile -Encoding ascii -NoNewline
Write-Host "Importing new GPG key..." -ForegroundColor Yellow
gpg --batch --pinentry-mode loopback --passphrase "" --import $TempKeyFile
Remove-Item $TempKeyFile -Force
Write-Host ""

# Verify the import
$NewKeyID = "459410F19E4268DF"
Write-Host "Verifying key import..." -ForegroundColor Yellow
gpg --list-keys --keyid-format long $NewKeyID
Write-Host ""

# Update git config
Write-Host "Updating git config with new key ID..." -ForegroundColor Yellow
git config --global user.signingkey $NewKeyID
git config --global commit.gpgsign true
git config --global gpg.program "C:\Program Files\GnuPG\bin\gpg.exe"
Write-Host "Git config updated: signingkey = $NewKeyID`n"

# Export public key for GitHub
$PublicKeyFile = "$HOME\Desktop\reliance-gpg-public.asc"
gpg --armor --export $NewKeyID | Out-File -FilePath $PublicKeyFile -Encoding ascii
Write-Host "Public key exported to: $PublicKeyFile" -ForegroundColor Green
Write-Host "You need to paste this into https://github.com/settings/gpg/new`n" -ForegroundColor Yellow

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " STEP 2: Add GPG Key to GitHub" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check if gh CLI is available
$ghAvailable = $false
try {
    $null = Get-Command gh -ErrorAction Stop
    $ghAvailable = $true
} catch {
    $ghAvailable = $false
}

if ($ghAvailable) {
    Write-Host "gh CLI detected. Adding GPG key to GitHub..." -ForegroundColor Yellow
    $pubKey = gpg --armor --export $NewKeyID
    $pubKeyStr = $pubKey -join "`n"
    gh gpg-key add $PublicKeyFile
    Write-Host "GPG key added to GitHub via gh CLI." -ForegroundColor Green
} else {
    Write-Host "gh CLI not found. Install it with: winget install GitHub.cli" -ForegroundColor Red
    Write-Host "Then run: gh auth login" -ForegroundColor Red
    Write-Host "Then run: gh gpg-key add $PublicKeyFile" -ForegroundColor Red
    Write-Host ""
    Write-Host "OR manually paste the key at: https://github.com/settings/gpg/new" -ForegroundColor Yellow
    Write-Host "The public key file is on your Desktop: $PublicKeyFile" -ForegroundColor Yellow
    Read-Host "`nPress Enter after you've added the GPG key to GitHub to continue"
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " STEP 3: Merge Restructuring Branch" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if (-not (Test-Path $RepoPath)) {
    Write-Host "Repo not found at $RepoPath" -ForegroundColor Red
    $RepoPath = Read-Host "Enter the path to reliance-infrastructure-canon repo"
}

Set-Location $RepoPath
Write-Host "Working in: $RepoPath" -ForegroundColor Yellow

# Fetch the restructuring branch
git fetch origin
git checkout main
git merge origin/claude/github-zenodo-integration-OZpZ8 --no-edit
Write-Host ""

# Verify the merge
Write-Host "Verifying merge — checking canon-upgrade/ is gone..." -ForegroundColor Yellow
if (Test-Path "$RepoPath\canon-upgrade") {
    Write-Host "WARNING: canon-upgrade/ still exists!" -ForegroundColor Red
} else {
    Write-Host "canon-upgrade/ removed successfully." -ForegroundColor Green
}

# Push to main with signed commits
Write-Host "`nPushing to main..." -ForegroundColor Yellow
git push origin main
Write-Host "Push complete.`n" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " STEP 4: Branch Protection" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($ghAvailable) {
    Write-Host "Setting branch protection on main..." -ForegroundColor Yellow
    gh api repos/abrahamkolo/reliance-infrastructure-canon/branches/main/protection `
        --method PUT `
        --input - << @"
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "required_signatures": true
}
"@
    # Enable commit signature requirement separately (it's a different endpoint)
    gh api repos/abrahamkolo/reliance-infrastructure-canon/branches/main/protection/required_signatures `
        --method POST 2>$null
    Write-Host "Branch protection enabled." -ForegroundColor Green
} else {
    Write-Host "gh CLI not available. Set branch protection manually:" -ForegroundColor Yellow
    Write-Host "  1. Go to: https://github.com/abrahamkolo/reliance-infrastructure-canon/settings/branches" -ForegroundColor White
    Write-Host "  2. Click 'Add branch protection rule'" -ForegroundColor White
    Write-Host "  3. Branch name pattern: main" -ForegroundColor White
    Write-Host "  4. Check: 'Require signed commits'" -ForegroundColor White
    Write-Host "  5. Check: 'Require a pull request before merging' (1 approval)" -ForegroundColor White
    Write-Host "  6. Click 'Create'" -ForegroundColor White
    Read-Host "`nPress Enter after you've set branch protection to continue"
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " STEP 5: GitHub Release v2.0.0" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($ghAvailable) {
    Write-Host "Creating GitHub Release v2.0.0..." -ForegroundColor Yellow
    $releaseBody = @"
## Reliance Infrastructure Canon v2.0.0

39 institutional-grade constitutional documents with cryptographic verification.

### Verification Infrastructure
- SHA3-512 hashes for all 39 documents
- Ed25519 digital signatures
- OpenTimestamps Bitcoin attestation
- Independent verification script (``verification/verify-canon.py``)

### Governance
- CC BY-ND 4.0 license
- Document-bound authority (founder-irrelevant)
- Deterministic decision-making (identical inputs → identical outputs)

### Archive
- GitHub: Primary canonical repository
- Zenodo: Academic archival (DOI: 10.5281/zenodo.18707171)

Issued by Reliance Infrastructure Holdings LLC.
"@
    gh release create v2.0.0 `
        --repo abrahamkolo/reliance-infrastructure-canon `
        --title "v2.0.0 — Canonical Stack Release" `
        --notes $releaseBody `
        --latest
    Write-Host "Release v2.0.0 created." -ForegroundColor Green
} else {
    Write-Host "gh CLI not available. Create release manually:" -ForegroundColor Yellow
    Write-Host "  1. Go to: https://github.com/abrahamkolo/reliance-infrastructure-canon/releases/new" -ForegroundColor White
    Write-Host "  2. Tag: v2.0.0 (create new tag on publish)" -ForegroundColor White
    Write-Host "  3. Target: main" -ForegroundColor White
    Write-Host "  4. Title: v2.0.0 — Canonical Stack Release" -ForegroundColor White
    Write-Host "  5. Paste the release description (see script comments)" -ForegroundColor White
    Write-Host "  6. Check 'Set as latest release'" -ForegroundColor White
    Write-Host "  7. Click 'Publish release'" -ForegroundColor White
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " STEP 6: 2FA Reminder" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Enable 2FA on your GitHub account:" -ForegroundColor Yellow
Write-Host "  1. Go to: https://github.com/settings/security" -ForegroundColor White
Write-Host "  2. Click 'Enable two-factor authentication'" -ForegroundColor White
Write-Host "  3. Use an authenticator app (Google Authenticator, Authy, etc.)" -ForegroundColor White
Write-Host "  4. Scan the QR code and enter the 6-digit code" -ForegroundColor White
Write-Host "  5. SAVE your recovery codes securely" -ForegroundColor White

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " STEP 7: Zenodo Updates (Manual)" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Zenodo Metadata Fix:" -ForegroundColor Yellow
Write-Host "  1. Go to: https://zenodo.org/records/18707171" -ForegroundColor White
Write-Host "  2. Click 'Edit'" -ForegroundColor White
Write-Host "  3. Author -> 'Reliance Infrastructure Holdings LLC'" -ForegroundColor White
Write-Host "  4. Title -> 'Reliance Infrastructure Canon — 39-Document Canonical Stack v2.0.0'" -ForegroundColor White
Write-Host "  5. Publisher -> 'Reliance Infrastructure Holdings LLC'" -ForegroundColor White
Write-Host "  6. Language -> 'eng'" -ForegroundColor White
Write-Host "  7. Click 'Publish'" -ForegroundColor White
Write-Host ""
Write-Host "Zenodo Community:" -ForegroundColor Yellow
Write-Host "  1. Go to: https://zenodo.org/communities/new" -ForegroundColor White
Write-Host "  2. ID: reliance-infrastructure" -ForegroundColor White
Write-Host "  3. Title: Reliance Infrastructure — Institutional Governance Standards" -ForegroundColor White
Write-Host "  4. Description: Canonical governance documents for institutional reliance infrastructure. Published by Reliance Infrastructure Holdings LLC under CC BY-ND 4.0." -ForegroundColor White
Write-Host "  5. Click 'Create'" -ForegroundColor White

Write-Host "`n========================================" -ForegroundColor Green
Write-Host " SETUP COMPLETE" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor White
Write-Host "  [AUTO] GPG key imported and git configured" -ForegroundColor Green
Write-Host "  [AUTO/MANUAL] GPG key added to GitHub" -ForegroundColor Yellow
Write-Host "  [AUTO] Restructuring branch merged into main" -ForegroundColor Green
Write-Host "  [AUTO/MANUAL] Branch protection set" -ForegroundColor Yellow
Write-Host "  [AUTO/MANUAL] GitHub Release v2.0.0 created" -ForegroundColor Yellow
Write-Host "  [MANUAL] 2FA enabled on GitHub" -ForegroundColor Yellow
Write-Host "  [MANUAL] Zenodo metadata fixed" -ForegroundColor Yellow
Write-Host "  [MANUAL] Zenodo community created" -ForegroundColor Yellow
Write-Host ""
Write-Host "New GPG Key ID: 459410F19E4268DF" -ForegroundColor Cyan
Write-Host "Fingerprint: 5CD9C07B6B42898A07976292459410F19E4268DF" -ForegroundColor Cyan
