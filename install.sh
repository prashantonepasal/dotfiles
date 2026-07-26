#!/bin/bash
# install.sh

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

echo "==> Installing official packages..."

# Split pkglist into official + AUR
OFFICIAL_PKGS=()
AUR_PKGS=()

while read -r pkg; do
    if pacman -Si "$pkg" &>/dev/null; then
        OFFICIAL_PKGS+=("$pkg")
    else
        AUR_PKGS+=("$pkg")
    fi
done < "$DOTFILES/pkglist.txt"

# Install official packages
if [ ${#OFFICIAL_PKGS[@]} -gt 0 ]; then
    sudo pacman -S --needed "${OFFICIAL_PKGS[@]}"
fi

echo "==> Ensuring yay is installed..."

if ! command -v yay &>/dev/null; then
    sudo pacman -S --needed base-devel git

    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    cd "$tmpdir/yay"
    makepkg -si --noconfirm
    cd -
fi

echo "==> Installing AUR packages..."

if [ ${#AUR_PKGS[@]} -gt 0 ]; then
    yay -S --needed "${AUR_PKGS[@]}"
fi

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
