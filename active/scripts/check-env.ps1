# Verifies required env vars in .env are set. Prints names only, never values.
param([string]$EnvFile = (Join-Path $PSScriptRoot '..\..\.env'))
$required = (Get-Content (Join-Path $PSScriptRoot '..\..\.env.example') |
  Where-Object { $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*=' } |
  ForEach-Object { ($_ -split '=')[0].Trim() })
if (-not (Test-Path $EnvFile)) { Write-Error ".env not found"; exit 1 }
$set = @{}
Get-Content $EnvFile | ForEach-Object {
  if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.+)$') { $set[$Matches[1]] = $true }
}
$missing = $required | Where-Object { -not $set.ContainsKey($_) }
if ($missing) { Write-Error ("Missing: " + ($missing -join ', ')); exit 1 }
Write-Output "All required variables are set."
