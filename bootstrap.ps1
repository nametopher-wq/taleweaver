Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$UpstreamUrl = "https://github.com/jschm42/taleweaver.git"
$OriginUrl = "https://github.com/nametopher-wq/taleweaver.git"
$IntegrationBranch = "local/integration"
$ScriptDir = $PSScriptRoot
$CommonDirInput = (& git rev-parse --git-common-dir).Trim()
if ($LASTEXITCODE -ne 0) {
    throw "Run this bootstrap from a TaleWeaver Git checkout."
}
$CommonDir = (Resolve-Path -LiteralPath $CommonDirInput).Path
$Root = Split-Path -Parent $CommonDir

function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)
    & git -C $Root @GitArgs
    if ($LASTEXITCODE -ne 0) {
        throw "git $($GitArgs -join ' ') failed."
    }
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "AGENTS.md"))) {
    throw "Run this bootstrap from a TaleWeaver code checkout."
}

$Dirty = & git -C $Root status --porcelain --untracked-files=no
if ($LASTEXITCODE -ne 0) {
    throw "Could not inspect the working tree."
}
if ($Dirty) {
    throw "Tracked changes found. Commit or move them before bootstrap."
}

$Remotes = @(& git -C $Root remote)
if ($Remotes -notcontains "origin") {
    throw "origin is missing. Clone the owner fork first."
}
$ActualOrigin = (& git -C $Root remote get-url origin).Trim()
if ($ActualOrigin -ne $OriginUrl -and $ActualOrigin -ne $OriginUrl.Replace(".git", "")) {
    throw "Unexpected origin URL: $ActualOrigin"
}

if ($Remotes -contains "upstream") {
    $ActualUpstream = (& git -C $Root remote get-url upstream).Trim()
    if ($ActualUpstream -ne $UpstreamUrl -and $ActualUpstream -ne $UpstreamUrl.Replace(".git", "")) {
        throw "Unexpected upstream URL: $ActualUpstream"
    }
} else {
    Invoke-Git remote add upstream $UpstreamUrl | Out-Host
}

Invoke-Git fetch upstream | Out-Host
Invoke-Git fetch origin | Out-Host

function Set-TrackingBranch {
    param([string]$Branch, [string]$RemoteRef)
    & git -C $Root show-ref --verify --quiet "refs/heads/$Branch"
    if ($LASTEXITCODE -eq 0) {
        Invoke-Git branch "--set-upstream-to=$RemoteRef" $Branch | Out-Host
        return
    }
    Invoke-Git branch --track $Branch $RemoteRef | Out-Host
}

Set-TrackingBranch main upstream/main
Set-TrackingBranch $IntegrationBranch origin/local/integration
& git -C $Root show-ref --verify --quiet refs/remotes/origin/local/meta
if ($LASTEXITCODE -eq 0) {
    Set-TrackingBranch local/meta origin/local/meta
}

$CurrentBranch = (& git -C $Root branch --show-current).Trim()
if ($CurrentBranch -ne $IntegrationBranch) {
    Invoke-Git switch $IntegrationBranch | Out-Host
}

$ExcludeFile = Join-Path $CommonDir "info/exclude"
function Add-Exclude {
    param([string]$Pattern)
    $Lines = @(Get-Content -LiteralPath $ExcludeFile)
    if ($Lines -notcontains $Pattern) {
        Add-Content -LiteralPath $ExcludeFile -Value $Pattern
    }
}

Add-Exclude "/AGENTS.local.md"
Add-Exclude "/HANDOFF.local.md"
Add-Exclude "/.local/"

function Copy-IfMissing {
    param([string]$Source, [string]$Destination)
    if (-not (Test-Path -LiteralPath $Destination)) {
        Copy-Item -LiteralPath $Source -Destination $Destination
        Write-Host "Created $Destination"
    }
}

Copy-IfMissing (Join-Path $ScriptDir "templates/AGENTS.local.md") (Join-Path $Root "AGENTS.local.md")
Copy-IfMissing (Join-Path $ScriptDir "templates/HANDOFF.local.md") (Join-Path $Root "HANDOFF.local.md")

Write-Host ""
Write-Host "Bootstrap complete."
Write-Host "Code branch: $(& git -C $Root branch --show-current)"
Write-Host "Next: install project dependencies, configure local secrets, and point your agent to AGENTS.local.md."
