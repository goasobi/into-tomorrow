local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.runtimepath:prepend(lazypath)

local cond = function(plugin)
    if not vim.g.vscode then
        return true
    end

    local enabled = {
        "lazy.nvim",
        "vim-surround",
        "vim-unimpaired",
    }
    return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

require("lazy").setup("plugins", {
    defaults = {
        cond = cond,
    },
    change_detection = {
        enabled = false,
        notify = false,
    },
    install = { colorscheme = { "vim" } },
})
