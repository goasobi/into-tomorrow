function fish_user_key_bindings
  fish_vi_key_bindings
  bind -M insert \cf forward-char
  bind -M insert \ce forward-word
  bind -M insert \v 'tput reset; clear; commandline -f repaint'
  bind -M insert -m default jk backward-char force-repaint
end

fzf_key_bindings
