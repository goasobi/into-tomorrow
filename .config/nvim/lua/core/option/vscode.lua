local opt = vim.opt

opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkon500-Cursor/lCursor"
opt.hlsearch = false
opt.smartcase = true

if vim.loop.os_uname().sysname == "Linux" then
    opt.clipboard = "unnamedplus"
else
    opt.clipboard = "unnamed"
end
