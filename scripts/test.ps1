# Phase 9 - Run all tests locally
# Mirrors the CI workflow

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "=== Running All Tests ===" -ForegroundColor Cyan

$failed = $false

# Flutter tests
Write-Host "`n[Flutter] Running tests..." -ForegroundColor Yellow
Push-Location "$root\apps\mobile_app"
flutter test
if ($LASTEXITCODE -ne 0) { $failed = $true }
Pop-Location

# Backend tests
Write-Host "`n[Backend] Running tests..." -ForegroundColor Yellow
Push-Location "$root\services\backend_api"
npm test
if ($LASTEXITCODE -ne 0) { $failed = $true }
Pop-Location

# AI Service tests
Write-Host "`n[AI Service] Running tests..." -ForegroundColor Yellow
Push-Location "$root\services\ai_service"
pytest tests/ -v
if ($LASTEXITCODE -ne 0) { $failed = $true }
Pop-Location

Write-Host "`n=== Tests Complete ===" -ForegroundColor Cyan
if ($failed) {
    Write-Host "Some tests failed!" -ForegroundColor Red
    exit 1
} else {
    Write-Host "All tests passed!" -ForegroundColor Green
}
