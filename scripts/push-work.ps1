#Requires -Version 5.1
<#
.SYNOPSIS
  Stage, commit, and push changes using the configured git remote (no URL in this script).
.PARAMETER Message
  Commit message (required).
.PARAMETER Path
  Optional file or directory paths to stage. Default: all changes (git add -A).
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Message,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Path
)

function Write-Err([string]$text) {
    Write-Error $text
    exit 1
}

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $repoRoot '.git'))) {
    Write-Err 'Not a git repository (run from project that contains .git)'
}
Set-Location $repoRoot

$envFile = Join-Path $repoRoot 'local.git.env'
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -match '^\s*#' -or [string]::IsNullOrWhiteSpace($line)) { return }
        if ($line -match '^REMOTE_URL=(.+)$') {
            $url = $Matches[1].Trim().Trim('"').Trim("'")
            if ($url) {
                git remote set-url origin $url 2>$null
                if ($LASTEXITCODE -ne 0) {
                    git remote add origin $url 2>$null
                }
                if ($LASTEXITCODE -ne 0) {
                    Write-Err 'Could not configure remote from local.git.env'
                }
            }
        }
    }
}

if ($Path -and $Path.Count -gt 0) {
    git add @Path
} else {
    git add -A
}
if ($LASTEXITCODE -ne 0) { Write-Err 'git add failed' }

$status = git status --porcelain
if (-not $status) {
    Write-Host 'Nothing to commit.'
    exit 0
}

git commit -m $Message
if ($LASTEXITCODE -ne 0) { Write-Err 'git commit failed' }

$branch = git rev-parse --abbrev-ref HEAD
if ($LASTEXITCODE -ne 0) { Write-Err 'Could not determine current branch' }

$prevEap = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
git push origin $branch 2>&1 | ForEach-Object {
    $line = "$_"
    if ($line -match 'https?://|@[\w.-]+:') {
        'push output suppressed (remote details hidden)'
    } else {
        $line
    }
}
$pushExit = $LASTEXITCODE
$ErrorActionPreference = $prevEap
if ($pushExit -ne 0) { Write-Err 'git push failed' }

Write-Host "Committed and pushed on branch: $branch"
