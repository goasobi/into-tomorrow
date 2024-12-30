# 明日に駆ける

## Increase key repeat rate on macOS

```bash
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms)
```

## Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd homebrew && chmod u+x restore.sh && ./restore.sh
```

## Create Symbolic Links

```bash
ln -s ~/.dotfiles/.config/fish ~/.config/fish
ln -s ~/.dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.wezterm.lua ~/.wezterm.lua
ln -s ~/.dotfiles/.yabairc ~/.yabairc
```

## Configure fish shell

1. Set fish shell as default shell

   ```bash
   sudo bash -c 'echo $(which fish) >> /etc/shells'
   chsh -s $(which fish)
   ```

2. Configure tide (fish plugin)

   ```bash
   tide configure --auto --style=Lean --prompt_colors='16 colors' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Few icons' --transient=No
   ```

## Configure ranger

1. Copy default configs

   ```bash
   mkdir -p ~/.config/ranger
   ranger --copy-config=all
   ```

2. Update `rc.conf`

   **Before**

   ```
   set preview_images false
   set preview_images_method w3m
   ```

   **After**

   ```
   set preview_images true
   ```

## Start yabai service

```bash
brew services start yabai
```
