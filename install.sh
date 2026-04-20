#!/bin/bash
# install.sh

set -e

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"

echo "==> Installing packages..."
sudo pacman -S --needed - < "$DOTFILES/pkglist.txt"

echo "==> Copying configs..."
dirs=(hypr waybar wofi rofi kitty alacritty dunst mako btop mpv nvim gtk-3.0 gtk-4.0 hyprlock hypridle fish zellij starship.toml)

for dir in "${dirs[@]}"; do
    if [ -e "$DOTFILES/$dir" ]; then
        cp -r "$DOTFILES/$dir" "$CONFIG/"
        echo "  Copied $dir"
    fi
done

# Shell files
[ -f "$DOTFILES/.zshrc" ] && cp "$DOTFILES/.zshrc" ~/
[ -f "$DOTFILES/.bashrc" ] && cp "$DOTFILES/.bashrc" ~/

# Fonts & themes
[ -d "$DOTFILES/fonts" ] && cp -r "$DOTFILES/fonts" ~/.local/share/
[ -d "$DOTFILES/.themes" ] && cp -r "$DOTFILES/.themes" ~/
[ -d "$DOTFILES/.icons" ] && cp -r "$DOTFILES/.icons" ~/

echo "==> Updating font cache..."
fc-cache -fv

echo ""
echo "✅ Done! Please edit ~/.config/hypr/hyprland.conf to set your monitor name."
echo "   Run 'hyprctl monitors' to find your monitor name."
echo "   Then log out and back in."
