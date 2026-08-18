# Setup Instructions

This repository contains my shell, terminal, editor, and development environment setup.

## Contents

* Zsh configuration
* Powerlevel10k prompt setup
* Neovim configuration
* Ghostty terminal configuration
* Fastfetch setup
* Conda environment exports
* Git configuration
* Chezmoi-managed dotfiles

---

# 1. Install Core Dependencies

## Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add Homebrew to PATH:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

---

# 2. Install Required Applications

## Terminal

Install Ghostty:

```bash
brew install --cask ghostty
```

## Shell Utilities

```bash
brew install fastfetch
brew install tmux
brew install fzf
brew install ripgrep
brew install fd
brew install eza
brew install bat
brew install zoxide
brew install lazygit
brew install git
brew install wget
brew install tree
brew install neovim
brew install chezmoi
```

## Fonts

Install Nerd Fonts:

```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

---

# 3. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

# 4. Install Powerlevel10k

Install Powerlevel10k:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Set theme in `~/.zshrc`:

```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

---

# 5. Install Miniconda / Anaconda

Recommended:

* Miniconda
* Miniforge

Avoid full Anaconda unless specifically needed.

After installation:

```bash
conda init zsh
```

---

# 6. Clone Dotfiles

```bash
git clone <YOUR_DOTFILES_REPO>
```

---

# 7. Initialize Chezmoi

```bash
chezmoi init <YOUR_DOTFILES_REPO>
chezmoi apply
```

Update tracked files:

```bash
chezmoi re-add
```

Pull latest configuration:

```bash
chezmoi update
```

View tracked repository:

```bash
chezmoi cd
```

---

# 8. Restore Conda Environments

List available exported environments:

```bash
ls ~/conda_envs
```

Create environment:

```bash
conda env create -f rl.yml
```

Activate:

```bash
conda activate rl
```

---

# 9. Neovim Setup

Install pynvim 

```bash
pip install pynvim
```

Open Neovim:

```bash
nvim
```

Allow Lazy.nvim plugins to install automatically.

Run:

```vim
:checkhealth
```

Install Mason tools if required.

---

# 10. Git Setup

Set Git identity:

```bash
git config --global user.name "NithinVS2k4"
git config --global user.email "nithinvshenoy@gmail.com"
```

Generate SSH key:

```bash
ssh-keygen -t ed25519 -C "nithinvshenoy@gmail.com"
```

Add SSH key to GitHub.

---

# 11. Useful Custom Commands

## pokefetch

Run the following command:
```bash
cd ~/Pictures && python3 get_sprites.py --cool100
``` 

Then ensure pokefetch symlink is in `~/.local/bin/`.

If not, check for `~/.config/fastfetch/pokefetch` and run:

```bash
ln -s ~/.config/fastfetch/pokefetch ~/.local/bin/pokefetch
```

Once that is done, run:

```bash
chmod +x ~/.local/bin/pokefetch
```

Also ensure `~/.local/bin` is in PATH by running `echo $PATH`. If not, run:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then run the chmod command again.


## texview


---

# 12. Common Utilities

## View images in terminal

```bash
view image.png
```

Alias expected to point to:

```bash
viu -y 1
```

---

# 13. Recommended Cleanup

Remove unnecessary legacy packages:

```bash
sudo rm -rf /Library/Frameworks/Mono.framework
sudo rm -f /etc/paths.d/mono-commands
```

---

# 14. Performance Notes

If shell startup or invalid commands are slow:

* Check Conda initialization
* Reduce plugin count
* Avoid unnecessary command-not-found handlers
* Prefer Miniforge/Micromamba over full Anaconda

Test clean shell:

```bash
zsh -f
```

Profile Zsh:

```bash
zmodload zsh/zprof
```

---

# 15. Recommended Backup Strategy

Keep backed up:

* Dotfiles repository
* Conda YAML exports
* SSH keys
* Brewfile
* VSCode extension list

Generate Brewfile:

```bash
brew bundle dump --force
```

VSCode extensions:

```bash
code --list-extensions > vscode_extensions.txt
```

---

# 16. Important Files

Core tracked files:

```text
~/.zshrc
~/.zprofile
~/.p10k.zsh
~/.gitconfig
~/.condarc
~/.config/nvim
~/.config/ghostty
~/.config/fastfetch
```

---

# 17. Notes

* Do not commit secrets/API keys.
* Remove `prefix:` from Conda YAMLs.
* Avoid tracking cache directories.
* Avoid tracking Raycast extension internals.

