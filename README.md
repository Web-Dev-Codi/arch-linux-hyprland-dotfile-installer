![Banner](https://capsule-render.vercel.app/api?type=waving&color=1793D1,0F172A,4A90D9&height=220&section=header&text=Arch%20Linux%20%2B%20Hyprland%20Dotfiles&fontSize=42&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Production-ready%20Hyprland%20setup%20for%20Arch%20Linux&descAlignY=58&descFontSize=18)

<div align="center">

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)](https://hyprland.org)
[![Neovim](https://img.shields.io/badge/Neovim_LazyVim-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://lazyvim.github.io)
[![Shell](https://img.shields.io/badge/Shell-Zsh%20%7C%20Fish%20%7C%20Bash-89DCEB?style=for-the-badge&logo=gnubash&logoColor=black)](https://www.zsh.org)
[![License](https://img.shields.io/github/license/Web-Dev-Codi/arch-linux-hyprland-dotfile-installer?style=for-the-badge&color=FF2D78&labelColor=0A0A1A)](https://github.com/Web-Dev-Codi/arch-linux-hyprland-dotfile-installer/blob/main/LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/Web-Dev-Codi/arch-linux-hyprland-dotfile-installer?style=for-the-badge&color=00D4FF&labelColor=0A0A1A)](https://github.com/Web-Dev-Codi/arch-linux-hyprland-dotfile-installer/commits/main)
[![Stars](https://img.shields.io/github/stars/Web-Dev-Codi/arch-linux-hyprland-dotfile-installer?style=for-the-badge&color=FFD700&labelColor=0A0A1A)](https://github.com/Web-Dev-Codi/arch-linux-hyprland-dotfile-installer/stargazers)

</div>

> Production-ready dotfiles for Arch Linux with Hyprland, modular shell configs (Zsh, Bash, Fish), Neovim (LazyVim), and a clear hardware-agnostic install path.

<!-- TODO: Add a screenshot or GIF of your Hyprland desktop here -->
<!-- Example: ![Desktop Preview](assets/preview.png) -->

---

## Table of Contents

- [Highlights](#highlights)
- [Repository Layout](#repository-layout)
- [Neovim Configuration](#neovim-configuration)
- [Prerequisites](#prerequisites-arch-linux)
- [Install](#install)
- [Hardware-Agnostic Setup Checklist](#hardware-agnostic-setup-checklist)
- [Troubleshooting](#troubleshooting)
- [Updating Dotfiles](#updating-dotfiles)

---

## Highlights

- Hyprland setup split into modular files for keybinds, input, visuals, autostart, monitors, workspaces, and app/window rules.
- Waybar, wlogout, swaync, waypaper, and helper scripts for screenshots, power actions, and wallpaper management.
- Shell stack for `zsh`, `bash`, and `fish` with aliases, prompt customization, and fastfetch autostart.
- Terminal + editor configs for Ghostty, Kitty, and Neovim (LazyVim-based).
- Clear install path that avoids machine-specific state and sensitive data.

## Repository Layout

| Path | Purpose |
| --- | --- |
| `.config/hypr` | Hyprland core config, wallpaper assets, lock/idle config, scripts |
| `.config/waybar` | Waybar modules, style, launch/toggle scripts |
| `.config/wlogout` | Logout menu layout/theme and actions |
| `.config/swaync` | Notification daemon config/theme |
| `.config/zshrc`, `.config/bashrc`, `.config/fish` | Modular shell configs and aliases |
| `.config/nvim` | Neovim (LazyVim) config |
| `.config/kitty`, `.config/ghostty` | Terminal configs |
| `.zshrc`, `.bashrc` | Root shell entrypoints |
| `.gitconfig` | Git defaults (must be personalized before use) |

## Neovim Configuration

The Neovim setup in this repo is **fully available** after you run the clone-and-install steps. Nothing is omitted: the same config you get from the repo is the one used day to day.

- **Base:** [LazyVim](https://github.com/LazyVim/LazyVim) on [lazy.nvim](https://github.com/folke/lazy.nvim). Default colorschemes installed: **Tokyo Night** and **Habamax** (LazyVim’s default).
- **Location:** `~/.config/nvim` (or `$HOME/.config/nvim`). Entry point is `init.lua`; plugins and options live under `lua/config/` and `lua/plugins/`.
- **Custom options:** Swap files are disabled (`opt.swapfile = false`) in `lua/config/options.lua`. All other LazyVim defaults (keymaps, autocmds) are in use unless you override them.

### LazyVim extras included

The config enables a broad set of LazyVim “extras” so language support, AI, and editor features work out of the box. These are declared in `lazyvim.json` and loaded via LazyVim’s plugin spec.

<details>
<summary>View all LazyVim extras</summary>

| Category | Extras |
| --- | --- |
| **AI** | Copilot, Copilot Chat, Sidekick |
| **Coding** | Luasnip, mini-comment, mini-snippets, mini-surround, Neogen, nvim-cmp, yanky |
| **Debug (DAP)** | Core DAP, nlua |
| **Editor** | Aerial, dial, inc-rename, mini-diff, mini-files, mini-move, navic, refactoring |
| **Formatting** | Prettier |
| **Languages** | Docker, Git, Markdown, PHP, Python, Rust, SQL, Svelte, Tailwind, TOML, TypeScript, Typst, YAML, Zig |
| **Linting** | ESLint |
| **Testing** | Test core |
| **UI** | Edgy, indent-blankline, mini-animate, mini-indentscope, mini-starter, smear-cursor, treesitter-context |
| **Utilities** | dot, mini-hipatterns, startuptime |
| **Other** | VSCode-style extras |

</details>

LSP servers and tools (e.g. for the languages above) are installed on demand via **Mason** when you open the relevant file types; you don’t need to pre-install them elsewhere.

For LazyVim usage, keymaps, and plugin docs, see the [LazyVim documentation](https://lazyvim.github.io/installation).

## Prerequisites (Arch Linux)

The packages below are installed automatically when you run `install.sh`. This section is a reference for what gets installed.

Install base dependencies with `pacman`:

```bash
sudo pacman -S --needed hyprland hyprpaper hypridle hyprlock waybar wlogout swaync walker wofi nautilus grim slurp satty jq brightnessctl playerctl pipewire wireplumber pavucontrol networkmanager blueman rfkill polkit-kde-agent zsh bash fish fzf eza fastfetch btop kitty ghostty neovim fcitx5 fcitx5-gtk fcitx5-qt ttf-fira-sans
```

Optional packages referenced by keybinds or scripts:

```bash
sudo pacman -S --needed firefox-developer-edition
```

Optional AUR packages (if you use `yay`):

```bash
yay -S --needed hyprlauncher oh-my-posh-bin
```

Install at least one Nerd Font used by terminals/bar:

```bash
sudo pacman -S --needed ttf-cascadia-code-nerd
```

## Install

> **Run as your regular user — not root.**

### 1) Clone the repo

```bash
git clone https://github.com/Web-Dev-Codi/arch-linux-hyprland-dotfile-installer.git
cd arch-linux-hyprland-dotfile-installer
```

### 2) Run the installer

```bash
bash install.sh
```

The script walks you through each phase with interactive prompts:

- **Phase 1** — Install `yay` (AUR helper) if not already present
- **Phase 2** — Install all Arch Linux prerequisites via `pacman`
- **Phase 3** — Optional packages (firefox-developer-edition, hyprlauncher, oh-my-posh)
- **Phase 4** — Nerd Font installation
- **Phase 5** — Backup any existing configs that would be overwritten
- **Phase 6** — Copy all dotfiles to their correct locations in `$HOME`

### 3) Personalize git identity

Do not keep someone else's identity in your Git config:

```bash
git config --global user.name 'Your Name'
git config --global user.email 'you@example.com'
```

### 4) Start and verify

Log out and start a Hyprland session, then validate:

```bash
hyprctl monitors
hyprctl workspaces
pgrep -a hyprpaper
pgrep -a hypridle
pgrep -a waybar
```

If you changed files while logged in, reload:

```bash
hyprctl reload
```

## Hardware-Agnostic Setup Checklist

These files are expected to be edited per machine:

- `~/.config/hypr/monitors.conf`
- `~/.config/hypr/workspaces.conf`
- `~/.config/hypr/hyprpaper/hyprpaper.conf`
- `~/.config/hypr/hyprpaper/persistent-wallpaper.conf`
- `~/.config/hypr/input/input.conf`
- `~/.config/hypr/environment/env.conf`

Recommended adaptation steps:

1. Configure displays and monitor names for your hardware.
2. Update workspace-to-monitor bindings after monitor changes.
3. Remove or update device-specific input entries (example: custom mouse names).
4. Review GPU-specific environment variables and keep only what matches your hardware.
5. Regenerate persisted wallpaper state if absolute paths reference another username:

```bash
rm -f "$HOME/.config/hypr/hyprpaper/persistent-wallpaper.conf"
```

## Troubleshooting

### Waybar does not start

Run directly and inspect output:

```bash
waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css"
```

### Hyprpaper wallpaper does not apply

```bash
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$HOME/.config/hypr/assets/astronaut.png"
for monitor in $(hyprctl monitors -j | jq -r '.[] | .name'); do
  hyprctl hyprpaper wallpaper "$monitor,$HOME/.config/hypr/assets/astronaut.png"
done
```

### Fcitx5 not active

```bash
systemctl --user restart fcitx5
printenv INPUT_METHOD
printenv QT_IM_MODULE
printenv XMODIFIERS
printenv SDL_IM_MODULE
```

### Screenshot pipeline fails

Verify required tools:

```bash
command -v grim
command -v slurp
command -v satty
```

## Updating Dotfiles

Pull the latest changes and re-run the installer:

```bash
git pull
bash install.sh
```

The installer will back up any configs it would overwrite before copying. If an update breaks your setup, restore from the backup directory printed at the end of the install run.

---

<div align="center">

Made with ❤️ by [Web-Dev-Codi](https://github.com/Web-Dev-Codi) · Berlin, Germany 🇩🇪

</div>

![Footer](https://capsule-render.vercel.app/api?type=waving&color=4A90D9,0F172A,1793D1&height=120&section=footer)
