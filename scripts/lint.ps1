# Phase 9 - Run all linters locally
# Mirrors the CI workflow

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "=== Running All Linters ===" -ForegroundColor Cyan

$failed = $false

# Flutter analyze
Write-Host "`n[Flutter] Analyzing..." -ForegroundColor Yellow
Push-Location "$root\apps\mobile_app"
flutter analyze
if ($LASTEXITCODE -ne 0) { $failed = $true }
Pop-Location

# Backend lint
Write-Host "`n[Backend] Linting..." -ForegroundColor Yellow
Push-Location "$root\services\backend_api"
npm run lint
if ($LASTEXITCODE -ne 0) { $failed = $true }
Pop-Location

Write-Host "`n=== Lint Complete ===" -ForegroundColor Cyan
if ($failed) {
    Write-Host "Lint issues found!" -ForegroundColor Red
    exit 1
} else {
    Write-Host "All clean!" -ForegroundColor Green
}
