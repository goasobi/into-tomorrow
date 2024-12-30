local M = {
    {
        "stefandtw/quickfix-reflector.vim",
        ft = "qf",
    },
    {
        "tpope/vim-fugitive",
        event = { "VimEnter" },
    },
    {
        "tpope/vim-repeat",
        dependencies = { "tpope/vim-surround", "tpope/vim-unimpaired" },
        event = { "VimEnter" },
    },
}

return M
