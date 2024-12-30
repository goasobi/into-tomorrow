set nocompatible

" Colors

syntax on
filetype on

if has('nvim')
  colorscheme vim
endif
augroup ColorOverrides
    autocmd!
    autocmd ColorScheme * hi Comment guifg=darkgreen
                      \ | hi Constant guifg=darkred
                      \ | hi Identifier guifg=#000000
                      \ | hi PreProc guifg=blue
                      \ | hi Special guifg=blue
                      \ | hi Statement guifg=blue
                      \ | hi Title guifg=darkred
                      \ | hi Type guifg=#000000
                      \ | hi DiagnosticHint guifg=blue
                      \ | hi DiagnosticInfo guifg=#1d3ccf
                      \ | hi DiagnosticOk guifg=#005d26
                      \ | hi DiagnosticWarn guifg=#ef7727
                      \ | hi EndOfBuffer guifg=#ffffff
                      \ | hi NormalFloat guibg=#fffffe
                      \ | hi SignColumn guifg=#ffffff
augroup END

" File browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
let g:netrw_winsize=20

" Basic Options
set autoindent
set autoread
set backspace=indent,eol,start
set copyindent
set diffopt+=iwhite
set encoding=utf-8
set hidden
set history=1000
set lazyredraw
set mouse=a
set noshowcmd
set noswapfile
set nowrap
set path+=**
set scrolloff=1
set showcmd
set sidescrolloff=5
set splitbelow
set splitright
set termguicolors
set ttimeout
set ttimeoutlen=100
set vb t_vb=
set wildmenu
set wrap

" Searches
set incsearch
set nohlsearch
set smartcase

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden\ --glob\ '!.git'
  set grepformat=%f:%l:%c:%m
endif

" Tab settings
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Tab completion settings
set wildignorecase
set wildignore+=*.pyc,*.o,*.out
set wildignore+=*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.zip,*.rar,*.tar.gz
set wildignore+=*.DS_Store
set wildignore+=*/.shadow/*,*/bower_modules/*,*/node_modules/*,*/vendor/*

" Status line
if has('nvim')
  set laststatus=3
  set guicursor=""
else
  set laststatus=2

  " set Vim-specific sequences for RGB colors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set statusline=
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\%{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %l:%c
set statusline+=\ "

" Key remap
inoremap <silent> jk    <Esc>
tnoremap <silent> <Esc> <C-\><C-n>

"" Navigation
nnoremap <silent> j gj
nnoremap <silent> k gk

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

tnoremap <silent> <C-h> <C-w>h
tnoremap <silent> <C-j> <C-w>j
tnoremap <silent> <C-k> <C-w>k
tnoremap <silent> <C-l> <C-w>l

"" Split resize
nnoremap <silent> <C-S-left>  5<C-w><
nnoremap <silent> <C-S-down>  5<C-w>+
nnoremap <silent> <C-S-up>    5<C-w>-
nnoremap <silent> <C-S-right> 5<C-w>>

tnoremap <silent> <C-S-left>  5<C-w><
tnoremap <silent> <C-S-down>  5<C-w>+
tnoremap <silent> <C-S-up>    5<C-w>-
tnoremap <silent> <C-S-right> 5<C-w>>

"" External command
nnoremap <silent> <leader>bl :execute "!git blame -L " . eval(line(".")-5) . ",+10 %"<cr>
