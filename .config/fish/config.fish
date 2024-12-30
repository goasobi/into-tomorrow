set fish_greeting ""

# cursor shape
set -g fish_cursor_default     block      blink
set -g fish_cursor_insert      line       blink
set -g fish_cursor_replace_one underscore blink
set -g fish_cursor_visual      block

if status is-interactive
  eval (/opt/homebrew/bin/brew shellenv)
  source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

source ~/.config/fish/env.fish
source ~/.config/fish/alias.fish

direnv hook fish | source
zoxide init --cmd cd fish | source
