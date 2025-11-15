#!/bin/bash
# install.sh - Linux installation script

set -e

echo "Installing dotfiles for Linux..."

# Backup existing configs
backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
echo "Creating backup at $backup_dir"

mkdir -p "$backup_dir"

if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing nvim config..."
    mv "$HOME/.config/nvim" "$backup_dir/"
fi

if [ -f "$HOME/.wezterm.lua" ]; then
    echo "Backing up existing wezterm config..."
    mv "$HOME/.wezterm.lua" "$backup_dir/"
fi

if [ -d "$HOME/.config/wezterm" ]; then
    echo "Backing up existing wezterm config folder..."
    mv "$HOME/.config/wezterm" "$backup_dir/"
fi

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Create symlinks
echo "Creating symlinks..."
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
ln -sf "$HOME/dotfiles/wezterm/wezterm.lua" "$HOME/.wezterm.lua"

echo "✓ Dotfiles installed successfully!"
echo "Backup saved at: $backup_dir"
echo ""
echo "Note: You may need to install plugins/LSPs separately."
echo "For LazyVim, open nvim and plugins should install automatically."
