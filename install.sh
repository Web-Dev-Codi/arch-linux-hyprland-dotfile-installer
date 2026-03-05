#!/usr/bin/env bash
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Helpers ──────────────────────────────────────────────────────────────────
print_header() {
  echo -e "\n${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${CYAN}${BOLD}  $1${RESET}"
  echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}
print_success() { echo -e "  ${GREEN}✓ $1${RESET}"; }
print_warning() { echo -e "  ${YELLOW}⚠ $1${RESET}"; }
print_error()   { echo -e "  ${RED}✗ $1${RESET}"; }
print_info()    { echo -e "    $1"; }

ask() {
  local prompt="$1"
  local default="${2:-Y}"
  local answer
  if [[ "$default" == "Y" ]]; then
    read -rp "$(echo -e "  ${YELLOW}${prompt} [Y/n]: ${RESET}")" answer
    answer="${answer:-Y}"
  else
    read -rp "$(echo -e "  ${YELLOW}${prompt} [y/N]: ${RESET}")" answer
    answer="${answer:-N}"
  fi
  [[ "$answer" =~ ^[Yy]$ ]]
}

# ─── Self-location ────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Phase 0: Safety checks ───────────────────────────────────────────────────
if [[ $EUID -eq 0 ]]; then
  print_error "Do not run this script as root. Run as your regular user."
  exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
  print_error "This installer is for Arch Linux only."
  exit 1
fi

# ─── Welcome banner ───────────────────────────────────────────────────────────
echo -e "\n${CYAN}${BOLD}"
echo "  ╔═══════════════════════════════════════════════════╗"
echo "  ║   Arch Linux + Hyprland Dotfile Installer        ║"
echo "  ║   by Web-Dev-Codi · github.com/Web-Dev-Codi      ║"
echo "  ╚═══════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "  This script will guide you through installing all dotfiles"
echo -e "  and optionally setting up prerequisites for Hyprland.\n"

# ─── Phase 1: Install yay ─────────────────────────────────────────────────────
print_header "Phase 1 — AUR Helper (yay)"

if command -v yay &>/dev/null; then
  print_success "yay is already installed, skipping."
else
  print_warning "yay is not installed."
  if ask "Install yay (AUR helper)?"; then
    print_info "Installing base-devel and git (required for makepkg)..."
    sudo pacman -S --needed --noconfirm base-devel git
    print_info "Cloning yay from AUR..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay-build
    (cd /tmp/yay-build && makepkg -si --noconfirm)
    rm -rf /tmp/yay-build
    print_success "yay installed."
  else
    print_warning "Skipping yay. AUR packages will not be available."
  fi
fi

# ─── Phase 2: Pacman prerequisites ───────────────────────────────────────────
print_header "Phase 2 — Arch Linux Prerequisites"

if ask "Install all prerequisites via pacman?"; then
  sudo pacman -S --needed \
    hyprland hyprpaper hypridle hyprlock \
    waybar wlogout swaync walker wofi nautilus \
    grim slurp satty jq brightnessctl playerctl \
    pipewire wireplumber pavucontrol \
    networkmanager blueman rfkill polkit-kde-agent \
    zsh bash fish fzf eza fastfetch btop \
    kitty ghostty neovim \
    fcitx5 fcitx5-gtk fcitx5-qt ttf-fira-sans
  print_success "Prerequisites installed."
else
  print_warning "Skipping prerequisites. Install them manually before starting Hyprland."
fi

# ─── Phase 3: Optional packages ───────────────────────────────────────────────
print_header "Phase 3 — Optional Packages"

if ask "Install firefox-developer-edition?" N; then
  sudo pacman -S --needed firefox-developer-edition
  print_success "firefox-developer-edition installed."
fi

if command -v yay &>/dev/null; then
  if ask "Install AUR optional packages (hyprlauncher, oh-my-posh)?" N; then
    yay -S --needed hyprlauncher oh-my-posh-bin
    print_success "AUR optional packages installed."
  fi
else
  print_warning "yay not available — skipping AUR optional packages."
fi

# ─── Phase 4: Nerd Fonts ──────────────────────────────────────────────────────
print_header "Phase 4 — Nerd Fonts"

if ask "Install Cascadia Code Nerd Font?"; then
  sudo pacman -S --needed ttf-cascadia-code-nerd
  print_success "Cascadia Code Nerd Font installed."
else
  print_warning "Skipping Nerd Font. Terminals and Waybar may display missing glyphs."
fi

# ─── Phase 5: Backup existing configs ────────────────────────────────────────
print_header "Phase 5 — Backup Existing Configs"

backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
backed_up=0

for item in "$SCRIPT_DIR"/.config/*/; do
  name="$(basename "$item")"
  target="$HOME/.config/$name"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_dir/.config"
    cp -r "$target" "$backup_dir/.config/$name"
    print_info "Backed up → $backup_dir/.config/$name"
    backed_up=1
  fi
done

for dotfile in .zshrc .bashrc; do
  target="$HOME/$dotfile"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_dir"
    cp "$target" "$backup_dir/$dotfile"
    print_info "Backed up → $backup_dir/$dotfile"
    backed_up=1
  fi
done

if [[ $backed_up -eq 1 ]]; then
  print_success "Backup complete: $backup_dir"
else
  print_success "No existing configs to back up."
fi

# ─── Phase 6: Copy dotfiles ───────────────────────────────────────────────────
print_header "Phase 6 — Installing Dotfiles"

mkdir -p "$HOME/.config"

for item in "$SCRIPT_DIR"/.config/*/; do
  name="$(basename "$item")"
  cp -r "$item" "$HOME/.config/$name"
  print_success "~/.config/$name"
done

for dotfile in .zshrc .bashrc; do
  cp "$SCRIPT_DIR/$dotfile" "$HOME/$dotfile"
  print_success "~/$dotfile"
done

# ─── Phase 7: Post-install summary ───────────────────────────────────────────
print_header "Installation Complete!"

echo -e "\n  ${GREEN}${BOLD}All dotfiles installed successfully.${RESET}\n"

echo -e "  ${BOLD}Next steps:${RESET}"
echo -e ""
echo -e "  ${YELLOW}1. Personalize your git identity:${RESET}"
echo -e "       git config --global user.name  'Your Name'"
echo -e "       git config --global user.email 'you@example.com'"
echo -e ""
echo -e "  ${YELLOW}2. Edit machine-specific Hyprland files:${RESET}"
echo -e "       ~/.config/hypr/monitors.conf"
echo -e "       ~/.config/hypr/workspaces.conf"
echo -e "       ~/.config/hypr/input/input.conf"
echo -e "       ~/.config/hypr/environment/env.conf"
echo -e ""
echo -e "  ${YELLOW}3. Log out and start a Hyprland session.${RESET}"
echo -e ""

if [[ $backed_up -eq 1 ]]; then
  echo -e "  ${CYAN}Your previous configs were backed up to:${RESET}"
  echo -e "  $backup_dir"
  echo -e ""
fi

echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
