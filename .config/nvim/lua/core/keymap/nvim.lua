local opts = { noremap = true, silent = true }

-- vim
vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("n", "gx", ":execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>", opts)

-- split
vim.keymap.set("n", "<C-S-left>", "5<C-w><")
vim.keymap.set("n", "<C-S-down>", "5<C-w>+")
vim.keymap.set("n", "<C-S-up>", "5<C-w>-")
vim.keymap.set("n", "<C-S-right>", "5<C-w>>")

-- lsp
vim.keymap.set("n", "gf", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ts", function()
    require("plugins.lsp.format").toggle()
end)
vim.keymap.set("n", "<leader>td", function()
    require("plugins.lsp.diagnostic").toggle()
end)

-- telescope.nvim
vim.keymap.set("n", ";f", function()
    require("telescope.builtin").find_files()
end)
vim.keymap.set("n", ";r", function()
    require("telescope.builtin").oldfiles({ only_cwd = true })
end)
vim.keymap.set("n", ";g", function()
    require("telescope").extensions.live_grep_args.live_grep_args()
end)
vim.keymap.set("n", ";G", function()
    require("telescope.builtin").live_grep({
        additional_args = { "--files-with-matches" },
    })
end)
vim.keymap.set("n", ";b", function()
    require("telescope.builtin").buffers()
end)
vim.keymap.set("n", ";h", function()
    require("telescope.builtin").help_tags()
end)
vim.keymap.set("n", ";q", function()
    require("telescope.builtin").quickfixhistory()
end)

-- nvim-tree.lua
vim.keymap.set("n", ";F", ":NvimTreeOpen<cr>", opts)
vim.keymap.set("n", ";T", ":NvimTreeOpen<cr>", opts)

-- vim-dadbod-ui
vim.keymap.set("n", "<leader>db", ":DBUIToggle<cr>", opts)

-- syntax highlight
vim.keymap.set("n", "<leader>th", function()
    if vim.g.syntax_on then
        vim.cmd("syntax off")
    else
        vim.cmd("syntax on")
    end
    vim.cmd("TSToggle highlight")
end)

-- compare two files.
-- the files must be in two splits before activating the cmd
vim.keymap.set("n", "<leader>df", ":windo diffthis<cr>", opts)
