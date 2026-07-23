# Phase 9 - Local Setup Script
# Run once after cloning the repository

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "=== EcoHabbit Setup ===" -ForegroundColor Cyan

# Flutter
Write-Host "`nInstalling Flutter dependencies..." -ForegroundColor Yellow
Push-Location "$root\apps\mobile_app"
flutter pub get
Pop-Location

# Backend
Write-Host "`nInstalling Backend dependencies..." -ForegroundColor Yellow
Push-Location "$root\services\backend_api"
npm ci
Pop-Location

# AI Service
Write-Host "`nInstalling AI Service dependencies..." -ForegroundColor Yellow
Push-Location "$root\services\ai_service"
python -m pip install --upgrade pip
pip install -r requirements.txt
Pop-Location

Write-Host "`n=== Setup complete ===" -ForegroundColor Green
