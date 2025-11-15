
# install.ps1 - Windows installation script (PowerShell)
# Save this as a separate file named install.ps1

<# 
Write-Host "Installing dotfiles for Windows..." -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator to create symbolic links." -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator', then run this script again." -ForegroundColor Yellow
    exit 1
}

# Backup existing configs
$backupDir = "$HOME\dotfiles_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Write-Host "Creating backup at $backupDir"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

$nvimPath = "$env:LOCALAPPDATA\nvim"
$weztermPath = "$HOME\.wezterm.lua"

if (Test-Path $nvimPath) {
    Write-Host "Backing up existing nvim config..."
    Move-Item -Path $nvimPath -Destination $backupDir -Force
}

if (Test-Path $weztermPath) {
    Write-Host "Backing up existing wezterm config..."
    Move-Item -Path $weztermPath -Destination $backupDir -Force
}

# Create symlinks
Write-Host "Creating symbolic links..."
New-Item -ItemType SymbolicLink -Path $nvimPath -Target "$HOME\dotfiles\nvim" -Force | Out-Null
New-Item -ItemType SymbolicLink -Path $weztermPath -Target "$HOME\dotfiles\wezterm\wezterm.lua" -Force | Out-Null

Write-Host "✓ Dotfiles installed successfully!" -ForegroundColor Green
Write-Host "Backup saved at: $backupDir"
Write-Host ""
Write-Host "Note: You may need to install plugins/LSPs separately."
Write-Host "For LazyVim, open nvim and plugins should install automatically."
#>