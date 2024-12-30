local opt = vim.opt

vim.cmd("syntax off")
vim.cmd("colorscheme vim")

opt.autoindent = true
opt.backspace = "indent,eol,start"
opt.backup = false
opt.conceallevel = 0
opt.copyindent = true
opt.ea = false
opt.encoding = "utf-8"
opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkon500-Cursor/lCursor"
opt.hidden = true
opt.lazyredraw = true
opt.laststatus = 3
opt.pumblend = 8
opt.pumheight = 15
opt.path = "+=**"
opt.scrolloff = 0
opt.smoothscroll = true
opt.shada = "!,'300,<50,s10,h"
opt.showcmd = false
opt.sidescrolloff = 5
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.termguicolors = true
opt.ttimeout = true
opt.ttimeoutlen = 100
opt.wrap = true
opt.winblend = 8
opt.writebackup = false

-- Searches
opt.hlsearch = false
opt.smartcase = true

-- Tab settings
opt.expandtab = true
opt.smarttab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = -1

-- Tab completion settings
opt.wildignorecase = true
opt.wildignore = ".git,.hg,.svn"
opt.wildignore = opt.wildignore + "*.pyc,*.o,*.out"
opt.wildignore = opt.wildignore + "*.jpg,*.jpeg,*.png,*.gif"
opt.wildignore = opt.wildignore + "*.zip,*.rar,*.tar.gz"
opt.wildignore = opt.wildignore + "*.DS_Store"
opt.wildignore = opt.wildignore + "*/node_modules/*,*/vendor/*"

if vim.fn.executable("rg") == 1 then
    opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden --glob '!.git'"
    -- opt.grepformat = "%f:%l:%c:%m"
end

local function statusline()
    local file_name = "%f"
    local modified = "%m"
    local align_right = "%="
    local fileencoding = "%{&fileencoding?&fileencoding:&encoding}"
    local fileformat = "[%{&fileformat}]"
    local linecol = "%l:%c"

    return string.format(" %s%s%s%s%s %s ", file_name, modified, align_right, fileencoding, fileformat, linecol)
end

opt.statusline = statusline()
